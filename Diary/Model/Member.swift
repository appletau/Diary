//
//  Member.swift
//  Diary
//
//  Created by tautau on 2019/7/19.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation

struct Member:Listable,Codable{
    var id:String
    var name:String
    var email:String
    var avatarUrl:String
    
    init(
        name:String = "",
        email:String = "",
        id:String = "",
        avatarUrl:String = "",
        friends:[Member] = []) {
        self.name = name
        self.email = email
        self.id = id
        self.avatarUrl = avatarUrl
    }
}
extension Member:Equatable {}
