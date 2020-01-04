//
//  RowViewModelManager.swift
//  Diary
//
//  Created by tautau on 2019/12/23.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation

protocol RowViewModelManager {
    func memberCellButtonClicked(_ user: Member, viewModel : MemberCellViewModel) -> (() -> Void)
    func convertToVM(item:Listable)->RowViewModel?
}

extension RowViewModelManager {
    typealias dateHeader = String
    
    func convertToSection(userDataList:[UserData]) -> [dateHeader:[Listable]] {
        var sectionTable = [dateHeader:[Listable]]()
        for userData in userDataList {
            for diary in userData.diaries {
                if var sectionRows = sectionTable[diary.date]{
                    sectionRows.append(userData.info)
                    sectionRows.append(diary)
                    sectionTable[diary.date] = sectionRows
                }else{sectionTable[diary.date] = [userData.info,diary]}
            }
        }
        return sectionTable
    }
    
    func buildViewModels(sections: [dateHeader:[Listable]]) -> [SectionViewModel]{
        let newSectionTable = sections.mapValues { $0.map{self.convertToVM(item: $0)!}}
        return self.converToSectionViewModel(newSectionTable)
    }
    
    func converToSectionViewModel(_ sectionTable: [dateHeader: [RowViewModel]]) -> [SectionViewModel] {
        let sortedGroupingKey = sectionTable.keys.sorted(by: dateStringDescComparator())
        return sortedGroupingKey.map {SectionViewModel(rowViewModels: sectionTable[$0]!, headerTitle: $0)}
    }
    
    func dateStringDescComparator() -> ((String, String) -> Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return { (d1Str, d2Str) -> Bool in
            if let d1 = formatter.date(from: d1Str), let d2 = formatter.date(from: d2Str) {
                return d1 > d2
            } else {
                return false
            }
        }
    }

}
