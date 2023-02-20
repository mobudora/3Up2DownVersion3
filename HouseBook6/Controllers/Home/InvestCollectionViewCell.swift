//
//  InvestCollectionViewCell.swift
//  HouseBook6
//
//  Created by ドラ on 2023/01/30.
//

import UIKit

class InvestCollectionViewCell: UICollectionViewCell {

    let colors = Colors()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseCollectionViewSetUp()
    }

    func baseCollectionViewSetUp() {
        backgroundColor = colors.white
        layer.cornerRadius = 10
        //shadowOffset = CGSize(width: 大きければ大きほど右に動く, height: 大きければ大きいほど下に動く)
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.borderWidth = 1
        layer.borderColor = colors.black.cgColor
        self.anchor(width: UIScreen.main.bounds.width - 20, height: 120)
    }
}
