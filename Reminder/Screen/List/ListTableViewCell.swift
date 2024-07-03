//
//  ListTableViewCell.swift
//  Reminder
//
//  Created by 여성은 on 7/2/24.
//

import UIKit

class ListTableViewCell: BaseTableVeiwCell {
    
    let radioButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "circle"), for: .normal) // t/f에 따라서 circle.inset.filled
        return view
    }()
    let priorityLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        view.textColor = .systemBlue
        return view
    }()
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        return view
    }()
    let memoLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .systemGray
        return view
    }()
    let dueDateLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .systemGray
        return view
    }()
    let tagLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .systemIndigo.withAlphaComponent(0.7)
        return view
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(radioButton)
        contentView.addSubview(priorityLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(dueDateLabel)
        contentView.addSubview(tagLabel)
    }
    override func configureLayout() {
        radioButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(20)
        }
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(radioButton.snp.trailing).offset(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(priorityLabel.snp.trailing).offset(4)
        }
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
            
        }
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
          
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(dueDateLabel.snp.top)
            make.leading.equalTo(dueDateLabel.snp.trailing).offset(4)
           
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
    }
    override func configureView() {
        radioButton.tintColor = .systemGray
        priorityLabel.textColor = .systemBlue
    }
}
