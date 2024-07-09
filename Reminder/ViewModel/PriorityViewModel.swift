//
//  PriorityViewModel.swift
//  Reminder
//
//  Created by 여성은 on 7/10/24.
//

import Foundation

class PriorityViewModel {
    var inputPriority = Observable(3)
    var outputPriority = Observable(Priority.none)
    
    init() {
        inputPriority.bind { _ in
            self.getPriority()
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
