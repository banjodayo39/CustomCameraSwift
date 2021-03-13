//
//  ThresholdFilter.swift
//  UIKitTest
//
//  Created by Home on 3/6/21.
//

import UIKit

public class ThresholdFilter: MediaFilter {
    private let kThresholdFilterName = "threshold_filter"
    private let kDefaultThresholdValue: Float = 0.5
    
    public var thresholdValue: Float = 0
    
    public override init() {
        super.init()
        
        name = kThresholdFilterName
        thresholdValue = kDefaultThresholdValue
    }
}
