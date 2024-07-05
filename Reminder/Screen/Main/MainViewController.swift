//
//  MainViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/4/24.
//

import UIKit

class MainViewController: BaseViewController {

    lazy var searchBar = {
       let view = UISearchBar()
        view.delegate = self
        view.placeholder = "검색"
        return view
    }()
    lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mainLayout())
    override func configureHierarchy() {
        view.addSubview(searchBar)
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    override func configureView() {
        
    }
    func mainLayout() {
        
    }
    func mainLayout() -> UICollectionViewLayout {
        let width = UIScreen.main.bounds.width - 60
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: width/2, height: width/4)
        return layout
    }
}

extension MainViewController: UISearchBarDelegate {
    // 실시간 검색 등
}
