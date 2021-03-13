//
//  ViewController.swift
//  UIKitTest
//
//  Created by Home on 3/4/21.
//

import UIKit


class FeedsViewController: UIViewController {
    
    var imageView : UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "watermark")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var imageView2 : UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "watermark")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }() 
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    func setUpView(){
        view.addSubview(imageView2)
        view.addSubview(imageView)
        
        imageView2.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        imageView2.widthAnchor.constraint(equalToConstant: 160).isActive = true
        imageView2.heightAnchor.constraint(equalToConstant: 160).isActive = true

        imageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        imageView.topAnchor.constraint(equalTo: imageView2.bottomAnchor, constant: 30).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let image = UIImage(named: "watermark") ?? UIImage()
        let item = MediaItem(image: image)
        let sepiaFilter = SepiaFilter()
        
        
        item.applyFilter(mediaFilter: sepiaFilter)
        
        item.applyFilter(mediaFilter: sepiaFilter)
        
    
        let logoImage = UIImage(named: "watermark")
        
        let firstElement = MediaElement(image: logoImage!)
        firstElement.frame = CGRect(x: 0, y: 0, width: logoImage!.size.width, height:    logoImage!.size.height)
        
        let secondElement = MediaElement(image: logoImage!)
        secondElement.frame = CGRect(x: 100, y: 100, width: logoImage!.size.width, height:  logoImage!.size.height)
        item.add(elements: [firstElement, secondElement])
        
        let mediaProcessor = MediaProcessor()
        mediaProcessor.processElements(item: item) { [weak self] (result, error) in
            
            self?.imageView.image = result.image
        }
    }
  
}
