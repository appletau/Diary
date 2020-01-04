//
//  Extensionss.swift
//  Diary
//
//  Created by tautau on 2019/7/20.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UIAlertController {
    convenience init(title:String ,message:String) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "OK", style: .default))
    }
    
    convenience init(title:String, message:String, textfieldPlaceholder:[String] = [] , okAction:@escaping ([UITextField]?)->Void) {
        self.init(title: title, message: message, preferredStyle: .alert)
        for placeholder in textfieldPlaceholder {
            addTextField{$0.placeholder = placeholder}
        }
        let okBtnPressed = UIAlertAction(title: "OK", style: .default) { (_) in
            okAction(self.textFields)
        }
        
        let cancelBtnPressed = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAction(okBtnPressed)
        addAction(cancelBtnPressed)
    }
    
    func activatedBy(vc:UIViewController) {
        vc.present(self, animated: false)
    }
}

extension UIImage {
    var resizeImage:UIImage {
        let widthInPixel: CGFloat = 256
        let widthInPoint = widthInPixel / UIScreen.main.scale
        let size = CGSize(width: widthInPoint, height:
            self.size.height * widthInPoint / self.size.width)
        let renderer = UIGraphicsImageRenderer(size: size)
        let newImage = renderer.image { (context) in
           self.draw(in: renderer.format.bounds)
        }
        return newImage
    }
}

extension UITableViewCell {
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

extension JSONEncoder {
    func enocdeToJsonString<T:Codable>(withObject object:T)->String? {
        self.outputFormatting = .prettyPrinted
        guard let jsonData = try? self.encode(object) else{return nil}
        return String(data: jsonData, encoding: .utf8)
    }
}

extension JSONDecoder {
    func decodeToObject<T:Codable>(withType type:T.Type, from jsonString:String) -> T? {
        guard let data = jsonString.data(using: .utf8), let object = try? self.decode(type, from: data) else{return nil}
        return object
    }
}

extension Int {
    var string:String {
        return String(format: "%02d", self)
    }
}

