//
//  FolderTableViewCell.swift
//  Reminder
//
//  Created by 여성은 on 7/9/24.
//

import UIKit

final class FolderTableViewCell: BaseTableVeiwCell {
    let titleLabel = UILabel()
    let countLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
    }
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(contentView.safeAreaLayoutGuide).inset(12)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(20)
        }
    }
    func configureCell(data: Folder) {
        titleLabel.text = data.name
        countLabel.text = "(\(data.detail.count))"
    }
   
}
