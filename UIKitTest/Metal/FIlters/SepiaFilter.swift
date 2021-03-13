//
//  SepiaFilter.swift
//  UIKitTest
//
//  Created by Home on 3/6/21.
//


public class SepiaFilter: MediaFilter {
    private let kSepiaFilterName = "sepia_shader"
    
    public override init() {
        super.init()
        
        name = kSepiaFilterName
        hasCustomShader = true
    }
}
