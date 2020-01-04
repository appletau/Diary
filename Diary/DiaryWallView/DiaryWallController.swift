//
//  DiaryCollectionController.swift
//  Diary
//
//  Created by tautau on 2019/12/14.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import UIKit

class DiaryWallController {
    var loginID = ""
    let viewModel = DiaryWallViewModel()
    var followList = Observable<[Member]>(value: [])
    var unFollowList = Observable<[Member]>(value: [])
    var allUser:[Member]?
    var old = [UserData]()
    
    func start(){
        initBinding()
        updateDiaryWallViewModel(isUpdate: false)
    }
    
    private func initBinding() {
        unFollowList.addObserver(fireNow: false) { [weak self] (unfollowList) in
            guard let self = self else {return}
            self.updateRowViewModels(unfollowList: unfollowList)
        }
        
        followList.addObserver { [weak self] (followList) in
            guard let self = self else{return}
            self.updateUnfollowList(followList: followList)
        }
    }
}

//:Update Event
extension DiaryWallController {
    private func updateUnfollowList(followList: [Member]) {
        if let allUser = self.allUser {
            let unfollowMember = allUser.filter {!followList.contains($0)}
            self.unFollowList.value = unfollowMember
        }
    }
    
    private func updateRowViewModels(unfollowList:[Member]) {
        if unfollowList.count > old.count {
            let new = unfollowList.filter(){ (user) in
                return !self.old.contains(where: {user == $0.info})
            }
            UserSocialService.share.getUsersDiaries(withlist: new) { (userDataList) in
                self.old += userDataList
                self.updateDiaryWallViewModel(isUpdate: true)
            }
        } else {
            old = old.filter(){unfollowList.contains($0.info)}
            updateDiaryWallViewModel(isUpdate: true)
        }
    }
    
    private func updateDiaryWallViewModel(isUpdate:Bool) {
        if isUpdate {
        self.viewModel.sectionViewModels.value = self.buildViewModels(sections: self.convertToSection(userDataList: old))
        }
        self.viewModel.isLoading.value = !isUpdate
        self.viewModel.isCollectionViewHidden.value = !isUpdate
        self.viewModel.title.value = isUpdate ? "Unfollow Member's Diary" : "Loading..."
    }
}

extension DiaryWallController:RowViewModelManager {
    
    func convertToVM(item:Listable)->RowViewModel?{
        if let diary = item as? Diary
        {
            let diaryCellViewModel = DiaryCellViewModel(withDiary: diary)
            return diaryCellViewModel
        }else if let member = item as? Member{
            
            let memberCellViewModel = MemberCellViewModel(withMember: member,
                                                          addBtnTitle:Observable<String>(value:String.fontAwesomeIcon("plus")!))
            memberCellViewModel.addBtnPressed = self.memberCellButtonClicked(member, viewModel: memberCellViewModel)
            return memberCellViewModel
        }
        return nil
    }
    
    func memberCellButtonClicked(_ user: Member, viewModel : MemberCellViewModel) -> (() -> Void) {
           return { [weak viewModel ,weak self] in
               guard let self = self, let _ = viewModel else {return}
               self.followList.value.append(user)
               UserSocialService.share.save(followMemberList: self.followList.value, withID: self.loginID)
               self.viewModel.isLoading.value = true
               self.viewModel.isCollectionViewHidden.value = true
               self.viewModel.title.value = "Loading..."

           }
       }
}
