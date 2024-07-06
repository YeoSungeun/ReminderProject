//
//  MainCollectionViewCell.swift
//  Reminder
//
//  Created by 여성은 on 7/4/24.
//

import UIKit
import SnapKit

class MainCollectionViewCell: BaseCollectionViewCell {

    let cellUIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    lazy var categoryImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        return view
    }()
    let categoriImageBackgroundView = {
        let view = UIView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    lazy var categoryTitle = {
        let view = UILabel()
        view.textColor = .systemGray3
        view.font = .boldSystemFont(ofSize: 16)
        return view
    }()
    let countLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 28, weight: .bold)
        return view
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(cellUIView)
        cellUIView.addSubview(categoriImageBackgroundView)
        cellUIView.addSubview(categoryImageView)
        cellUIView.addSubview(categoryTitle)
        cellUIView.addSubview(countLabel)
    }
    override func configureLayout() {
        cellUIView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        categoryImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(cellUIView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(40)
        }
        categoriImageBackgroundView.snp.makeConstraints { make in
            make.center.equalTo(categoryImageView.snp.center)
            make.size.equalTo(32)
        }
        categoryTitle.snp.makeConstraints { make in
            make.leading.equalTo(cellUIView.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(categoryImageView.snp.bottom).offset(8)
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(cellUIView.safeAreaLayoutGuide).inset(8)
            make.trailing.equalTo(cellUIView.safeAreaLayoutGuide).inset(16)
        }
    }


}
#if DEBUG
@available (iOS 17, *)
#Preview {
    MainCollectionViewCell()
}
#endif
