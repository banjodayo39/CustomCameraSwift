//
//  GraphicContext.swift
//  UIKitTest
//
//  Created by Home on 3/6/21.
//

import Foundation
import Metal
import MetalKit

public class GraphicContext {
    var mLibrary: MTLLibrary?
    var mDevice: MTLDevice?
    var mCommandQueue: MTLCommandQueue?
    var mTextureLoader: MTKTextureLoader?
    var mediaFilter: MediaFilter?
    
    init(mediaFilter: MediaFilter) {
        mDevice = MTLCreateSystemDefaultDevice()
        
        let shaderSource = FilterShaderProvider.provideShader(filter: mediaFilter)
        do {
            try mLibrary = mDevice?.makeLibrary(source: shaderSource, options: nil)
            mCommandQueue = mDevice?.makeCommandQueue()
            mTextureLoader = MTKTextureLoader(device: mDevice!)
        }
        catch {
            print(error)
        }      
    }
}
