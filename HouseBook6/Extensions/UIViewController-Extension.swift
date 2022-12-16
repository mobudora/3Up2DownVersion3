//
//  UIViewController-Extension.swift
//  HouseBook6
//
//  Created by ドラ on 2022/09/27.
//

import Foundation
import UIKit

extension UIViewController {
    func pushViewControllerOverNavigation<T: UIViewController>(_ storyboard: String, _ additionalOperation: ((T) -> ())? = nil) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController()
        if let nextVC = nextVC as? T {
            additionalOperation?(nextVC)
        }
        navigationController?.pushViewController(nextVC!, animated: true)
    }
}
