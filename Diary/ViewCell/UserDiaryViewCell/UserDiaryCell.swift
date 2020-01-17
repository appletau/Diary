//
//  UserDiaryViewCell.swift
//  Diary
//
//  Created by tautau on 2019/12/16.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation

import UIKit

class UserDiaryCell:UICollectionViewCell,CellConfigurable{
    var viewModel:DiaryCellViewModel?
    
    lazy var photo:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius  = 3
        image.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(image)
        
        return image
    }()
    
    func setup(viewModel:CellViewModel){
        guard let viewModel = viewModel as? DiaryCellViewModel else { return }
        self.viewModel = viewModel
        self.viewModel?.photo.completeDownload = {self.photo.image = $0}
        self.viewModel?.photo.startDownload()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupInitialView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.photo.completeDownload = nil
        //viewModel?.cellPressed = nil
    }
    
    private func setupInitialView() {}
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photo.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photo.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            photo.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
