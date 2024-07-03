//
//  PostItemButtonView.swift
//  Reminder
//
//  Created by 여성은 on 7/3/24.
//

import UIKit
import SnapKit

class PostItemButtonView: UIView {
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let chevronImageVeiw = UIImageView()
    let moreButton = UIButton()
    
    init(title: String) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureView(title: title)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
        self.addSubview(chevronImageVeiw)
        self.addSubview(moreButton)
    
    }
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        chevronImageVeiw.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.verticalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.width.equalTo(chevronImageVeiw.snp.height).multipliedBy(0.5)
        }
        detailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(chevronImageVeiw.snp.leading).offset(-8)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
        moreButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
    }
    func configureView(title: String) {
        self.backgroundColor = .systemBackground
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15)
        detailLabel.textAlignment = .right
        detailLabel.textColor = .systemGray2
        detailLabel.font = .systemFont(ofSize: 13)
        chevronImageVeiw.image = UIImage(systemName: "chevron.forward")
        chevronImageVeiw.tintColor = .systemGray2
    }
}
