//
//  BlurFilter.swift
//  UIKitTest
//
//  Created by Home on 3/6/21.
//

import UIKit

public class BlurFilter: MediaFilter {
    private let kBlurFilterName = "blur_filter"
    private let kBlurSigmaDefaultValue: Float = 45
    
    public var sigma: Float = 0
    
    public override init() {
        super.init()
        
        sigma = kBlurSigmaDefaultValue
        name = kBlurFilterName
    }
}
