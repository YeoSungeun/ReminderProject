//
//  DuedateViewModel.swift
//  Reminder
//
//  Created by 여성은 on 7/10/24.
//

import Foundation

class DuedateViewModel {
    var inputDate: Observable<Date?> = Observable(nil)
    var outputDate: Observable<Date?> = Observable(nil)
    var inputClosure: Observable<((Date) -> Void)?> = Observable(nil)
    
    init() {
        print("viewmodel init")
        inputDate.bind { _ in
            self.getDate()
        }
        outputDate.value = Date()
        inputClosure.bind { _ in
            self.inputClosure.value?(self.outputDate.value ?? Date())
        }
    
    }
    
    private func getDate() {
        guard let date = inputDate.value else {
            return
        }
        outputDate.value = date
        
    }
}
