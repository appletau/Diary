//
//  CollectionHeaderView.swift
//  Diary
//
//  Created by tautau on 2019/9/11.
//  Copyright © 2019年 tautau. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: self)
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter-Condensed", size: 17)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    private lazy var separator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupInitialView()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialView()
        setupConstraint()
    }
    
    public func setTitle(_ text: String) {
        self.titleLabel.text = text
    }
    
    private func setupInitialView() {
        self.backgroundColor = UIColor.white
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            separator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            separator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            separator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            separator.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
}
