//
//  BaseViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/2/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    func configureHierarchy() {
        print(#function)
    }
    func configureLayout() {
        print(#function)
    }
    func configureView() {
        print(#function)
        view.backgroundColor = .systemBackground
    }
}
