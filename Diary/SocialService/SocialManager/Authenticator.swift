//
//  Authenticator.swift
//  Diary
//
//  Created by tautau on 2019/12/1.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import Firebase

typealias UserId = String

protocol Authenticator {
    func login(withEmail email:String, password:String ,then:@escaping (ResultType<UserId>) -> Void)
    func signUp(withEmail email:String, password:String ,then:@escaping (ResultType<UserId>) -> Void)
}

extension Auth:Authenticator {
    func login(withEmail email: String, password: String, then: @escaping (ResultType<UserId>) -> Void) {
        self.signIn(withEmail: email, password: password) {
            guard let userId = $0?.user.uid, $1 == nil else {then(ResultType.failure($1!.localizedDescription)); return}
            then(ResultType.sucess(userId))
        }
    }
    
    func signUp(withEmail email:String, password:String ,then:@escaping (ResultType<UserId>)->Void) {
        self.createUser(withEmail: email, password: password) {
            guard let userId = $0?.user.uid, $1 == nil else {then(ResultType.failure($1!.localizedDescription)); return}
            then(ResultType.sucess(userId))
        }
    }
}
