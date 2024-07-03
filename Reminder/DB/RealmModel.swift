//
//  RealmModel.swift
//  Reminder
//
//  Created by 여성은 on 7/3/24.
//

import UIKit
import RealmSwift

//id 제목, 메모, 마감일, isdone

enum Priority: String, CaseIterable, PersistableEnum {
    case upper = "높음"
    case middle = "보통"
    case lower = "낮음"
    case none = "설정 안함"
}

class Todo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var duedate: String?
    @Persisted var tag: String?
    @Persisted var priority: Priority
    @Persisted var isDone: Bool
    
    convenience init(title: String, memo: String? , duedate: String?, tag: String?, priority: Priority) {
        self.init()
        self.title = title
        self.memo = memo
        self.duedate = duedate
        self.tag = tag
        self.priority = priority
        self.isDone = false
    }
}
