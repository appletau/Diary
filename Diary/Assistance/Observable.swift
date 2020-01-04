//
//  Observable.swift
//  Diary
//
//  Created by tautau on 2019/7/22.
//  Copyright © 2019年 tautau. All rights reserved.
//

import Foundation

class Observable<T>{
    private var valueChanged:[((T)->Void)?] = []
    var value: T {
        didSet {
            DispatchQueue.main.async { [value] in
                self.valueChanged.forEach{$0?(value)}
            }
        }
    }
    
    init(value:T) {
        self.value = value
    }
    
    func addObserver(fireNow:Bool = true, _ onChange:((T)->Void)?) {
        self.valueChanged.append(onChange)
        if fireNow{ onChange?(value)}
    }
    
    func removeObserver(atIndex index:Int){
        valueChanged.remove(at: index)
    }
}
