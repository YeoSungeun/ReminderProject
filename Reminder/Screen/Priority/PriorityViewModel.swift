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
        inputPriority.bind { _ in
            self.getPriority()
        }
//        inputClosure.bind { value in
//            value?(self.outputPriority.value)
//        }
        inputBackButtonClicked.bind { _ in
            self.inputClosure.value?(self.outputPriority.value)
        }
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
