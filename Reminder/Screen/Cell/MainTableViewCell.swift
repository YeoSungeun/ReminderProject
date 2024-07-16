//
//  MainTableViewCell.swift
//  Reminder
//
//  Created by 여성은 on 7/15/24.
//

import UIKit
import SnapKit

class MainTableViewCell: BaseTableVeiwCell {
    let view = UIView()
    
    override func configureHierarchy() {
        contentView.addSubview(view)
    }
    override func configureLayout() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func configureView() {
        contentView.backgroundColor = .red
        contentView.backgroundColor = .blue
    }
    
}

