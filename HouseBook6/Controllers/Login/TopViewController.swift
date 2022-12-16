//
//  TopViewController.swift
//  HouseBook
//
//  Created by Dora on 2022/03/29.
//

import UIKit

class TopViewController: UIViewController {
    
    @IBOutlet weak var goFirstLoginButton: UIButton!
    @IBOutlet weak var goAlreadyLoginButton: UIButton!
    
    private let userDefaults = UserDefaults.standard
    private let appTrackingTransparencyModle = AppTrackingTransparencyModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiAlertAction()
        self.setupView()
    }
    
    private func setupView() {
        self.goAlreadyLoginButton.layer.borderWidth = 1
        self.goAlreadyLoginButton.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.9)
        
        self.setupButtonStyle(goFirstLoginButton)
        self.setupButtonStyle(goAlreadyLoginButton)
    }
    
    private func setupButtonStyle(_ button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        //影のぼかしの強さ
        button.layer.shadowRadius = 4
        //widthが大きいと右にheightは下に影が伸びる
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func uiAlertAction() {
        //初期表示のアラート
        if userDefaults.string(forKey: "AttCountUp") == "表示したよ" { return }
        //アラートのタイトル
        let dialog = UIAlertController(title: "広告に関するご質問", message: "初回のみ広告に関してご確認いただきます。", preferredStyle: .alert)
        //実際に表示させる
        self.present(dialog, animated: true)
        userDefaults.set("表示したよ", forKey: "AttCountUp")
        //ボタンのタイトル
        dialog.addAction(UIKit.UIAlertAction(title: "次へ", style: .default, handler: { _ in
            self.appTrackingTransparencyModle.requestTracking()
        }))
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    @IBAction func goFirstLoginButton(_ sender: Any) {
        self.pushViewControllerOverNavigation("FirstLogin")
    }
    
    @IBAction func goAlreadyLoginButton(_ sender: Any) {
        self.pushViewControllerOverNavigation("AlreadyLogin")
    }
}
