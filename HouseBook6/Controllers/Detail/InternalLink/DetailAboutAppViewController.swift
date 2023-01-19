//
//  DetailAboutAppViewController.swift
//  HouseBook6
//
//  Created by Ryu on 2022/05/31.
//

import UIKit

class DetailAboutAppViewController: UIViewController {

    @IBOutlet weak var imageBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpImageBackgroundView()
    }
    func setUpImageBackgroundView() {
        imageBackgroundView.layer.cornerRadius = 10
        imageBackgroundView.layer.shadowOffset = CGSize(width: 5, height: 5)
        imageBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        imageBackgroundView.layer.shadowOpacity = 0.6
        imageBackgroundView.layer.borderWidth = 0.1
        imageBackgroundView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.9)
    }
}
