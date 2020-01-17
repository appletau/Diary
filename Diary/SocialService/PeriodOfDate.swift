//
//  File.swift
//  Diary
//
//  Created by tautau on 2019/12/20.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation

struct QueryPath {
    var main:String
    var startValue:String
    var endValue:String
    
    init(main:String, startValue:String ,endValue:String) {
        self.main = main
        self.startValue = startValue
        self.endValue = endValue
    }
}

struct StructOfDate {
    var year:Int
    var month:Int
    var day:Int
    
    init(year:Int, month:Int, day:Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    init(date:Date) {
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }
}


enum PeriodOfDate {
    case weekBefore(date:Date)
    case aMonthBefore(date:Date)
    case threeMonthBefore(date:Date)
    case halfYearBefore(date:Date)
    case aYearBefore(date:Date)
    
    var paths:[QueryPath] {
        switch self {
        case .weekBefore(let date):
            return queryPaths(date: date, period: 7)
        case .aMonthBefore(let date):
            return queryPaths(date: date, period: 31)
        case .threeMonthBefore(let date):
            return queryPaths(date: date, period: 93)
        case .halfYearBefore(let date):
            return queryPaths(date: date, period: 183)
        case .aYearBefore(let date):
            return queryPaths(date: date, period: 366)
            
        }
    }
    
    private func queryPaths(date:Date, period:Int) -> [QueryPath] {
        var array:Array<QueryPath> = []
        guard let periodBeforeDate = Calendar.current.date(byAdding: .day, value: -period, to: date) else {fatalError("Fuccccck")}
        let startDate = StructOfDate(date: periodBeforeDate)
        let endDate = StructOfDate(date: date)
        
        if startDate.year != endDate.year {
            var interval = 12 - startDate.month
            for i in 0...interval {
                array.append(QueryPath(main: "\(startDate.year)_" + (startDate.month + i).string, startValue: "01", endValue: "31"))
            }
            interval = endDate.month - 1
            for i in 0...interval {
                array.append(QueryPath(main: "\(endDate.year)_" + (endDate.month - i).string, startValue: "01", endValue: "31"))
            }
        } else {
            let interval = endDate.month - startDate.month
            for i in 0...interval {
                array.append(QueryPath(main: "\(startDate.year)_" + (startDate.month + i).string, startValue: "01", endValue: "31"))
            }
        }
        return array
    }
}
