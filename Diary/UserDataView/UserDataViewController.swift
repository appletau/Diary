//
//  UserDataViewController.swift
//  Diary
//
//  Created by tautau on 2019/12/16.
//  Copyright © 2019 tautau. All rights reserved.
//

import UIKit

class UserDataViewController: UIViewController {
    
    var viewModel:UserDataViewModel {
        return controller.viewModel
    }
    
    lazy var controller:UserDataController = {
        return UserDataController()
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<String, DiaryCellViewModel>! = nil
    
    weak var delegate:UserDataVCDelegate?
    
    lazy var photoAlbum:UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    lazy var avatar:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12.5
        image.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarTouched(tapGestureRecognizer:)))
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var infoView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.nameLabel, self.emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let mainStackView = UIStackView(arrangedSubviews: [self.avatar,stackView])
        mainStackView.axis = .horizontal
        mainStackView.alignment = .bottom
        mainStackView.distribution = .fill
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainStackView)
        return mainStackView
    }()
    
    private lazy var separator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }()
    
    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:setCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        self.view.addSubview(collectionView)
        collectionView.register(UserDiaryCell.self,
                                forCellWithReuseIdentifier: UserDiaryCell.cellIdentifier())
        return collectionView
    }()
    
    lazy var loadingIdicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configDataSoure()
        setupConstraint()
        controller.start()
        initBinding()
        
    }
}

extension UserDataViewController {
    func initBinding() {
        viewModel.userInfo.addObserver {[weak self] (userInfo) in
            self?.viewModel.avatarImage?.completeDownload = {self?.avatar.image = $0}
            self?.viewModel.avatarImage?.startDownload()
            self?.nameLabel.text = userInfo.name
            self?.emailLabel.text = userInfo.email
        }
        
        viewModel.diaryCellViewModels.addObserver {[weak self] (diaryVMs) in
            var snapshot = NSDiffableDataSourceSnapshot<String, DiaryCellViewModel>()
            snapshot.appendSections(["My Diaries"])
            snapshot.appendItems(diaryVMs, toSection: "My Diaries")
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
        
        viewModel.isLoading.addObserver {[weak self] (isLoading) in
            if isLoading {
                self?.loadingIdicator.startAnimating()
            }else {
                self?.loadingIdicator.stopAnimating()
            }
        }
        
        viewModel.isUIHidden.addObserver {[weak self] (isHidden) in
            self?.infoView.isHidden = isHidden
            self?.separator.isHidden = isHidden
            self?.collectionView.isHidden = isHidden
        }
        
        viewModel.title.addObserver { [weak self] (title) in
            self?.navigationItem.title = title
        }
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            avatar.heightAnchor.constraint(equalToConstant: 80),
            avatar.widthAnchor.constraint(equalTo: avatar.heightAnchor),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            separator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            separator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            separator.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 5),
            separator.heightAnchor.constraint(equalToConstant: 1),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func avatarTouched(tapGestureRecognizer : UITapGestureRecognizer) {
        present(photoAlbum, animated: true)
    }
}

extension UserDataViewController {
    func configDataSoure() {
        dataSource = UICollectionViewDiffableDataSource<String,DiaryCellViewModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: DiaryCellViewModel) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:UserDiaryCell.cellIdentifier(), for:indexPath) as! UserDiaryCell
            
            cell.setup(viewModel: item)
            cell.layoutIfNeeded()
            
            return cell
        }
    }
    
    func setCollectionViewLayout() -> UICollectionViewCompositionalLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                              heightDimension: .fractionalHeight(1.0))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)

         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.3))
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                          subitems: [item])

         let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)

         let layout = UICollectionViewCompositionalLayout(section: section)
         return layout
    }
}

extension UserDataViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        let oldImage = avatar.image
        UserSocialService.share.upload(image: image, withPath: viewModel.userInfo.value.avatarUrl) {[weak self] (result) in
            if let e = result.errorMessage {
                let alert = UIAlertController(title: "Save Avatar Failed", message: e)
                self?.avatar.image = oldImage
                self?.present(alert, animated: true)
            }
        }
        photoAlbum.dismiss(animated: true){self.avatar.image = image}
    }
}

extension UserDataViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goToDetailedDiary(withIndex:indexPath.row, vc: self)
    }
}
