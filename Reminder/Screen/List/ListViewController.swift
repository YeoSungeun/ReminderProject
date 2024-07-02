//
//  ListViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/2/24.
//

import UIKit
import SnapKit

final class ListViewController: BaseViewController {
    
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
    
    var list: [(String, String?, String?, String?, Bool)] = [] {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = [("키보드구매","예쁜 키캡 알아보기","2022.02.23","#어쩌구", false),("키보드구매", nil,"2022.02.23","#어쩌구", false),("키보드구매","예쁜 키캡 알아보기",nil,"#어쩌구", false),("키보드구매","예쁜 키캡 알아보기",nil, nil, true)]
    }
    
    override func configureHierarchy() {
        view.addSubview(listTitleLabel)
        view.addSubview(tableView)
        view.addSubview(noneListLabel)
    }
    override func configureLayout() {
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
        super.configureView()
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
    }
    @objc func rightBarButtonItemClicked() {
        print(#function)
    }
    @objc func radioButtonClicked(sender: UIButton) {
        list[sender.tag].4.toggle()
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        let data = list[indexPath.row]
        cell.titleLabel.text = data.0
        cell.memoLabel.text = data.1
        cell.dueDateLabel.text = data.2
        cell.tagLabel.text = data.3
        cell.radioButton.tag = indexPath.row
        if data.4 {
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
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
