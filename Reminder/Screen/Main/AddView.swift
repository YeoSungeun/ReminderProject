//
//  AddView.swift
//  Reminder
//
//  Created by 여성은 on 7/5/24.
//

import UIKit
import SnapKit

class AddView: BaseView {
    let addButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("새로운 할 일", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleEdgeInsets = .init(top: 0, left: 4, bottom: 0, right: -4)
        return button
    }()
    override func configureHierarchy() {
        self.addSubview(addButton)
    }
    override func configureLayout() {
        addButton.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
    }
    override func configureView() {
        self.backgroundColor = .clear
       
    }
}



