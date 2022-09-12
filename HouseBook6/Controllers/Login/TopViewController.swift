//
//  TopViewController.swift
//  HouseBook
//
//  Created by Dora on 2022/03/29.
//

import UIKit
import AppTrackingTransparency

class TopViewController: UIViewController {
    
    @IBOutlet weak var goFirstLoginButton: UIButton!
    @IBOutlet weak var goAlreadyLoginButton: UIButton!
    
    let userDefaluts = UserDefaults.standard
    let colors =  Colors()
    let topViewModel = TopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIAlertAction()
        goFirstLoginButtonSetUp()
        goAlreadyLoginButtonSetUp()
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    @IBAction func goFirstLoginButton(_ sender: Any) {
        topViewModel.goFirstLoginStoryBoard()
    }
    
    @IBAction func goAlreadyLoginButton(_ sender: Any) {
        goAlreadyLoginStoryBoard()
    }
    
//    private func goFirstLoginStoryBoard() {
//        let storyboard = UIStoryboard(name: "FirstLogin", bundle: nil)
//        let nextView = storyboard.instantiateViewController(withIdentifier: "FirstLoginViewController") as! FirstViewController
//        self.navigationController?.pushViewController(nextView, animated: true)
//    }
    
    private func goAlreadyLoginStoryBoard() {
        let storyboard = UIStoryboard(name: "AlreadyLogin", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "AlreadyLoginViewController") as! AlreadyLoginViewController
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    private func UIAlertAction() {
        //初期表示のアラート
        if userDefaluts.string(forKey: "AttCountUp") != "表示したよ" {
            //アラートのタイトル
            let dialog = UIAlertController(title: "広告に関するご質問", message: "初回のみ広告に関してご確認いただきます。", preferredStyle: .alert)
            userDefaluts.set("表示したよ", forKey: "AttCountUp")
            //実際に表示させる
            self.present(dialog, animated: true, completion: nil)
            //ボタンのタイトル
            dialog.addAction(UIKit.UIAlertAction(title: "次へ", style: .default, handler: {
                (action: UIAlertAction!) in

                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:
                        print("OK")
                    case .denied, .restricted, .notDetermined:
                        print("だめでした。")
                    @unknown default:
                        fatalError()
                    }
                })
            }))
        }
    }
    private func goFirstLoginButtonSetUp() {
        goFirstLoginButton.layer.cornerRadius = 5
        goFirstLoginButton.layer.shadowColor = UIColor.black.cgColor
        goFirstLoginButton.layer.shadowOpacity = 0.3
        //影のぼかしの強さ
        goFirstLoginButton.layer.shadowRadius = 4
        //widthが大きいと右にheightは下に影が伸びる
        goFirstLoginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    private func goAlreadyLoginButtonSetUp() {
        goAlreadyLoginButton.layer.cornerRadius = 5
        goAlreadyLoginButton.layer.shadowColor = UIColor.black.cgColor
        goAlreadyLoginButton.layer.shadowOpacity = 0.3
        goAlreadyLoginButton.layer.shadowRadius = 4
        goAlreadyLoginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        goAlreadyLoginButton.layer.borderWidth = 1
        goAlreadyLoginButton.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.9)
    }
}
