//
//  NewDiaryViewModel.swift
//  Diary
//
//  Created by tautau on 2019/7/22.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation


class DiaryListViewModel{
    let title = Observable<String>(value: "Loading")
    let isLoading = Observable<Bool>(value: false)
    let isTableViewHidden = Observable<Bool>(value: false)
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
}
