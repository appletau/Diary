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
        var startDate = StructOfDate(date: periodBeforeDate)
        let endDate = StructOfDate(date: date)
        if startDate.year != endDate.year {startDate = StructOfDate(year: endDate.year, month: 1, day: 1)}
        if startDate.month == endDate.month{
            array.append(QueryPath(main:"\(startDate.year)_\(startDate.month.string)", startValue: startDate.day.string, endValue: endDate.day.string))
        } else {
            array.append(QueryPath(main: "\(startDate.year)_\(startDate.month.string)", startValue: startDate.day.string, endValue: "31"))
            let count = endDate.month - startDate.month - 1
            if count >= 1 {
                for i in 1...count {array.append(QueryPath(main: "\(startDate.year)_\(startDate.month + i)", startValue: "01", endValue: "31"))}
            }
            array.append(QueryPath(main: "\(endDate.year)_\(endDate.month.string)", startValue: "1", endValue: endDate.day.string))
        }
        return array
    }
}
