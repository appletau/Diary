//
//  CellConfigurable.swift
//  MVVM_Practice
//
//  Created by tautau on 2019/7/14.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation

protocol CellConfigurable {
    func setup(viewModel: RowViewModel)
}
