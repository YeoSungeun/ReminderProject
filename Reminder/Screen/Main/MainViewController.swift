//
//  MainViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/4/24.
//

import UIKit
import RealmSwift
import FSCalendar

class MainViewController: BaseViewController {
    
    let category = TodoCategory.allCases
    var todoList: Results<Todo>!
    let repository = TodoRepository()

    lazy var searchBar = {
       let view = UISearchBar()
        view.delegate = self
        view.placeholder = "검색"
        view.backgroundColor = .secondarySystemBackground
        view.searchTextField.backgroundColor = .systemGray6
        view.searchBarStyle = .minimal
        return view
    }()
    lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let addView = AddView()
    
    let start = Calendar.current.startOfDay(for: Date())
    lazy var end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
    lazy var predicate = NSPredicate(format: "duedate >= %@ && duedate < %@",
                                     start as NSDate, end as NSDate)

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        todoList = repository.fetchAll()
        repository.getFileURL()
        
    }
        
    override func configureHierarchy() {
        print(#function)
        view.addSubview(searchBar)
        view.addSubview(mainCollectionView)
        view.addSubview(addView)
    }
    override func configureLayout() {
        print(#function)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        addView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(60)
            
        }
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(addView.snp.top)
        
        }
        
        
    }
    override func configureView() {
        print(#function)
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.id)
        mainCollectionView.backgroundColor = .secondarySystemBackground
        addView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
    }
    @objc func addButtonClicked() {
        let vc = PostViewController()
        let nav = UINavigationController(rootViewController: vc)
//        vc.reloadTableView = {
//            self.tableView.reloadData()
//        }
        present(nav, animated: true)
    }
   
    func collectionViewLayout() -> UICollectionViewLayout {
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function,"\(indexPath)")
        let vc = ListViewController()
        switch category[indexPath.row] {
        case .today:
            vc.listTitleLabel.text = category[indexPath.row].rawValue
            vc.list = todoList.filter(predicate)
        case .upComing:
            vc.listTitleLabel.text = category[indexPath.row].rawValue
            vc.list = todoList.where {
                $0.isDone == false
            }
        case .all:
            vc.listTitleLabel.text = category[indexPath.row].rawValue
            vc.list = todoList
        case .flag:
            vc.listTitleLabel.text = category[indexPath.row].rawValue
            vc.list = todoList
        case .done:
            vc.listTitleLabel.text = category[indexPath.row].rawValue
            vc.list = todoList.where {
                $0.isDone == true
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
  
    
    
}


