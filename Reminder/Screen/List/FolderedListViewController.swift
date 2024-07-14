//
//  FolderedListViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/9/24.
//

import UIKit
import SnapKit
import RealmSwift


final class FolderedListViewController: BaseViewController {
   
    var folder: Folder?
    
    let listTitleLabel = {
        let view = UILabel()
        view.textColor = .systemBlue
        view.font = .systemFont(ofSize: 30, weight: .heavy)
        view.textAlignment = .left
        return view
    }()
    lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        
        return view
    }()
    let noneListLabel = {
        let view = UILabel()
        view.textColor = .systemGray.withAlphaComponent(0.5)
        view.font = .boldSystemFont(ofSize: 14)
        view.text = "목록이 없습니다."
        return view
    }()
    
    var list: [Todo] = [] {
        didSet {
            print("didset")
            if list.count == 0 {
                noneListLabel.isHidden = false
                tableView.isHidden = true
            } else {
                noneListLabel.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    let repository = TodoRepository()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        if let folder = folder {
            let value = folder.detail
            let result = Array(value)
            list = result
        }
        listCountCondition()
        repository.checkVersion()
        
    }
    
    override func configureHierarchy() {
        print(#function)
        view.addSubview(listTitleLabel)
        view.addSubview(tableView)
        view.addSubview(noneListLabel)
    }
    override func configureLayout() {
        print(#function)
        listTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(listTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        noneListLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    override func configureView() {
        print(#function)
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        let backButton = UIBarButtonItem(title: "목록", image: UIImage(systemName: "chevron.left"), target: self, action: #selector(backButtonClicked))
        
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = rightBarItem
       
    }
    func listCountCondition() {
        print(#function)
//        list = repository.fetchAll()
        if list.count == 0 {
            noneListLabel.isHidden = false
            tableView.isHidden = true
        }
    }
    @objc func backButtonClicked() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    @objc func rightBarButtonItemClicked() {
        print(#function)
        showSortActionSheet()
    }
    @objc func radioButtonClicked(sender: UIButton) {
        let data = list[sender.tag]
        if data.isDone{
            //update관련
            repository.updateItem(value: ["id": data.id,
                                          "isDone": false])
        } else {
            repository.updateItem(value: ["id": data.id,
                                          "isDone": true])
        }
        tableView.reloadData()
    }
    // TODO: pull down button으로 변경하기 _ 정렬 기준 보완하기
    func showSortActionSheet() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        
        // 2. 버튼 만들기
        let basic = UIAlertAction(title: "기본", style: .default) { _ in
            self.list = Array(self.repository.fetchAll())
            self.tableView.reloadData()
        }
        let dueDate = UIAlertAction(title: "마감일", style: .default) { _ in
            self.list = Array(self.repository.fetchAll().sorted(byKeyPath: "duedate", ascending: true))
            self.tableView.reloadData()
        }
        let priority = UIAlertAction(title: "우선순위 높음", style: .default) { _ in
            self.list = Array(self.repository.fetchAll().where{
                $0.priority == .upper
            })
            self.tableView.reloadData()
        }

        alert.addAction(basic)
        alert.addAction(dueDate)
        alert.addAction(priority)
        
        present(alert, animated: true)
    }
    
}

extension FolderedListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        let data = list[indexPath.row]
        cell.titleLabel.text = data.title
        switch data.priority {
            case.upper:
                cell.priorityLabel.text = "!!!"
            case.middle:
                cell.priorityLabel.text = "!!"
            case.lower:
                cell.priorityLabel.text = "!"
            case .none:
                cell.priorityLabel.text = nil
        }
        cell.memoLabel.text = data.memo
        cell.dueDateLabel.text = data.duedate?.dateToString()
        if let tag = data.tag {
            cell.tagLabel.text = "#" + data.tag!
        } else {
            cell.tagLabel.text = nil
        }
        cell.radioButton.tag = indexPath.row
        if data.isDone {
            let image = UIImage(systemName: "circle.inset.filled")
            cell.radioButton.setImage( image, for: .normal)
            cell.titleLabel.textColor = .systemGray
        } else {
            let image = UIImage(systemName: "circle")
            cell.radioButton.setImage( image, for: .normal)
            cell.titleLabel.textColor = .black
        }
       cell.radioButton.addTarget(self, action: #selector(radioButtonClicked), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
            let id = self.list[indexPath.row].id
            guard let data = self.repository.fetchData(id: id) else { return }
            self.repository.deleteItem(data)
            guard let folder = self.folder else { return }
            self.list = self.repository.fetchFolderDetail(folder: folder)
            tableView.reloadData()
        }
        delete.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

