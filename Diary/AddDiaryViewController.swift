//
//  DairyViewController.swift
//  Diary
//
//  Created by tautau on 2019/7/25.
//  Copyright © 2019年 tautau. All rights reserved.
//

import UIKit

class AddDiaryViewController: UIViewController {
    var userId:String?
    
    lazy var photoAlbum:UIImagePickerController = {
         let picker = UIImagePickerController()
         picker.sourceType = .photoLibrary
         picker.delegate = self
         return picker
     }()
    
    lazy var currentDate:String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from:Date())
    }()
    
    lazy var currentTime:String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from:Date())
    }()
    
    
    lazy var photo:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius  = 3
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "imagePlaceholder")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(photoTouched(tapGestureRecognizer:)))
         image.addGestureRecognizer(gesture)
         image.isUserInteractionEnabled = true
        self.view.addSubview(image)
        return image
    }()
    
    lazy var dateLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 3
        label.textAlignment = .center
        label.text = currentDate
        return label
    }()
    
    lazy var murmurTextField:UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.textAlignment = .center
        textField.placeholder = "Fill in murmur"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var descriptionTextField:UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.textAlignment = .center
        textField.placeholder = "Fill in description"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    lazy var submitButton:UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.setTitleColor(.black , for: .normal)
        button.setTitle("Upload", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews:[dateLabel,murmurTextField,descriptionTextField,submitButton])
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
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
}

extension AddDiaryViewController {
    func setUpConstraints(){
        NSLayoutConstraint.activate([photo.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
                                     photo.heightAnchor.constraint(equalTo: photo.widthAnchor, multiplier: 2/3),
                                     photo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                     photo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     stackView.centerXAnchor.constraint(equalTo: photo.centerXAnchor),
                                     stackView.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 20),
                                     stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
                                     stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 2/5),
                                     dateLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
                                     dateLabel.heightAnchor.constraint(equalTo: dateLabel.widthAnchor, multiplier: 1/8),
                                     murmurTextField.widthAnchor.constraint(equalTo: dateLabel.widthAnchor),
                                     murmurTextField.heightAnchor.constraint(equalTo: murmurTextField.widthAnchor, multiplier: 1/6),
                                     descriptionTextField.widthAnchor.constraint(equalTo: murmurTextField.widthAnchor),
                                     descriptionTextField.heightAnchor.constraint(equalTo: descriptionTextField.widthAnchor, multiplier: 1),
                                     submitButton.widthAnchor.constraint(equalTo:murmurTextField.widthAnchor),
                                     submitButton.heightAnchor.constraint(equalTo: submitButton.widthAnchor, multiplier: 1/6)])
    }
    
    func restUI() {
        self.photo.image = UIImage(named: "imagePlaceholder")
        self.murmurTextField.text = ""
        self.descriptionTextField.text = ""
    }
    
    @objc func submitButtonPressed(){
        guard let image =  photo.image, let id = userId else {return}
        let diary = Diary(userId:id,
                          date: self.currentDate,
                          time: self.currentTime,
                          murmur: self.murmurTextField.text!,
                          description: self.descriptionTextField.text!)
        UserSocialService.share.save(diary: diary, withImage: image.resizeImage) { (_) in}
        let alert = UIAlertController(title: "Hint", message: "Diary has been saved!!") { (_) in
            self.restUI()
        }
        alert.activatedBy(vc: self)
    }
    
    @objc func photoTouched(tapGestureRecognizer : UITapGestureRecognizer) {
       present(photoAlbum, animated: true)
    }
}

extension AddDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        photoAlbum.dismiss(animated: true){self.photo.image = image}
    }
}
