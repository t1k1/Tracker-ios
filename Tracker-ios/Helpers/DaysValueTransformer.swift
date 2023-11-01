//
//  DaysValueTransformer.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 24.10.2023.
//

import Foundation

final class DaysValueTransformer {
    static let shared = DaysValueTransformer()
    
    private init() {}
    
    func weekDaysToString(_ weekDays: [WeekDay]) -> String {
        var result = ""
        weekDays.forEach { weekDay in
            result += "\(String(weekDay.numberOfDay)) "
        }
        
        return result
    }
    
    func stringToWeekDays(_ str: String) -> [WeekDay] {
        var result: [WeekDay] = []
        
        let numbersOfDays = str.components(separatedBy: " ")
        numbersOfDays.forEach { number in
            switch number {
                case "2":
                    result.append(.monday)
                case "3":
                    result.append(.tuesday)
                case "4":
                    result.append(.wednesday)
                case "5":
                    result.append(.thursday)
                case "6":
                    result.append(.friday)
                case "7":
                    result.append(.saturday)
                case "1":
                    result.append(.sunday)
                default:
                    break
            }
        }
        return result
    }
}
