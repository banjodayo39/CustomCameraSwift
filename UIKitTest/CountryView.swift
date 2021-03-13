//
//  CountryView.swift
//  UIKitTest
//
//  Created by Home on 3/4/21.
//

import UIKit

class CountryView: UIView {

    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Enter Username and Country"
        label.textColor = .white
        return label
    }()
    
    
    let usernameTextField : UITextField = {
        let _usernameTextField = UITextField()
        _usernameTextField.backgroundColor = UIColor.blue
        _usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        _usernameTextField.font = UIFont.systemFont(ofSize: 16)
        _usernameTextField.placeholder =  " Enter username"
        _usernameTextField.textColor = .white
        return _usernameTextField
    }()
    
    let countryFieldTextField : UITextField = {
        let _countryTextField = UITextField()
        _countryTextField.translatesAutoresizingMaskIntoConstraints = false
        _countryTextField.font = UIFont.systemFont(ofSize: 16)
        _countryTextField.textColor = .white
        _countryTextField.placeholder =  " Enter Country"
        _countryTextField.translatesAutoresizingMaskIntoConstraints = false
        _countryTextField.backgroundColor = UIColor.blue
        return _countryTextField
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        
        addSubview(usernameTextField)
        usernameTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        usernameTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameTextField.borderStyle = UITextField.BorderStyle.roundedRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
