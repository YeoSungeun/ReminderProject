//
//  PostViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/2/24.
//

import UIKit
import RealmSwift

final class PostViewController: BaseViewController {
    // MARK: lazy로 하면 되는듯
    lazy var cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
    lazy var addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
    
    lazy var titleTextField = {
        let view = UITextField()
        view.placeholder = "제목"
        view.delegate = self
        return view
    }() 
    let textViewPlaceholder = "메모를 입력하세요."
    lazy var memoTextView = {
        let view = UITextView()
        view.text = textViewPlaceholder
        view.font = .systemFont(ofSize: 16)
        view.textColor = .systemGray3
        view.delegate = self
        return view
    }()
    let divider = UIView()
    let contentsView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    let dueDateLabel = PostItemButtonView(title: "마감일")
    let tagLabel = PostItemButtonView(title: "태그")
    let priorityLabel = PostItemButtonView(title: "우선 순위")
    let addImageLabel = PostItemButtonView(title: "이미지 추가")

    var reloadTableView: (() -> Void)?
    var tag: String?
    var priorityType: Priority = .none
    var dueDate: Date?
    
    let repository = TodoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillDisappear(_ animated: Bool) {
        reloadTableView?()
    }
    override func configureHierarchy() {
        view.addSubview(contentsView)
        contentsView.addSubview(titleTextField)
        contentsView.addSubview(divider)
        contentsView.addSubview(memoTextView)
        view.addSubview(dueDateLabel)
        view.addSubview(tagLabel)
        view.addSubview(priorityLabel)
        view.addSubview(addImageLabel)
    }
    override func configureLayout() {
        contentsView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(200)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(contentsView.snp.top)
            make.horizontalEdges.equalTo(contentsView.snp.horizontalEdges).inset(16)
            make.height.equalTo(40)
        }
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.leading.equalTo(contentsView.snp.leading).offset(16)
            make.trailing.equalTo(contentsView.snp.trailing)
            make.height.equalTo(0.5)
        }
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalTo(contentsView.safeAreaLayoutGuide).inset(12)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(dueDateLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        addImageLabel.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        
    }
    override func configureView() {
        super.configureView()
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "새로운 할 일"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
        addButton.isEnabled = false

        dueDateLabel.moreButton.addTarget(self, action: #selector(dueDateLabelClicked), for: .touchUpInside)
        tagLabel.moreButton.addTarget(self, action: #selector(tagLabelClicked), for: .touchUpInside)
        priorityLabel.moreButton.addTarget(self, action: #selector(priorityLabelClicked), for: .touchUpInside)
        addImageLabel.moreButton.addTarget(self, action: #selector(addImageLabelClicked), for: .touchUpInside)
        
        
    }
    @objc func dueDateLabelClicked() {
        print(#function)
        let vc = DuedateViewController()
        vc.getDate = { date in
            print(date)
            self.dueDate = date
            self.dueDateLabel.detailLabel.text = date.dateToString()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tagLabelClicked() {
        print(#function)
        let vc = TagViewController()
        vc.getTag = { data in
            print(data)
            self.tag = data
            self.tagLabel.detailLabel.text = "#" + data
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func priorityLabelClicked() {
        print(#function)
        let vc = PriorityViewController()
        vc.getPriority = { priority in
            print(priority)
            self.priorityType = priority
            if priority != .none {
                self.priorityLabel.detailLabel.text = priority.rawValue
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func addImageLabelClicked() {
        print(#function)
    }

    
    @objc func cancelButtonClicked() {
        print(#function)
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        print(#function)
//        guard let title = titleTextField.text, !title.isEmpty else {
//            showAlert(title: "제목을 입력해 주세요", message: "", ok: "확인") {
//                print("alert")
//            }
//            return
//        }
        let title = titleTextField.text ?? ""
        let memo = memoTextView.text ?? nil
        let duedate = dueDate ?? nil
        let tag = tag
        let priority = priorityType
        let data = Todo(title: title, memo: memo, duedate: duedate, tag: tag, priority: priority)
        repository.createItem(data)
        dismiss(animated: true)
    }

}
extension PostViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(#function)
        guard let text = textField.text, !text.isEmpty else {
            self.addButton.isEnabled = false
            return
        }
        self.addButton.isEnabled = true
    }
}
extension PostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholder && textView.textColor == .systemGray3 {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = .systemGray3
        }
    }

}
