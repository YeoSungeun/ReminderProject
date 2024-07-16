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
        print("===============TagViewModel init===============")
        inputTag.bind { [weak self] _ in
            self?.getTag()
        }
        inputBackButtonClicked.bind { [weak self] _ in
            self?.inputClosure.value?(self?.outputTag.value ?? "")
        }
    }
    deinit {
        print("===============TagViewModel deinit===============")
    }
    func getTag() {
        guard let tag = inputTag.value, !tag.isEmpty else {
            return
        }
        outputTag.value = tag
    }
}
