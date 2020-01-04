//
//  DiaryListDataSource.swift
//  Diary
//
//  Created by tautau on 2019/12/14.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import UIKit

class DiaryListDataSource: UITableViewDiffableDataSource<String, DataSourceItem> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.snapshot().sectionIdentifiers[section]
    }

}
