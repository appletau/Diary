//
//  Diary.swift
//  Diary
//
//  Created by tautau on 2019/7/19.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation

struct Diary:Listable,Codable {
    var userId:String
    var date:String
    var time:String
    var imageURL:String
    var murmur:String
    var description:String
    let identifier:UUID
    
    init(userId:String = "",
         date:String = "",
         time:String = "",
         imageURL:String = "",
         murmur:String = "",
         description:String = "",
         identifier:UUID = UUID()) {
        self.userId = userId
        self.date = date
        self.time = time
        self.imageURL = imageURL
        self.murmur = murmur
        self.description = description
        self.identifier = identifier
    }
    
    init(diaryCellviewModel:DiaryCellViewModel) {
        self.userId = diaryCellviewModel.userId
        self.date = diaryCellviewModel.date
        self.time = diaryCellviewModel.time
        self.imageURL = diaryCellviewModel.imageURL
        self.murmur = diaryCellviewModel.title
        self.description = diaryCellviewModel.desc
        self.identifier = diaryCellviewModel.identifier
    }
}

extension Diary:Equatable {}
extension Diary:Hashable {}
