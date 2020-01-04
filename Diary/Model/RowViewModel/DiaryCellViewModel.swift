//
//  DairyCellViewModel.swift
//  Diary
//
//  Created by tautau on 2019/7/22.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation
import UIKit


class DiaryCellViewModel:RowViewModel{
    let identifier:UUID
    var userId:String
    var title:String
    var desc:String
    var photo:AsyncImage
    var imageURL:String
    var date:String
    var time:String
    
    init(withDiary diary:Diary){
        self.title = diary.murmur
        self.desc = diary.description
        self.photo = AsyncImage(url: diary.imageURL, placeholderImage: UIImage(named: "imagePlaceholder")!)
        self.imageURL = diary.imageURL
        self.date = diary.date
        self.time = diary.time
        self.identifier = diary.identifier
        self.userId = diary.userId
    }
}

extension DiaryCellViewModel:Hashable {
    static func == (lhs: DiaryCellViewModel, rhs: DiaryCellViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
