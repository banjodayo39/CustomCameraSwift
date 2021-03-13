//
//  MediaProcessor.swift
//  UIKitTest
//
//  Created by Home on 3/6/21.
//

import UIKit
import AVFoundation


public class MediaProcessor {
    public var filterProcessor: FilterProcessor! = nil
    
    public init() {}
    
    // MARK: - process elements
    public func processElements(item: MediaItem, completion: @escaping ProcessCompletionHandler) {
        item.type == .video ? processVideoWithElements(item: item, completion: completion) : processImageWithElements(item: item, completion: completion)
    }
}

extension MediaProcessor {
    func processImageWithElements(item: MediaItem, completion: @escaping ProcessCompletionHandler) {
        if item.filter != nil {
            filterProcessor = FilterProcessor(mediaFilter: item.filter)
            filterProcessor.processImage(image: item.sourceImage.fixedOrientation(), completion: { [weak self] (success, finished, image, error) in
                if error != nil {
                    completion(MediaProcessResult(processedUrl: nil, image: nil), error)
                } else if image != nil && finished == true {
                    completion(MediaProcessResult(processedUrl: nil, image: image), nil)
                    
                    let updatedMediaItem = MediaItem(image: image!)
                    updatedMediaItem.add(elements: item.mediaElements)
                    self?.processItemAfterFiltering(item: updatedMediaItem, completion: completion)
                }
            })
            
        } else {
            processItemAfterFiltering(item: item, completion: completion)
        }
    }
    
    func processItemAfterFiltering(item: MediaItem, completion: @escaping ProcessCompletionHandler) {
        UIGraphicsBeginImageContextWithOptions(item.sourceImage.size, false, item.sourceImage.scale)
        item.sourceImage.draw(in: CGRect(x: 0, y: 0, width: item.sourceImage.size.width, height: item.sourceImage.size.height))
        
        for element in item.mediaElements {
            if element.type == .view {
                UIImage(view: element.contentView).draw(in: element.frame)
            } else if element.type == .image {
                element.contentImage.draw(in: element.frame)
            } else if element.type == .text {
                element.contentText.draw(in: element.frame)
            }
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        completion(MediaProcessResult(processedUrl: nil, image: newImage), nil)
    }
}

let kMediaContentDefaultScale: CGFloat = 1
let kProcessedTemporaryVideoFileName = "/processed.mov"
let kMediaContentTimeValue: Int64 = 1
let kMediaContentTimeScale: Int32 = 30

extension MediaProcessor {
    func processVideoWithElements(item: MediaItem, completion: @escaping ProcessCompletionHandler) {
        let mixComposition = AVMutableComposition()
        let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let clipVideoTrack = item.sourceAsset.tracks(withMediaType: AVMediaType.video).first
        let clipAudioTrack = item.sourceAsset.tracks(withMediaType: AVMediaType.audio).first
        
        do {
            try compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: item.sourceAsset.duration), of: clipVideoTrack!, at: CMTime.zero)
        } catch {
            completion(MediaProcessResult(processedUrl: nil, image: nil), error)
        }
        
        if (clipAudioTrack != nil) {
            let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            do {
                try compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: item.sourceAsset.duration), of: clipAudioTrack!, at: CMTime.zero)
            } catch {
                completion(MediaProcessResult(processedUrl: nil, image: nil), error)
            }
        }
        
        compositionVideoTrack?.preferredTransform = (item.sourceAsset.tracks(withMediaType: AVMediaType.video).first?.preferredTransform)!
        
        let sizeOfVideo = item.size
        
        let optionalLayer = CALayer()
        processAndAddElements(item: item, layer: optionalLayer)
        optionalLayer.frame = CGRect(x: 0, y: 0, width: sizeOfVideo.width, height: sizeOfVideo.height)
        optionalLayer.masksToBounds = true
        
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: sizeOfVideo.width, height: sizeOfVideo.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: sizeOfVideo.width, height: sizeOfVideo.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(optionalLayer)
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTimeMake(value: kMediaContentTimeValue, timescale: kMediaContentTimeScale)
        videoComposition.renderSize = sizeOfVideo
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: mixComposition.duration)
        
        let videoTrack = mixComposition.tracks(withMediaType: AVMediaType.video).first
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack!)
        layerInstruction.setTransform(transform(avAsset: item.sourceAsset, scaleFactor: kMediaContentDefaultScale), at: CMTime.zero)
        
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]
        
        let processedUrl = processedMoviePath()
        clearTemporaryData(url: processedUrl, completion: completion)
        
        let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.videoComposition = videoComposition
        exportSession?.outputURL = processedUrl
        exportSession?.outputFileType = AVFileType.mp4
        
        exportSession?.exportAsynchronously(completionHandler: {
            if exportSession?.status == AVAssetExportSession.Status.completed {
                completion(MediaProcessResult(processedUrl: processedUrl, image: nil), nil)
            } else {
                completion(MediaProcessResult(processedUrl: nil, image: nil), exportSession?.error)
            }
        })
    }
    
    // MARK: - private
    private func processAndAddElements(item: MediaItem, layer: CALayer) {
        for element in item.mediaElements {
            var elementLayer: CALayer! = nil
            
            if element.type == .view {
                elementLayer = CALayer()
                elementLayer.contents = UIImage(view: element.contentView).cgImage
            } else if element.type == .image {
                elementLayer = CALayer()
                elementLayer.contents = element.contentImage.cgImage
            } else if element.type == .text {
                elementLayer = CATextLayer()
                (elementLayer as! CATextLayer).string = element.contentText
            }
            
            elementLayer.frame = element.frame
            layer.addSublayer(elementLayer)
        }
    }
    
    private func processedMoviePath() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + kProcessedTemporaryVideoFileName
        return URL(fileURLWithPath: documentsPath)
    }
    
    private func clearTemporaryData(url: URL, completion: ProcessCompletionHandler!) {
        if (FileManager.default.fileExists(atPath: url.path)) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                completion(MediaProcessResult(processedUrl: nil, image: nil), error)
            }
        }
    }
    
    private func transform(avAsset: AVAsset, scaleFactor: CGFloat) -> CGAffineTransform {
        var offset = CGPoint.zero
        var angle: Double = 0
        
        switch avAsset.contentOrientation {
            case .left:
                offset = CGPoint(x: avAsset.contentCorrectSize.height, y: avAsset.contentCorrectSize.width)
                angle = Double.pi
            case .right:
                offset = CGPoint.zero
                angle = 0
            case .down:
                offset = CGPoint(x: 0, y: avAsset.contentCorrectSize.width)
                angle = -(Double.pi / 2)
            default:
                offset = CGPoint(x: avAsset.contentCorrectSize.height, y: 0)
                angle = Double.pi / 2
        }
        
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let translation = scale.translatedBy(x: offset.x, y: offset.y)
        let rotation = translation.rotated(by: CGFloat(angle))
        
        return rotation
    }
}
