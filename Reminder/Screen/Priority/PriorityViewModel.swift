//
//  PriorityViewModel.swift
//  Reminder
//
//  Created by 여성은 on 7/10/24.
//

import Foundation

final class PriorityViewModel {
    var inputPriority = Observable(3)
    var outputPriority = Observable(Priority.none)
    
    var inputBackButtonClicked: Observable<Void?> = Observable(nil)
    
    var inputClosure: Observable<((Priority) -> Void)?> = Observable(nil)
 
    
    var fetchPriority:  ((Priority) -> Void)?
    
    init() {
        print("===============PriorityViewModel init===============")
        inputPriority.bind { [weak self] _ in
            self?.getPriority()
        }
        inputBackButtonClicked.bind { [weak self] _ in
            self?.inputClosure.value?(self?.outputPriority.value ?? .none)
        }
    }
    deinit {
        print("===============PriorityViewModel deinit===============")
    }
    
    func getPriority() {
        let proirity = inputPriority.value
        switch proirity {
        case 0:
            outputPriority.value = .upper
        case 1:
            outputPriority.value  = .middle
        case 2:
            outputPriority.value  = .lower
        case 3:
            outputPriority.value  = .none
        default:
            print("default")
        }
    }
}
