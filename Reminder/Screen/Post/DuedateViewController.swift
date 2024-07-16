//
//  DuedateViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/3/24.
//

import UIKit

class DuedateViewController: BaseViewController {
    deinit {
        print("===============DuedateViewController deinit===============")
    }
   
    let datePicker = UIDatePicker()
//    var getDate: ((Date) -> Void)?
    
    let dateLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.textAlignment = .center
        
        return view
    }()
    
    let viewModel = DuedateViewModel()
  
    override func configureHierarchy() {
        view.addSubview(datePicker)
        view.addSubview(dateLabel)
    }
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(datePicker.snp.width)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(8)
            make.trailing.equalTo(datePicker.snp.trailing)
            make.height.equalTo(44)
            make.width.equalTo(160)
        }
    }
    override func configureView() {
        view.backgroundColor = .secondarySystemBackground
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .systemBackground
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 10
        datePicker.addTarget(self, action: #selector(pickDate), for: .valueChanged)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = backButton
        bindData()
    }
    
    @objc func pickDate(sender: UIDatePicker){
        print(#function)
        print(sender.date)
        viewModel.inputDate.value = sender.date
    }
    @objc func backButtonClicked() {
        print(#function)
//        getDate?(viewModel.outputDate.value ?? Date())
        viewModel.inputBackButtonClicked.value = ()
        navigationController?.popViewController(animated: true)
    }
    func bindData() {
        viewModel.outputDate.bind { [weak self] value in
            guard let value = value else { return }
            self?.dateLabel.text = value.dateToString()
        }
    }
    
    
}


#if DEBUG
@available (iOS 17, *)
#Preview {
    DuedateViewController()
}
#endif
