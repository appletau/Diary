//
//  UserDataViewModel.swift
//  Diary
//
//  Created by tautau on 2019/12/16.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation

class UserDataViewModel {
    let title = Observable<String>(value: "Loading")
    let isLoading = Observable<Bool>(value: false)
    let isUIHidden = Observable<Bool>(value: false)
    let userInfo = Observable<Member>(value:Member())
    let diaryCellViewModels = Observable<[DiaryCellViewModel]>(value:[])
    var avatarImage:AsyncImage?
}
