//
//  DiaryDetailedViewModel.swift
//  Diary
//
//  Created by tautau on 2019/12/18.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation

class DiaryDetailedViewModel {
    var diaryCellVM = Observable<DiaryCellViewModel?>(value: nil)
    var isEditing = Observable<Bool>(value: false)
}
