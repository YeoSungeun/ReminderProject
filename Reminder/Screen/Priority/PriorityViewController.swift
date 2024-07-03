//
//  PriorityViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/3/24.
//

import UIKit
import SnapKit

final class PriorityViewController: BaseViewController {
    lazy var segmentControl = {
        let segment = UISegmentedControl()
        for i in 0...(Priority.allCases.count - 1) {
            segment.insertSegment(withTitle: Priority.allCases[i].rawValue, at: i, animated: true)
        }
       
        segment.selectedSegmentIndex = 3
        segment.backgroundColor = .systemBackground
        segment.tintColor = .secondarySystemBackground
        segment.addTarget(self, action: #selector(segconChanged(segment:)), for: .valueChanged)
  
        return segment
    }()
    var getPriority: ((Priority) -> Void)?
    var priority: Priority = .none
    
    override func configureHierarchy() {
        view.addSubview(segmentControl)
    }
    override func configureLayout() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(120)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    override func configureView() {
        view.backgroundColor = .secondarySystemBackground
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func backButtonClicked() {
        print(#function)
        getPriority?(priority)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func segconChanged(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            priority = .upper
        case 1:
            priority = .middle
        case 2:
            priority = .lower
        case 3:
            priority = .none
        default:
            print("default")
        }
    }
}

#if DEBUG
@available (iOS 17, *)
#Preview {
    PriorityViewController()
}
#endif
