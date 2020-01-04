//
//  UserSocialService.swift
//  Diary
//
//  Created by tautau on 2019/12/1.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import Firebase

class UserSocialService:NSObject {
    static let share = UserSocialService()
    let queue = DispatchQueue(label: "SocialService")
    let semphore = DispatchSemaphore(value: 0)
    var dataManager:DataManager
    var imageManager:ImageManager
    var authenticator:Authenticator
    
    init(dataManager:DataManager = Database.database(),
         imageManager:ImageManager = Storage.storage(),
         authenticator:Authenticator = Auth.auth()){
        self.dataManager = dataManager
        self.imageManager = imageManager
        self.authenticator = authenticator
        super.init()
    }
}



