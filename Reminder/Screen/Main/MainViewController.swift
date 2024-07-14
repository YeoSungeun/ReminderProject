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
    var folderList: Results<Folder>!

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
    lazy var folderTableVeiw = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(FolderTableViewCell.self, forCellReuseIdentifier: FolderTableViewCell.id)
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    let addView = AddView()
    
    let start = Calendar.current.startOfDay(for: Date())
    lazy var end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
    lazy var predicate = NSPredicate(format: "duedate >= %@ && duedate < %@",
                                     start as NSDate, end as NSDate)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainCollectionView.reloadData()
        folderTableVeiw.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        todoList = repository.fetchAll()
        folderList = repository.fetchFolder()
        print(folderList)
        repository.getFileURL()
        
    }
        
    override func configureHierarchy() {
        print(#function)
        view.addSubview(searchBar)
        view.addSubview(mainCollectionView)
        view.addSubview(addView)
        view.addSubview(folderTableVeiw)
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
            make.height.equalTo(300)
        
        }
        folderTableVeiw.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionView.snp.bottom).offset(8)
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
        vc.reloadTableView = {
            self.mainCollectionView.reloadData()
            self.folderTableVeiw.reloadData()
        }
        present(nav, animated: true)
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

extension MainViewController: UISearchBarDelegate {
    // 실시간 검색 등
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function,indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell()}
        let categoryType = category[indexPath.item]
        cell.categoryImageView.image = categoryType.image
        cell.categoryImageView.tintColor = categoryType.backgroundColor
        cell.categoryTitle.text = categoryType.rawValue
        cell.countLabel.text = "\(categoryType.getfilteredList(list: todoList).count)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function,"\(indexPath)")
        let vc = ListViewController()
        let category = category[indexPath.row]
        vc.category = category
//        vc.listTitleLabel.text = category.rawValue
//        vc.list = Array(category.getfilteredList(list: todoList))
        vc.resultsList = todoList
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.id, for: indexPath) as? FolderTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = folderList[indexPath.row].name
        cell.countLabel.text = "(\(folderList[indexPath.row].detail.count))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FolderedListViewController()
        vc.folder = folderList[indexPath.row]
        vc.listTitleLabel.text = folderList[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
}

