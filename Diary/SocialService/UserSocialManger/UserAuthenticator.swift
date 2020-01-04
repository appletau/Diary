//
//  UserAuthenticator.swift
//  Diary
//
//  Created by tautau on 2019/12/1.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import UIKit

protocol UserAuthenticator {
    func login(withEmail email:String, password:String ,then:@escaping (ResultType<UserId>) -> Void)
    func signUp(withUserInfo info:Member,password:String, image:UIImage ,then:@escaping (ResultType<Member>) -> Void)
}

extension UserSocialService:UserAuthenticator {
    func login(withEmail email: String, password: String, then: @escaping (ResultType<UserId>) -> Void) {
        self.queue.async {
            self.authenticator.login(withEmail: email, password: password) {then($0); self.semphore.signal()}
            self.semphore.wait()
        }
    }
    
    func signUp(withUserInfo info: Member, password: String, image: UIImage, then: @escaping (ResultType<Member>) -> Void) {
        self.authenticator.signUp(withEmail: info.email, password: password) {
            guard let id = $0.value else {then(ResultType.failure($0.errorMessage!)); return}
            var newInfo = info
            newInfo.id = id
            self.save(userInfo: newInfo, withImage: image){then($0)}
        }
    }
}
