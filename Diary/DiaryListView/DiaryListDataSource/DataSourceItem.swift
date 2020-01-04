//
//  DataSourceItem.swift
//  Diary
//
//  Created by tautau on 2019/12/14.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation

struct DataSourceItem:Hashable {
    var value:RowViewModel
    private let identifier: UUID
    
    init(item:RowViewModel) {
        self.value = item
        self.identifier = item.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
    
    static func == (lhs: DataSourceItem, rhs: DataSourceItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
