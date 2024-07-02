//
//  Reusable.swift
//  Reminder
//
//  Created by 여성은 on 7/2/24.
//

import UIKit

protocol ReusableProtocol {
    static var id: String { get }
}

extension UIViewController: ReusableProtocol {
    static var id: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    static var id: String {
        return String(describing: self)
    }
}

