//
//  ListMemberCell.swift
//  Diary
//
//  Created by tautau on 2019/7/22.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation
import UIKit

class ListMemberCell:UITableViewCell,CellConfigurable{
    var viewModel:MemberCellViewModel?
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 12)
        label.textColor = .brown
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var avatar:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12.5
        image.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(image)
        return image
    }()
    
    lazy var loadingIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style:.medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(indicator)
        return indicator
    }()
    
    lazy var actionBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        btn.titleLabel?.font = UIFont.icon(from:.fontAwesome, ofSize: 14.0)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        self.contentView.addSubview(btn)
        return btn
    }()
    
    
    func setup(viewModel:CellViewModel){
        guard let viewModel = viewModel as? MemberCellViewModel else { return }
        self.viewModel = viewModel
        self.nameLabel.text = viewModel.name
        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
        }

        viewModel.isAddBtnHidden.addObserver { [weak self] (isHidden) in
            self?.actionBtn.isHidden = isHidden
        }

        viewModel.isAddBtnEnabled.addObserver { [weak self] (isEnabled) in
            self?.actionBtn.isEnabled = isEnabled
        }

        viewModel.addBtnTitle.addObserver { [weak self] (title) in
            self?.actionBtn.setTitle(title, for: .normal)
        }
        
        self.viewModel?.avatarImage.completeDownload = { image in
            self.avatar.image = image
        }
        
        self.viewModel?.avatarImage.startDownload()
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
        viewModel?.addBtnTitle.removeObserver(atIndex: 0)
        viewModel?.isLoading.removeObserver(atIndex: 0)
        viewModel?.isAddBtnHidden.removeObserver(atIndex: 0)
        viewModel?.isAddBtnEnabled.removeObserver(atIndex: 0)
        viewModel?.avatarImage.completeDownload = nil
    }
    
    private func setupInitialView() {
        self.selectionStyle = .none
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            avatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            avatar.widthAnchor.constraint(equalToConstant: 25),
            avatar.heightAnchor.constraint(equalToConstant: 25),
            nameLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor, constant: 0),
            actionBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            actionBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            actionBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            loadingIndicator.centerXAnchor.constraint(equalTo: actionBtn.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: actionBtn.centerYAnchor)])
    }
    
    @objc func btnPressed() {
        viewModel?.addBtnPressed?()
    }
}
