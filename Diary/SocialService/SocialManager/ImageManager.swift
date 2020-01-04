//
//  ImageManager.swift
//  Diary
//
//  Created by tautau on 2019/12/1.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import Firebase

typealias UrlString = String

protocol ImageManager {
    func upload(imageData:Data, withPath path:String ,then:@escaping (ResultType<UrlString>) -> Void)
    func download(withPath path:String, then:@escaping (ResultType<Data>) -> Void)
}

extension Storage:ImageManager{
    func upload(imageData: Data, withPath path: String, then: @escaping (ResultType<UrlString>) -> Void) {
        let imageRef = self.reference().child(path)
        imageRef.putData(imageData, metadata: nil) {
            guard let urlString = $0?.path, $1 == nil else {then(ResultType.failure($1!.localizedDescription));return}
            then(ResultType.sucess(urlString))
        }
    }
    
    func download(withPath path: UrlString, then: @escaping (ResultType<Data>) -> Void) {
        let imageRef = self.reference().child(path)
        imageRef.getData(maxSize: 1 * 1024 * 1024) {
            guard let imageData = $0, $1 == nil else {then(ResultType.failure($1!.localizedDescription));return}
            then(ResultType.sucess(imageData))
        }
    }
}

