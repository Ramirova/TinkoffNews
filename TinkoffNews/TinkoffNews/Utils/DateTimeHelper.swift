//
//  DateTimeHelper.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 19/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation

class DateTimeHelper {
    static func getFormattedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return dateFormatter.string(from: getDateObj(date: date))
    }
    
    static func getDateObj(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatterWithoutMilliseconds = DateFormatter()
        dateFormatterWithoutMilliseconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var dateObj = Date()
        if (dateFormatter.date(from: date) != nil) {
            dateObj = dateFormatter.date(from: date)!
        } else {
            dateObj = dateFormatterWithoutMilliseconds.date(from: date)!
        }
        return dateObj
    }
    
    static func getTimexCountInRightForm(forNumber: Int) -> String {
        if forNumber > 5 && forNumber < 22 {
            return "раз"
        }
        switch forNumber % 10 {
        case 2, 3, 4:
            return "раза"
        default:
            return "раз"
        }
    }
}
