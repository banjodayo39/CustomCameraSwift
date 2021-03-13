//
//  MediaElement.swift
//  UIKitTest
//
//  Created by Home on 3/6/21.
//

import UIKit

public enum MediaElementType {
    case image
    case view
    case text
}

public class MediaElement {
    public var frame: CGRect = .zero
    public var type: MediaElementType = .image
    
    public private(set) var contentImage: UIImage! = nil
    public private(set) var contentView: UIView! = nil
    public private(set) var contentText: NSAttributedString! = nil
    
    public init(image: UIImage) {
        contentImage = image
        type = .image
    }
    
    public init(view: UIView) {
        contentView = view
        type = .view
    }
    
    public init(text: NSAttributedString) {
        contentText = text
        type = .text
    }
}
