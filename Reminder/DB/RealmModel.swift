//
//  RealmModel.swift
//  Reminder
//
//  Created by 여성은 on 7/3/24.
//

import UIKit
import RealmSwift

//id 제목, 메모, 마감일, isdone

class Todo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var dudate: String? // TODO: date로 변경하기
    @Persisted var tag: String?
    @Persisted var isDone: Bool
    
    convenience init(title: String, memo: String? , dudate: String?) {
        self.init()
        self.title = title
        self.memo = memo
        self.dudate = dudate
        self.tag = "#쇼핑"
        self.isDone = false
    }
}
