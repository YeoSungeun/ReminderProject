//
//  TagViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/3/24.
//

import UIKit
import SnapKit

final class TagViewController: BaseViewController {
    
    let tagTextField = {
        let view = UITextField()
        view.placeholder = "태그를 입력하세요."
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        return view
    }()
    let tagView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var getTag: ((String) -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func configureHierarchy() {
        view.addSubview(tagView)
        view.addSubview(tagTextField)
    }
    override func configureLayout() {
        tagView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(160)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        tagTextField.snp.makeConstraints { make in
            make.leading.equalTo(tagView.snp.leading).inset(16)
            make.trailing.equalTo(tagView.snp.trailing).inset(16)
            make.centerY.equalTo(tagView.snp.centerY)
        }
    }
    override func configureView() {
        view.backgroundColor = .secondarySystemBackground
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func backButtonClicked() {
        print(#function)
        guard let tag = tagTextField.text, !tag.isEmpty else {
            navigationController?.popViewController(animated: true)
            return
        }
        getTag?(tag)
        navigationController?.popViewController(animated: true)
    }
}
