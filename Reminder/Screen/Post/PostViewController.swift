//
//  PostViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/2/24.
//

import UIKit
import RealmSwift

final class PostViewController: BaseViewController {
    
    let titleTextField = {
        let view = UITextField()
        view.placeholder = "제목"
        return view
    }()
    let memoTextView = {
        let view = UITextView()
        view.text = "메모"
        return view
    }()
    let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func configureHierarchy() {
        view.addSubview(titleTextField)
    }
    override func configureLayout() {
        titleTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(32)
        }
    }
    override func configureView() {
        super.configureView()
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "새로운 할 일"
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.rightBarButtonItem = addButton
        
        titleTextField.backgroundColor = .systemGray2
    }
    
    @objc func cancelButtonClicked() {
        print(#function)
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        print(#function)
        let realm = try! Realm()
        
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(title: "제목을 입력해 주세요", message: "", ok: "확인") {
                print("alert")
            }
            return
        }
        
        let data = Todo(title: title, memo: "요렇게저렇게", dudate: "2022.08,12")
        try! realm.write {
            realm.add(data)
            print("Realm Create Succeed")
        }
        dismiss(animated: true)
    }

}
