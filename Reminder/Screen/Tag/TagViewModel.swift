//
//  tagViewModel.swift
//  Reminder
//
//  Created by 여성은 on 7/10/24.
//

import Foundation

final class TagViewModel {
    
    var inputTag: Observable<String?> = Observable(nil)
    var outputTag: Observable<String?> = Observable(nil)
    var inputBackButtonClicked: Observable<Void?> = Observable(nil)
    var inputClosure: Observable<((String) -> Void)?> = Observable(nil)
    
    init() {
        inputTag.bind { _ in
            self.getTag()
        }
        inputBackButtonClicked.bind { _ in
            self.inputClosure.value?(self.outputTag.value ?? "")
        }
    }
    func getTag() {
        guard let tag = inputTag.value, !tag.isEmpty else {
            return
        }
        outputTag.value = tag
    }
}
