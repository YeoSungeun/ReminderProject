//
//  Date+Extension.swift
//  Reminder
//
//  Created by 여성은 on 7/6/24.
//

import UIKit

extension Date {
    func dateToString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko")
        dateformatter.dateFormat = "yyyy.MM.dd (EE)"  // 변환할 형식
        let dateString = dateformatter.string(from: self)
        return dateString
    }
}
