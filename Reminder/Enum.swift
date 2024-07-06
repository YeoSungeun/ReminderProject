//
//  Enum.swift
//  Reminder
//
//  Created by 여성은 on 7/5/24.
//

import UIKit
import RealmSwift

enum TodoCategory: String, CaseIterable {
    case today = "오늘"
    case upComing = "예정"
    case all = "전체"
    case flag = "깃발"
    case done = "완료"
    
    var image: UIImage {
        var systemName = ""
        switch self {
        case .today:
            systemName = "calendar.circle.fill"
        case .upComing:
            systemName = "calendar.circle.fill"
        case .all:
            systemName = "tray.circle.fill"
        case .flag:
            systemName = "flag.circle.fill"
        case .done:
            systemName = "checkmark.circle.fill"
        }
        return UIImage(systemName: systemName)!
    }
    var backgroundColor: UIColor {
        switch self {
        case .today:
              .systemBlue
        case .upComing:
                .systemRed
        case .all:
                .systemGray
        case .flag:
                .systemYellow
        case .done:
                .systemGray2
        }
    }
    
    func getfilteredList(list: Results<Todo>!) -> Results<Todo>! {
        switch self {
        case .today:
            let start = Calendar.current.startOfDay(for: Date())
            lazy var end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
            lazy var predicate = NSPredicate(format: "duedate >= %@ && duedate < %@",
                                             start as NSDate, end as NSDate)
            return list.filter(predicate)
        case .upComing:
            return list.where {
                $0.isDone == false
            }
        case .all:
            return list
        case .flag:
            return list
        case .done:
            return list.where {
                $0.isDone == true
            }
        }
    }

}

