//
//  LoginViewController.swift
//  Diary
//
//  Created by tautau on 2019/7/19.
//  Copyright © 2019年 tautau. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    weak var delegate:LoginVCDelegate?
    
    lazy var email:UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var password:UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signUpButton:UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.setTitleColor(.black , for: .normal)
        button.setTitle("Sign Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var logInButton:UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.setTitleColor(.black , for: .normal)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews:[email,password,logInButton,signUpButton])
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        email.text = "Sam@gmail.com"
        password.text = "123456"
        self.setUpConstraints()        
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                     stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
                                     stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/3),
                                     email.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
                                     password.widthAnchor.constraint(equalTo: email.widthAnchor),
                                     signUpButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3),
                                     logInButton.widthAnchor.constraint(equalTo: signUpButton.widthAnchor)])
    }
    
    @objc func signUpButtonPressed(){
        delegate?.goToSignUp(withVc: self)
        
    }
    
    @objc func loginButtonPressed(){
        delegate?.login(withVc: self)
    }
}
