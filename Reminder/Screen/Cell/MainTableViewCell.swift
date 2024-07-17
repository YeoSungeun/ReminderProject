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
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func configureHierarchy() {
        contentView.addSubview(view)
        view.addSubview(collectionView)
    }
    override func configureLayout() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
    }
    override func configureView() {
        contentView.backgroundColor = .red
        contentView.backgroundColor = .blue
    }
    func collectionViewLayout() -> UICollectionViewLayout {
        let width = UIScreen.main.bounds.width - 60
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: width/2, height: (width/2) * 0.55)
        return layout
    }
    
}

