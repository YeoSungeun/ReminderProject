//
//  MainCollectionViewCell.swift
//  Reminder
//
//  Created by 여성은 on 7/4/24.
//

import UIKit

class MainCollectionViewCell: BaseCollectionViewCell {
    override func configureView() {
        contentView.backgroundColor = .red
    }
}
#if DEBUG
@available (iOS 17, *)
#Preview {
    MainCollectionViewCell()
}
#endif
