//
//  ListDiaryCell.swift
//  Diary
//
//  Created by tautau on 2019/7/22.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation
import UIKit

class ListDiaryCell:UITableViewCell,CellConfigurable{
    var viewModel:DiaryCellViewModel?
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter", size: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        
        return label
    }()
    
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
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.desc
        self.viewModel?.photo.completeDownload = {self.photo.image = $0}
        self.viewModel?.photo.startDownload()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    private func setupInitialView() {
        self.selectionStyle = .none
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photo.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            photo.widthAnchor.constraint(equalToConstant: 120),
            photo.heightAnchor.constraint(equalToConstant: 80),
            titleLabel.topAnchor.constraint(equalTo: photo.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)])
    }
}
