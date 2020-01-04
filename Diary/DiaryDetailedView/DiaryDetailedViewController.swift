//
//  DiaryDetailedViewController.swift
//  Diary
//
//  Created by tautau on 2019/12/17.
//  Copyright © 2019 tautau. All rights reserved.
//

import UIKit

class DiaryDetailedViewController: UIViewController {
    
    var completeEditAction: ((DiaryCellViewModel?) -> Void)?
    
    lazy var viewModel:DiaryDetailedViewModel = {
       return DiaryDetailedViewModel()
    }()
    
    lazy var photoAlbum:UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    lazy var photo:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius  = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "imagePlaceholder")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(photoTouched(tapGestureRecognizer:)))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        return imageView
    }()
    
    lazy var dateLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 3
        label.textAlignment = .center
        return label
    }()
    
    lazy var murmurTextField:UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var descriptionTextField:UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var stackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews:[dateLabel,murmurTextField,descriptionTextField])
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
        self.initUI()
        self.setUpConstraints()
        self.initBinding()
    }
    
    func initBinding() {
        viewModel.isEditing.addObserver() {[weak self] (isEditing) in
            guard let self = self else {return}
            self.enableUI(value: isEditing)
        }
        
        viewModel.diaryCellVM.addObserver {[weak self] (diaryCellVM) in
            guard let self = self, let diaryCellVM = diaryCellVM else {return}
            self.showDiary(diaryCellVM: diaryCellVM)
        }
    }
}

extension DiaryDetailedViewController {
    func initUI() {
        self.view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-back"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(goBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-edit"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(startEdit))
    }
    
    func showDiary(diaryCellVM:DiaryCellViewModel) {
        photo.image = diaryCellVM.photo.image
        murmurTextField.text = diaryCellVM.title
        descriptionTextField.text = diaryCellVM.desc
    }
    
    func enableUI(value:Bool) {
        navigationItem.rightBarButtonItem?.image = value ? UIImage(named: "icon-done") : UIImage(named: "icon-edit")
        navigationItem.leftBarButtonItem?.isEnabled = !value
        murmurTextField.isEnabled = value
        descriptionTextField.isEnabled = value
        
    }
    
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
                                     descriptionTextField.heightAnchor.constraint(equalTo: descriptionTextField.widthAnchor, multiplier: 1)])
    }
}

//:Touch Event
extension DiaryDetailedViewController {
    func saveEditedDiary() {
        guard let newViewModel = viewModel.diaryCellVM.value else {return}
        newViewModel.title = murmurTextField.text!
        newViewModel.desc = descriptionTextField.text!
        newViewModel.photo.image = photo.image!
        let newDiary = Diary(diaryCellviewModel: newViewModel)
        UserSocialService.share.save(diary: newDiary, withImage: photo.image!.resizeImage) { (result) in
            if let e = result.errorMessage {
                let alert = UIAlertController(title: "Save EditDiary Failed", message: e)
                self.present(alert, animated: true)
                return
            }
            self.completeEditAction?(newViewModel)
        }
    }
    
    @objc func photoTouched(tapGestureRecognizer : UITapGestureRecognizer) {
        if viewModel.isEditing.value {present(photoAlbum, animated: true)}
    }
    
    @objc func goBack() {
        self.saveEditedDiary()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func startEdit() {
        viewModel.isEditing.value = !viewModel.isEditing.value
    }
}

extension DiaryDetailedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        self.photo.image = image
        photoAlbum.dismiss(animated: true)
    }
}


