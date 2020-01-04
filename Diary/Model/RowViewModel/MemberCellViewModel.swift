//
//  MemberCellViewModel.swift
//  Diary
//
//  Created by tautau on 2019/7/22.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation
import UIKit
import SwiftIconFont

class MemberCellViewModel:RowViewModel{
    let identifier = UUID()
    var name:String
    var avatarImage:AsyncImage
    var addBtnPressed: (()->Void)?
    var isLoading:Observable<Bool>
    var isAddBtnHidden:Observable<Bool>
    var isAddBtnEnabled:Observable<Bool>
    var addBtnTitle:Observable<String>
    
    init(withMember member:Member,
         isLoading:Observable<Bool> = Observable<Bool>(value: false),
         isAddBtnHidden:Observable<Bool> = Observable<Bool>(value: false),
         isAddBtnEnabled:Observable<Bool> = Observable<Bool>(value: true),
         addBtnTitle:Observable<String> = Observable<String>(value:String.fontAwesomeIcon("plus")!),
         addBtnPressed: (() -> Void)? = nil){
        self.name = member.name
        self.avatarImage = AsyncImage(url: member.avatarUrl, placeholderImage: UIImage(named: "avatarPlaceholder")!)
        self.isLoading = isLoading
        self.isAddBtnHidden = isAddBtnHidden
        self.addBtnPressed = addBtnPressed
        self.isAddBtnEnabled = isAddBtnEnabled
        self.addBtnTitle = addBtnTitle
    }
}


extension MemberCellViewModel:Hashable {
    static func == (lhs: MemberCellViewModel, rhs: MemberCellViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
