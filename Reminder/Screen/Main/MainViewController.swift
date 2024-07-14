//
//  MainViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/4/24.
//

import UIKit
import RealmSwift
import FSCalendar

final class MainViewController: BaseViewController {
    
    let category = TodoCategory.allCases
//    var todoList: Results<Todo>! 
    var searchList: Results<Todo>! = nil
    let repository = TodoRepository()
//    var folderList: Results<Folder>!
    
    let viewModel = MainViewModel()

    lazy var searchBar = {
       let view = UISearchBar()
        view.delegate = self
        view.placeholder = "검색"
        view.backgroundColor = .secondarySystemBackground
        view.searchTextField.backgroundColor = .systemGray6
        view.searchBarStyle = .minimal
        return view
    }()

    let mainView = UIView()
    let searchView = UIView()
    
    lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    lazy var folderTableVeiw = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(FolderTableViewCell.self, forCellReuseIdentifier: FolderTableViewCell.id)
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    lazy var searchTableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
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
        viewModel.inputViewDidLoadTrigger.value = ()
//        todoList = repository.fetchAll()
//        viewModel.inputTodolList = todoList
//        folderList = repository.fetchFolder()
        repository.getFileURL()
        bindData()
    }
        
    override func configureHierarchy() {
        print(#function)
        view.addSubview(mainView)
        view.addSubview(searchView)
        view.addSubview(searchBar)
        mainView.addSubview(mainCollectionView)
        mainView.addSubview(addView)
        mainView.addSubview(folderTableVeiw)
        searchView.addSubview(searchTableView)
    }
    override func configureLayout() {
        print(#function)
       
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        } 
        mainView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
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
        searchView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        searchTableView.snp.makeConstraints { make in
            make.edges.equalTo(searchView.snp.edges)
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
        mainView.backgroundColor = .secondarySystemBackground
        mainView.isHidden = false
        searchView.isHidden = true
        searchView.backgroundColor = .red
        searchTableView.backgroundColor = .blue
        
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
    
    func bindData() {
        viewModel.outputTodoList.bind { value in
            self.mainCollectionView.reloadData()
           
        }
        viewModel.outputFolderList.bind { value in
            self.folderTableVeiw.reloadData()
        }
        viewModel.outputSearchBarTextValid.bind { value in
            print("outputSearchBarTextValid.bind")
            if value {
                self.mainView.isHidden = true
                self.searchView.isHidden = false
            } else {
                self.mainView.isHidden = false
                self.searchView.isHidden = true
            }
        }
        viewModel.outputSearchList.bind { value in
            self.searchList = value
            self.searchTableView.reloadData()
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    // 실시간 검색
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.inputSearchBarText.value = searchBar.text
        
    }
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
        cell.countLabel.text = "\(categoryType.getfilteredList(list: viewModel.outputTodoList.value).count)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function,"\(indexPath)")
        let vc = ListViewController()
        let category = category[indexPath.row]
        vc.category = category
//        vc.listTitleLabel.text = category.rawValue
//        vc.list = Array(category.getfilteredList(list: todoList))
        vc.resultsList = viewModel.outputTodoList.value
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == folderTableVeiw {
            return viewModel.outputFolderList.value?.count ?? <#default value#>
        } else if tableView == searchTableView {
            guard let searchList = searchList else { return 0 }
            return searchList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == folderTableVeiw {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.id, for: indexPath) as? FolderTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = viewModel.outputFolderList.value?[indexPath.row].name
            cell.countLabel.text = "(\(String(describing: viewModel.outputFolderList.value?[indexPath.row].detail.count)))"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
            guard let searchList = searchList else { return cell }
            cell.titleLabel.text = searchList[indexPath.row].title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FolderedListViewController()
        vc.folder = viewModel.outputFolderList.value?[indexPath.row]
        vc.listTitleLabel.text = folderList[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
}

