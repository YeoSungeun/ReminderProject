//
//  ListViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ListViewController: UIViewController {
    
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
    
    var list: Results<Todo>! {
        didSet {
            if list.count == 0 {
                noneListLabel.isHidden = false
                tableView.isHidden = true
            } else {
                noneListLabel.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    
    let realm = try! Realm()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(Todo.self)
        print(realm.configuration.fileURL)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        view.addSubview(listTitleLabel)
        view.addSubview(tableView)
        view.addSubview(noneListLabel)
    }
    func configureLayout() {
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
    func configureView() {
        view.backgroundColor = .systemBackground
        listTitleLabel.text = "전체"
        tableView.backgroundColor = .systemBackground
        let leftBarItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(leftBarButtonItemClicked))
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItem = rightBarItem
       
        if list.count == 0 {
            noneListLabel.isHidden = false
            tableView.isHidden = true
        }
    }
    @objc func leftBarButtonItemClicked() {
        print(#function)
        let vc = PostViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.reloadTableView = {
            self.tableView.reloadData()
        }
        present(nav, animated: true)
    }
    @objc func rightBarButtonItemClicked() {
        print(#function)
        showSortActionSheet()
    }
    @objc func radioButtonClicked(sender: UIButton) {
        if list[sender.tag].isDone{
            //update관련
        } else {
            
        }
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }
    func showSortActionSheet() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        
        // 2. 버튼 만들기
        let basic = UIAlertAction(title: "기본", style: .default) { _ in
            self.list = self.realm.objects(Todo.self)
            self.tableView.reloadData()
        }
        let dueDate = UIAlertAction(title: "마감일", style: .default) { _ in
            self.list = self.realm.objects(Todo.self).sorted(byKeyPath: "duedate", ascending: true)
            self.tableView.reloadData()
        }
        let priority = UIAlertAction(title: "우선순위 높음", style: .default) { _ in
            self.list = self.realm.objects(Todo.self).where{
                $0.priority == .upper
            }
            self.tableView.reloadData()
        }

        alert.addAction(basic)
        alert.addAction(dueDate)
        alert.addAction(priority)
        
        present(alert, animated: true)
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.dueDateLabel.text = data.duedate
        if let tag = data.tag {
            cell.tagLabel.text = "#" + data.tag!
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
        //        cell.radioButton.addTarget(self, action: #selector(radioButtonClicked), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
