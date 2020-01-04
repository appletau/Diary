//
//  DiaryCollectionViewModel.swift
//  Diary
//
//  Created by tautau on 2019/12/14.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation

class DiaryWallViewModel{
    let title = Observable<String>(value: "Loading")
    let isLoading = Observable<Bool>(value: false)
    let isCollectionViewHidden = Observable<Bool>(value: false)
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
}
