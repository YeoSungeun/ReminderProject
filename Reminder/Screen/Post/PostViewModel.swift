//
//  PostViewModel.swift
//  Reminder
//
//  Created by 여성은 on 7/11/24.
//

import Foundation

final class PostViewModel {
    
    let repository = TodoRepository()
    
    var inputTitle: Observable<String?> = Observable(nil)
    var inputSelectedPriority = Observable<Priority>(.lower)
    var outputTitleValid = Observable(false)
    var outputTilte: Observable<String?> = Observable(nil)
    
    let textViewPlaceholder = "메모를 입력하세요."
    // 메모 placeholdermode인지 아닌지
    // 라면 nil 아니라면 text outputtext에 넣어주기
    var inputMemo: String?
    var inputDuedate: Date?
    var inputPriority: Priority = .none
    var inputTag: String?
    
    
    // 에드버튼 누르면 누른거 인식
    // 그러면 저장해주기~
    var inputAddButtonClicked: Observable<Void?> = Observable(nil)
    
    init() {
        inputTitle.bind { value in
            self.validTitle(value)
        }
        inputAddButtonClicked.bind { _ in
            guard let title = self.outputTilte.value else { return }
            let data = Todo(title: title, memo: self.inputMemo, duedate: self.inputDuedate, tag: self.inputTag, priority: self.inputPriority)
            self.saveTodo(data)
        }
        
    }
    
    func validTitle(_ title: String?) {
        guard let title = inputTitle.value, !title.isEmpty else {
            outputTitleValid.value = false
            return
        }
        outputTitleValid.value = true
        outputTilte.value = title
    }
    func saveTodo(_ data: Todo) {
        repository.createItem(data)
    }
    
    
    
}
