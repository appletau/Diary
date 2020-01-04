//
//  ResultType.swift
//  Diary
//
//  Created by tautau on 2019/12/1.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation

enum ResultType<T> {
    case sucess(T)
    case failure(String)
    
    var value:T? {
        switch self {
        case let .sucess(v):
            return v
        default:
            return nil
        }
    }
    
    var errorMessage:String? {
        switch self {
        case let .failure(m):
            return m
        default:
            return nil
        }
    }
}
