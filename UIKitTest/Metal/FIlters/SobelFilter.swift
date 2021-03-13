//
//  SobelFilter.swift
//  UIKitTest
//
//  Created by Home on 3/6/21.
//

import UIKit

public class SobelFilter: MediaFilter {
    private let kSobelFilterName = "sobel_filter"
    
    public override init() {
        super.init()
        
        name = kSobelFilterName
    }
}
