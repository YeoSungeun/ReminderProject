//
//  DuedateViewController.swift
//  Reminder
//
//  Created by 여성은 on 7/3/24.
//

import UIKit

class DuedateViewController: BaseViewController {
    let datePicker = UIDatePicker()
    var getDate: ((String) -> Void)?
    var date = ""
    
    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(datePicker.snp.width)
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
    }
    @objc func pickDate(sender: UIDatePicker){
        print(#function)
        print(sender.date)
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko")
        dateformatter.dateFormat = "yyyy.MM.dd (EE)"  // 변환할 형식
        let dateString = dateformatter.string(from: sender.date)
        date = dateString
    }
    @objc func backButtonClicked() {
        print(#function)
        print(date)
        getDate?(date)
        navigationController?.popViewController(animated: true)
    }
    
    
}


#if DEBUG
@available (iOS 17, *)
#Preview {
    DuedateViewController()
}
#endif
