//
//  MainViewModel.swift
//  Reminder
//
//  Created by 여성은 on 7/15/24.
//

import Foundation
import RealmSwift

final class MainViewModel {
    
    var inputTodolList: Results<Todo>!
    var inputSearchBarText: Observable<String?> = Observable(nil)
    var outputSearchBarTextValid: Observable<Bool> = Observable(false)
    var outputSearchList: Observable<Results<Todo>?> = Observable(nil)
    
    init() {
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
}
