//
//  Enum.swift
//  Reminder
//
//  Created by 여성은 on 7/5/24.
//

import Foundation

enum TodoCategory: String, CaseIterable {
    case today = "오늘"
    case upComing = "예정"
    case all = "전체"
    case flag = "깃발"
    case done = "완료"
}
