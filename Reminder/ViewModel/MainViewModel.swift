//
//  MainViewModel.swift
//  Reminder
//
//  Created by 여성은 on 7/15/24.
//

import Foundation
import RealmSwift

final class MainViewModel {
    
    let repository = TodoRepository()
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputTodolList: Results<Todo>!
    var outputTodoList: Observable<Results<Todo>?> = Observable(nil)
    var outputFolderList: Observable<Results<Folder>?> = Observable(nil)
    var inputSearchBarText: Observable<String?> = Observable(nil)
    var outputSearchBarTextValid: Observable<Bool> = Observable(false)
    var outputSearchList: Observable<Results<Todo>?> = Observable(nil)
    
    init() {
        inputViewDidLoadTrigger.bind { _ in
            self.fetchTodoList()
            self.fetchFolderList()
        }
        inputSearchBarText.bind { value in
            self.validSearchBarText(value)
            self.getSearchList(value)
        }
    }
    
    func validSearchBarText(_ text: String?) {
        guard let text = text, !text.isEmpty else {
            // searchbar.text 따라 valid -> bool
            outputSearchBarTextValid.value = false
            return
        }
        outputSearchBarTextValid.value = true
        
    }
    func getSearchList(_ text: String?) {
        guard let text = text, !text.isEmpty else { return }
        outputSearchList.value = inputTodolList.where {
            $0.title.contains(text, options: .caseInsensitive)
        }
    }
    
    func fetchTodoList() {
        outputTodoList.value = repository.fetchAll()
    }
    
    func fetchFolderList() {
        outputFolderList.value = repository.fetchFolder()
    }
    
}
