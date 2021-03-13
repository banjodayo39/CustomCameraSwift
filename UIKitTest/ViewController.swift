//
//  ViewController.swift
//  UIKitTest
//
//  Created by Home on 3/4/21.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var captureSession : AVCaptureSession!

    lazy var  countryPopUpView: CountryView =  {
        let view = CountryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       // addCountryPopUpView()
        checkPermissions()
    }


    func addCountryPopUpView(){
        view.addSubview(countryPopUpView)
        countryPopUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        countryPopUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countryPopUpView.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        countryPopUpView.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
    }
    
    //MARK:- Permissions
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
            case .authorized:
                return
            case .denied:
                abort()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                                                { (authorized) in
                                                    if(!authorized){
                                                        abort()
                                                    }
                                                })
            case .restricted:
                abort()
            @unknown default:
                fatalError()
        }
    }
}

