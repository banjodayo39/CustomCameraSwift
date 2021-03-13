//
//  ColorFIlter.swift
//  UIKitTest
//
//  Created by Home on 3/6/21.
//

import UIKit

public class ColorFilter: MediaFilter {
    private let kColorFilterName = "color_shader"
    
    public var r: CGFloat = 0.0
    public var g: CGFloat = 0.0
    public var b: CGFloat = 0.0
    
    public override init() {
        super.init()
        
        name = kColorFilterName
        hasCustomShader = true
    }
}
