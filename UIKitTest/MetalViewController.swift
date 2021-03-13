//
//  MetalViewController.swift
//  UIKitTest
//
//  Created by Home on 3/6/21.
//

import UIKit

class MetalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let metalCircleView = MetalCircleView()
        view.addSubview(metalCircleView)
        metalCircleView.translatesAutoresizingMaskIntoConstraints = false
        //constraining to window
        metalCircleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        metalCircleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        metalCircleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        metalCircleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
