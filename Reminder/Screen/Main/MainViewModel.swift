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
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var outputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    var inputTodolList: Results<Todo>!
    var outputTodoList: Observable<Results<Todo>?> = Observable(nil)
    var outputFolderList: Observable<Results<Folder>?> = Observable(nil)
    var outputFolderListCount: Int =  0
    var outputSearchList: Observable<Results<Todo>?> = Observable(nil)
    var outputSearchListCount: Int =  0
    
    
    var inputFolderTVCellIndexPath: Observable<Int> = Observable(0)
    var outputFolderTVCellIndexPath: Observable<Int> = Observable(0)
    var outputFolderData: Observable<Folder?> = Observable(nil)
    
    var inputSearchBarText: Observable<String?> = Observable(nil)
    var inputSearchTrigger:Observable<Void?> = Observable(nil)
    var outputSearchBarTextValid: Observable<Bool> = Observable(false)
    
    
    
    var todoCategory = TodoCategory.allCases
    
    
    init() {
        print("===============MainViewModel init===============")
        inputViewDidLoadTrigger.bindLater {[weak self] _ in
            self?.fetchTodoList()
            self?.fetchFolderList()
            self?.repository.getFileURL()
        }
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.outputViewWillAppearTrigger.value = ()
        }
        //        inputSearchTrigger.bind { _ in
        //            self.validSearchBarText(self.inputSearchBarText.value)
        //            self.getSearchList(self.inputSearchBarText.value)
        //        }
        inputSearchBarText.bind { [weak self] value in
            self?.validSearchBarText(value)
            self?.getSearchList(value)
        }
        inputFolderTVCellIndexPath.bind { [weak self] value in
            self?.outputFolderTVCellIndexPath.value = value
            self?.outputFolderData.value = self?.outputFolderList.value?[value]
        }
    }
    deinit {
        print("===============MainViewModel deinit===============")
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
        //        guard let list = outputTodoList.value else { return }
        guard let text = text, !text.isEmpty else { return }
        
        outputSearchList.value = outputTodoList.value?.where {
            $0.title.contains(text, options: .caseInsensitive) && $0.isDone == false
        }
        print(#function)
        print(outputSearchList.value)
    }
    
    func fetchTodoList() {
//        DispatchQueue.main.async {
            
            self.outputTodoList.value = self.repository.fetchAll()
            print("outputTodolist", self.outputTodoList.value)
            
//        }
        
        //        outputFolderListCount = outputTodoList.value?.count ?? 0
    }
    
    func fetchFolderList() {
//        DispatchQueue.main.async {
            self.outputFolderList.value = self.repository.fetchFolder()
//        }
        //        outputSearchListCount = outputFolderList.value?.count ?? 0
    }
    
    
}
