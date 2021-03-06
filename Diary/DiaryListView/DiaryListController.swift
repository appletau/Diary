//
//  NewDiaryController.swift
//  Diary
//
//  Created by tautau on 2019/7/22.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DiaryListController{
    let viewModel:DiaryListViewModel = DiaryListViewModel()
    var loginID = ""
    var followList = Observable<[Member]>(value: [])
    var old = [UserData]()
    
    func start(){
        initBinding()
        updateDiaryListViewModel(isUpdate: false)
    }
    
    private func initBinding() {
        followList.addObserver(fireNow: false) { [weak self] (list) in
            guard let self = self else {return}
            self.updateRowViewModels(followList: list)
        }
    }
}

//:Update Event
extension DiaryListController {
    private func updateRowViewModels(followList:[Member]) {
        if followList.count > old.count {
            let new = followList.filter(){ (user) in
                return !self.old.contains(where: {user == $0.info})
            }
            UserSocialService.share.getUsersDiaries(withlist: new) { (userDataList) in
                self.old += userDataList
                self.updateDiaryListViewModel(isUpdate: true)
            }
        } else {
            old = old.filter(){followList.contains($0.info)}
            updateDiaryListViewModel(isUpdate: true)
        }
    }
    
    private func updateDiaryListViewModel(isUpdate:Bool) {
        if isUpdate {
            self.viewModel.sectionViewModels.value = self.buildViewModels(sections: self.convertToSection(userDataList: old))
        }
        self.viewModel.isLoading.value = !isUpdate
        self.viewModel.isTableViewHidden.value = !isUpdate
        self.viewModel.title.value = isUpdate ? "Follow Member's Diary" : "Loading..."
    }
}

extension DiaryListController:CellViewModelManager {
    func convertToVM(item:Listable)->CellViewModel?{
        if let diary = item as? Diary
        {
            let diaryCellViewModel = DiaryCellViewModel(withDiary: diary)
            return diaryCellViewModel
        }else if let member = item as? Member{
            
            let memberCellViewModel = MemberCellViewModel(withMember: member,
                                                          addBtnTitle:Observable<String>(value:String.fontAwesomeIcon("check")!))
            memberCellViewModel.addBtnPressed = self.memberCellButtonClicked(member, viewModel: memberCellViewModel)
            return memberCellViewModel
        }
        return nil
    }
    
    func memberCellButtonClicked(_ user: Member, viewModel : MemberCellViewModel) -> (() -> Void) {
        return { [weak viewModel ,weak self] in
            guard let self = self, let _ = viewModel else {return}
            self.followList.value = self.followList.value.filter {$0 != user}
            UserSocialService.share.save(followMemberList: self.followList.value, withID: self.loginID)
            self.viewModel.isLoading.value = true
            self.viewModel.isTableViewHidden.value = true
            self.viewModel.title.value = "Loading..."
        }
    }
}
