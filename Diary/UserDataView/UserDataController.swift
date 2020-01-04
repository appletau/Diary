//
//  UserDataController.swift
//  Diary
//
//  Created by tautau on 2019/12/16.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import UIKit

class UserDataController {
    let viewModel = UserDataViewModel()
    var userInfo = Observable<Member?>(value: nil)
    
    func start() {
        initBinding()
        updateRowViewModel(isUpdate: false)
    }
    
    private func initBinding() {
        userInfo.addObserver { [weak self] (info) in
            guard let info = info, let self = self else {return}
            self.updateUserInfo(userInfo: info)
            
            UserSocialService.share.getDiaries(withID: info.id, period: PeriodOfDate.aYearBefore(date: Date())) { (result) in
                guard let diaries = result.value else {fatalError(result.errorMessage!)}
                self.updateRowViewModel(isUpdate: true, diaries: diaries)
            }
        }
    }
}

extension UserDataController {
    private func updateUserInfo(userInfo:Member) {
        viewModel.userInfo.value = userInfo
        viewModel.avatarImage = AsyncImage(url: userInfo.avatarUrl,
                                                placeholderImage: UIImage(named: "avatarPlaceholder")!)
    }
    
    private func updateRowViewModel(isUpdate:Bool, diaries: [Diary] = []) {
        if isUpdate {
            viewModel.diaryCellViewModels.value = diaries.map{convertToVM(item: $0)}
        }
        viewModel.isLoading.value = !isUpdate
        viewModel.isUIHidden.value = !isUpdate
        viewModel.title.value = isUpdate ? "User Info" : "Loading..."
    }
    
    private func convertToVM(item:Diary)->DiaryCellViewModel{
        let diaryCellViewModel = DiaryCellViewModel(withDiary: item)
        return diaryCellViewModel
    }
}
