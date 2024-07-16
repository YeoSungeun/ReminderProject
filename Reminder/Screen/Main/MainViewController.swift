//
//  MainViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/4/24.
//

import UIKit
//import RealmSwift

final class MainViewController: BaseViewController {
    
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
    // TODO: 해결하기
//    var searchList: Results<Todo>!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppearTrigger.value = ()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        viewModel.inputViewDidLoadTrigger.value = ()

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
        viewModel.outputViewWillAppearTrigger.bind { _ in
            self.mainCollectionView.reloadData()
            self.folderTableVeiw.reloadData()
        }
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
        viewModel.outputSearchList.bind(closure: { value in
            self.searchTableView.reloadData()
        }) 
        
        viewModel.outputFolderTVCellIndexPath.bindLater { value in
            let vc = FolderedListViewController()
            vc.folder = self.viewModel.outputFolderData.value
            vc.listTitleLabel.text = self.viewModel.outputFolderData.value?.name
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    // 실시간 검색
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.inputSearchTrigger.value = ()
        viewModel.inputSearchBarText.value = searchBar.text
        
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.todoCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function,indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell()}
        
        // TODO: 여기 뷰모델로~
        let categoryType = viewModel.todoCategory[indexPath.item]
        cell.categoryImageView.image = categoryType.image
        cell.categoryImageView.tintColor = categoryType.backgroundColor
        cell.categoryTitle.text = categoryType.rawValue
        cell.countLabel.text = "\(categoryType.getfilteredList(list: viewModel.outputTodoList.value).count)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function,"\(indexPath)")
        let vc = ListViewController()
        let category = viewModel.todoCategory[indexPath.row]
        vc.category = category
        vc.resultsList = viewModel.outputTodoList.value
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == folderTableVeiw {
            return viewModel.outputFolderList.value?.count ?? 0
        } else if tableView == searchTableView {
            return viewModel.outputTodoList.value?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == folderTableVeiw {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.id, for: indexPath) as? FolderTableViewCell else { return UITableViewCell() }
            guard let value = viewModel.outputFolderList.value else { return cell }
            let data = value[indexPath.row]
            cell.configureCell(data: data)
            return cell
        } else if tableView == searchTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
//            guard let searchList = viewModel.outputSearchList.value else {
//                print("여기..?")
//                return cell
//            }
            print("여기아래")
            print(viewModel.outputSearchList.value)
            // TODO: 여기다시봐!!다시!!다ㅣㅅ~~~
            if indexPath.row < viewModel.outputSearchList.value?.count ?? 0 {
                guard let data = viewModel.outputSearchList.value?[indexPath.row] else {
                    print("여기아래아래")
                    return cell}
                cell.configureCell(data: data)
                return cell
            }
//            guard let data = viewModel.outputSearchList.value?[indexPath.row] else {
//                print("여기아래아래")
//                return cell}
//            cell.configureCell(data: data)
//            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == folderTableVeiw {
            viewModel.inputFolderTVCellIndexPath.value = indexPath.row
        } else if tableView == searchTableView {
            
        }
    }
}

