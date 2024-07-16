//
//  PriorityViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/3/24.
//

import UIKit
import SnapKit

final class PriorityViewController: BaseViewController {
    deinit {
        print("===============PriorityViewController deinit===============")
    }
    lazy var segmentControl = {
        let segment = UISegmentedControl()
        for i in 0...(Priority.allCases.count - 1) {
            segment.insertSegment(withTitle: Priority.allCases[i].rawValue, at: i, animated: true)
        }
        segment.selectedSegmentIndex = 3
        segment.backgroundColor = .systemBackground
        segment.tintColor = .systemBackground
        segment.addTarget(self, action: #selector(segconChanged(segment:)), for: .valueChanged)
  
        return segment
    }()
    let priorityLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.textAlignment = .center
        
        return view
    }()
//    var getPriority: ((Priority) -> Void)?
    
    let viewModel = PriorityViewModel()
    
    override func configureHierarchy() {
        view.addSubview(segmentControl)
        view.addSubview(priorityLabel)
    }
    override func configureLayout() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(120)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.trailing.equalTo(segmentControl.snp.trailing)
            make.height.equalTo(44)
            make.width.equalTo(120)
        }
    }
    override func configureView() {
        view.backgroundColor = .secondarySystemBackground
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = backButton
        bindData()
    }
    @objc func backButtonClicked() {
        print(#function)
        viewModel.inputBackButtonClicked.value = ()
        
//        viewModel.fetchPriority?(viewModel.outputPriority.value)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func segconChanged(segment: UISegmentedControl) {
        viewModel.inputPriority.value = segment.selectedSegmentIndex
    }
    func bindData() {
        viewModel.outputPriority.bind { [weak self] value in
            self?.priorityLabel.backgroundColor = value.color
        }
    }
}

#if DEBUG
@available (iOS 17, *)
#Preview {
    PriorityViewController()
}
#endif
