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
    var inputBackButtonClicked: Observable<Void?> = Observable(nil)
    
    init() {
        print("===============DuedateViewModel init===============")
        inputDate.bind { [weak self] _ in
            self?.getDate()
        }
        outputDate.value = Date()
        inputBackButtonClicked.bind { [weak self] _ in
            self?.inputClosure.value?(self?.outputDate.value ?? Date())
        }
    }
    deinit {
        print("===============DuedateViewModel deinit===============")
    }
    
    private func getDate() {
        guard let date = inputDate.value else {
            return
        }
        print(#function, date)
        outputDate.value = date
        
    }
}
