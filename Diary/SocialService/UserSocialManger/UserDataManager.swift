//
//  UserDataManager.swift
//  Diary
//
//  Created by tautau on 2019/12/1.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import UIKit

struct UserData {
    var info:Member
    var diaries:[Diary]
    init(info:Member = Member(),
         diaries:[Diary] = []) {
        self.info = info
        self.diaries = diaries
    }
}

protocol UserDataManager {
    func save(userInfo:Member, withImage image:UIImage, then: @escaping (ResultType<Member>) -> Void)
    func save(followMemberList:[Member], withID id:String)
    func save(diary:Diary, withImage image:UIImage, then: @escaping (ResultType<Diary>) -> Void)
    func getUserInfo(withID id:String, then:@escaping (ResultType<Member>) -> Void)
    func getAllUserInfo(then: @escaping (ResultType<[Member]>) -> Void)
    func getFollowList(withID id:String, then:@escaping (ResultType<[Member]>) -> Void)
    func getDiaries(withID id: String, period:PeriodOfDate, then: @escaping(ResultType<[Diary]>) -> Void)
    func getUsersDiaries(withlist list:[Member], then:@escaping ([UserData]) -> Void)
}

extension UserSocialService:UserDataManager {
    func save(followMemberList: [Member], withID id: String) {
        self.queue.async {
            self.dataManager.save(followMemberList: followMemberList, withID: id)
        }
    }
    
    func getFollowList(withID id: String, then: @escaping (ResultType<[Member]>) -> Void) {
        self.queue.async {
            self.dataManager.getFollowList(withID: id) {then($0)}
        }
    }
    
    
    func save(userInfo: Member, withImage image:UIImage, then: @escaping (ResultType<Member>) -> Void) {
        self.queue.async {
            var result:ResultType<String>?
            
            //upload image
            self.upload(image: image, withPath: "avatarImage/\(userInfo.id).png"){result = $0; self.semphore.signal()}
            self.semphore.wait()
            
            //save member
            guard let urlString = result?.value else {then(ResultType.failure(result!.errorMessage!)); return}
            var newUserInfo = userInfo
            newUserInfo.avatarUrl = urlString
            self.dataManager.save(userInfo: newUserInfo)
            then(ResultType.sucess(newUserInfo))
            
            //save follow list
            self.save(followMemberList: [newUserInfo], withID: userInfo.id)
        }
        
    }
    
    func save(diary: Diary,withImage image:UIImage, then: @escaping (ResultType<Diary>) -> Void) {
        self.queue.async {
            var result:ResultType<String>?
            self.upload(image: image, withPath: "diaryImage/\(diary.identifier.description).png"){
                result = $0
                self.semphore.signal()
            }
            self.semphore.wait()
            
            guard let urlString = result?.value else {then(ResultType.failure(result!.errorMessage!)); return}
            var newDiary = diary
            newDiary.imageURL = urlString
            self.dataManager.save(diary: newDiary)
            then(ResultType.sucess(newDiary))
        }
    }
    
    func getUserInfo(withID id: String, then: @escaping (ResultType<Member>) -> Void) {
        self.queue.async {
            self.dataManager.getUserInfo(withID: id) {then($0); self.semphore.signal()}
            self.semphore.wait()
        }
    }
    
    func getAllUserInfo(then: @escaping (ResultType<[Member]>) -> Void) {
        self.queue.async {
            self.dataManager.getAllUserInfo() {then($0); self.semphore.signal()}
            self.semphore.wait()
        }
    }
    
    func getDiaries(withID id: String,period:PeriodOfDate, then: @escaping(ResultType<[Diary]>) -> Void) {
        var diaries:Array<Diary> = []
        self.queue.async {
            for path in period.paths {
                self.dataManager.getDiaries(withID: id, path: path) {
                    if let d = $0.value {diaries += d}
                    self.semphore.signal()
                }
                self.semphore.wait()
            }
            then(ResultType.sucess(diaries))
        }
    }
    
    func getUsersDiaries(withlist list: [Member], then:@escaping ([UserData])->Void) {
        var friendsData = [UserData]()
        let period = PeriodOfDate.threeMonthBefore(date: Date())
        if list == [] {
            then(friendsData)
            return
        }
        for (i,friend) in list.enumerated() {
            self.getDiaries(withID: friend.id, period: period) {
                if let diaries = $0.value {friendsData.append(UserData(info: friend, diaries: diaries))}
                //do block when friends list is at the last index
                if i == list.count-1{then(friendsData)}
            }
        }
    }
}
