//
//  SignUpViewController.swift
//  Diary
//
//  Created by tautau on 2019/7/24.
//  Copyright © 2019年 tautau. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    weak var delegate:SignUpVCDelegate?
    
    lazy var photoAlbum:UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    lazy var avatar:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius  = 3
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "avatarPlaceholder")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarTouched(tapGestureRecognizer:)))
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        self.view.addSubview(image)
        return image
    }()
    
    lazy var email:UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.textAlignment = .center
        textField.placeholder = "Fill in email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var password:UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.textAlignment = .center
        textField.placeholder = "Fill in password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var userName:UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.textAlignment = .center
        textField.placeholder = "Fill in user name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var comfirmButton:UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.setTitleColor(.black , for: .normal)
        button.setTitle("Sign Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(comfirmButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews:[email,password,userName,comfirmButton])
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
        self.setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([avatar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
                                     avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor, multiplier: 2/3),
                                     avatar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
                                     avatar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     stackView.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
                                     stackView.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 20),
                                     stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
                                     stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/3),
                                     email.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
                                     password.widthAnchor.constraint(equalTo: email.widthAnchor),
                                     userName.widthAnchor.constraint(equalTo: email.widthAnchor),
                                     comfirmButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3)])
    }
    
    @objc func comfirmButtonPressed(){
        delegate?.signUp(withVc: self)
    }
    
    @objc func avatarTouched(tapGestureRecognizer : UITapGestureRecognizer) {
       present(photoAlbum, animated: true)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        photoAlbum.dismiss(animated: true){self.avatar.image = image}
    }
}
