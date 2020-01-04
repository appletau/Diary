//
//  AsyncImage.swift
//  Diary
//
//  Created by tautau on 2019/9/3.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation
import UIKit

class AsyncImage {
    
    let url: String
    var completeDownload: ((UIImage?) -> Void)?
    var image:UIImage {
        set {
            self.imageStore = newValue
        }
        
        get {
            if let image  = self.imageStore {
                return image
            }else {
                return self.placeholder
            }
        }
    }
    
    private var imageStore: UIImage?
    private var placeholder: UIImage
    private var isDownloading: Bool = false
    
    init(url: String,placeholderImage: UIImage) {
        self.url = url
        self.placeholder = placeholderImage
    }
    
    func startDownload() {
        if let image = imageStore {
            completeDownload?(image)
        } else {
            if isDownloading {return}
            completeDownload?(placeholder)
            isDownloading = true
            UserSocialService.share.download(withPath: url) { (result) in
                self.imageStore = result.value
                self.isDownloading = false
                self.completeDownload?(result.value)
            }
        }
    }
}
