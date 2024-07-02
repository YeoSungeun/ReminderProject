//
//  PostViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/2/24.
//

import UIKit
import RealmSwift

final class PostViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func configureHierarchy() {
        
    }
    override func configureLayout() {
         
    }
    override func configureView() {
        super.configureView()
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "새로운 할 일"
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func cancelButtonClicked() {
        print(#function)
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        print(#function)
        let realm = try! Realm()
        
        let data = Todo(title: "이것저것", memo: "요렇게저렇게", dudate: "2022.08,12")
        try! realm.write {
            realm.add(data)
            print("Realm Create Succeed")
        }
        navigationController?.popViewController(animated: true)
    }

}
