//
//  UserImageManager.swift
//  Diary
//
//  Created by tautau on 2019/12/1.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import UIKit

protocol UserImageManager {
    func upload(image:UIImage, withPath path:String ,then:@escaping(ResultType<UrlString>) -> Void)
    func download(withPath path:String, then:@escaping (ResultType<UIImage>) -> Void)
}

extension UserSocialService:UserImageManager {
    func upload(image: UIImage, withPath path: String, then: @escaping (ResultType<UrlString>) -> Void) {
        guard let uploadData = image.pngData() else{fatalError("image is nil")}
        self.imageManager.upload(imageData: uploadData, withPath: path) {then($0)}
    }
    
    func download(withPath path: String, then: @escaping (ResultType<UIImage>) -> Void) {
        self.imageManager.download(withPath: path) {
            guard let data = $0.value else {then(ResultType.failure($0.errorMessage!)); return}
            guard let image = UIImage(data: data) else {then(ResultType.failure("UIimage init failed")); return}
            then(ResultType.sucess(image))
        }
    }
}
