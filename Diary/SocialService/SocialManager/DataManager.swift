//
//  DataManager.swift
//  Diary
//
//  Created by tautau on 2019/12/1.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import Firebase

protocol DataManager {
    func save(userInfo:Member)
    func save(followMemberList:[Member], withID id:String)
    func save(diary:Diary)
    func getUserInfo(withID id:String, then:@escaping (ResultType<Member>) -> Void)
    func getAllUserInfo(then:@escaping (ResultType<[Member]>) -> Void)
    func getFollowList(withID id:String, then:@escaping (ResultType<[Member]>) -> Void)
    func getDiaries(withID id: String?,path:QueryPath, then: @escaping(ResultType<[Diary]>) -> Void)
}

extension Database:DataManager {
    func save(followMemberList: [Member], withID id:String) {
        let followListRef = self.reference(withPath:"FollowList").child(id)
        let jsonStringList = followMemberList.map {JSONEncoder().enocdeToJsonString(withObject: $0)}
        followListRef.setValue(jsonStringList)
    }
    
    func save(userInfo: Member) {
        let userInfoRef = self.reference(withPath: "usersInfo").child(userInfo.id)
        let jsonString = JSONEncoder().enocdeToJsonString(withObject: userInfo)
        userInfoRef.setValue(jsonString)
    }
    
    func save(diary: Diary) {
        let jsonString = JSONEncoder().enocdeToJsonString(withObject: diary)
        let dateArray = diary.date.components(separatedBy: "-")
        let year = dateArray[0],month = dateArray[1],day = dateArray[2]
        
        let diaryRef = self.reference(withPath: "DiaryList").child("\(year)_\(month)").child(diary.identifier.description)
        diaryRef.child("diaryObject").setValue(jsonString)
        diaryRef.child("userId").setValue(diary.userId)
        diaryRef.child("day").setValue(day)
    }
    
    func getUserInfo(withID id: String, then: @escaping (ResultType<Member>) -> Void) {
        self.reference(withPath:"usersInfo").child(id).observeSingleEvent(of: .value) {
            guard let jsonString = $0.value as? String else {then(ResultType.failure("Get User Info failed !!")); return}
            guard let currentUserInfo = JSONDecoder().decodeToObject(withType: Member.self, from: jsonString) else {then(ResultType.failure("Json decode failed !!")); return}
            then(ResultType.sucess(currentUserInfo))
        }
    }
    
    func getAllUserInfo(then:@escaping (ResultType<[Member]>) -> Void) {
        self.reference(withPath:"usersInfo").observeSingleEvent(of: .value) {
            guard let jsonStringDict = $0.value as? Dictionary<String,String> else {then(ResultType.failure("Get UserInfo List failed !!")); return}
            var userInfoList:Array<Member> = []
            for jString in jsonStringDict.values {
                if let m = JSONDecoder().decodeToObject(withType: Member.self, from: jString) {
                    userInfoList.append(m)
                }
            }
            then(ResultType.sucess(userInfoList))
        }
    }
    
    func getFollowList(withID id: String, then: @escaping (ResultType<[Member]>) -> Void) {
        self.reference(withPath: "FollowList").child(id).observeSingleEvent(of: .value) {
            guard let jsonStringList = $0.value as? [String] else {then(ResultType.failure("Get FollowList failed !!")); return}
            var followList:Array<Member> = []
            for jString in jsonStringList {
                if let m = JSONDecoder().decodeToObject(withType: Member.self, from: jString) {
                    followList.append(m)
                }
            }
            then(ResultType.sucess(followList))
        }
    }
    
    func getDiaries(withID id:String?, path:QueryPath, then: @escaping(ResultType<[Diary]>) -> Void) {
        self.reference(withPath:"DiaryList").child(path.main).queryOrdered(byChild:"day").queryStarting(atValue: path.startValue).queryEnding(atValue: path.endValue).observeSingleEvent(of: .value) {
            var diaries:[Diary] = []
            guard let results = $0.value as? Dictionary<String,Dictionary<String,String>> else {then(ResultType.sucess(diaries)); return}
            for result in results.values {
                if let jsonString = result["diaryObject"] {
                    if let id = id, result["userId"] != id {continue}
                    guard let diary = JSONDecoder().decodeToObject(withType: Diary.self,from: jsonString) else {then(ResultType.failure("Json decode failed !!")); return}
                    diaries.append(diary)
                }
            }
            then(ResultType.sucess(diaries))
        }
    }
}

