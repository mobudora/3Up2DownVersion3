//
//  PasswordViewController.swift
//  HouseBook
//
//  Created by Dora on 2022/03/29.
//

import UIKit
import Firebase
import PKHUD

class PasswordViewController: UIViewController {
    
    //セルの再利用を防ぐために、再利用した際にremoveFromSuperview()をするためにここに宣言しておく
    var passwordImageView: UIImageView = UIImageView()
    //戻るボタンを表示させるためのフラッグ
    var imageDisplayFlag: Bool = true
    
    //インスタンス化
    var userDefaults = UserDefaults.standard
    
    var recieveNumber: [Int] = []
    var numberBox: [Int] = []
    
    var movefromDetail: Bool = false
    var movefromPassword2times: Bool = false
    
    var countUp = 1
    //パスワードを格納するための配列
    var recievePasswordNumber: [String] = []
    
    var numbers = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        ["arrow.uturn.backward","0","delete.left"]
    ]
    //登録したユーザーをまとめたものをuserに代入
    var user: User?
    
    @IBOutlet weak var passwordSubTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    //数字を表示するラベル
    @IBOutlet weak var passwordNumberLabel1: UILabel!
    @IBOutlet weak var passwordNumberLabel2: UILabel!
    @IBOutlet weak var passwordNumberLabel3: UILabel!
    @IBOutlet weak var passwordNumberLabel4: UILabel!
    @IBOutlet weak var caluculatorCollectionView: UICollectionView!
    @IBOutlet weak var caluculatorHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelSetUp()
        //navgationのタイトルを""にして、Backボタンを空白にする
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
        caluculatorCollectionView.delegate = self
        caluculatorCollectionView.dataSource = self
        caluculatorCollectionView.register(PasswordViewCell.self, forCellWithReuseIdentifier: "cellId")
        caluculatorHeightConstraints.constant = CGFloat(UIScreen.main.bounds.height / 2 - 30)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        confirmLoggedInUser()
    }
    
    //ログインしている状態か初期登録状態か判断する
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser == nil {
            print("🟩とおたよ")
            let storyBoard = UIStoryboard(name: "FirstLogin", bundle: nil)
            let firstLoginViewController = storyBoard.instantiateViewController(withIdentifier: "FirstLoginViewController") as! UINavigationController
            firstLoginViewController.modalPresentationStyle = .fullScreen
            self.present(firstLoginViewController, animated: true, completion: nil)
        } else {
            
            if let uid = Auth.auth().currentUser?.uid {
                Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
                    if let err = err {
                        print("Firestoreからの読み取りに失敗しました\(err)")
                        return
                    }
                    guard let dic = snapshot?.data() else { return }
                    let userInfo = User.init(dic: dic)
                    
                    Auth.auth().signIn(withEmail: userInfo.email, password: userInfo.password) { (res, err) in
                        if let err = err {
                            print("ログイン情報の取得に失敗しました。", err)
                            HUD.hide { (_) in
                                HUD.flash(.error, delay: 1)
                            }
                            return
                        }
                        print("ログインに成功しました。")
                    }
                }
            } else {
                print("🟩uidがないよ")
            }
        }
    }
    
    private func labelSetUp() {
        if movefromDetail == true {
            passwordTitleLabel.text = "新しいパスコード入力"
            passwordSubTitleLabel.text = "起動時に使用する\n新しいパスコードを4つ入力"
        } else if movefromPassword2times == true {
            passwordTitleLabel.text = "新しいパスコード再入力"
            passwordSubTitleLabel.text = "確認のためにもう一度入力してください"
        } else {
            //戻るボタンを非表示に
            numbers[3].remove(at: 0)
            numbers[3].insert("", at: 0)
        }
        
        self.passwordNumberLabel1.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        self.passwordNumberLabel1.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        self.passwordNumberLabel1.layer.cornerRadius = UIScreen.main.bounds.width / 8
        self.passwordNumberLabel1.clipsToBounds = true
        self.passwordNumberLabel1.layer.borderWidth = 1.0
        self.passwordNumberLabel1.layer.borderColor = UIColor.black.cgColor
        
        self.passwordNumberLabel2.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        self.passwordNumberLabel2.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        self.passwordNumberLabel2.layer.cornerRadius = UIScreen.main.bounds.width / 8
        self.passwordNumberLabel2.clipsToBounds = true
        self.passwordNumberLabel2.layer.borderWidth = 1.0
        self.passwordNumberLabel2.layer.borderColor = UIColor.black.cgColor
        
        self.passwordNumberLabel3.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        self.passwordNumberLabel3.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        self.passwordNumberLabel3.layer.cornerRadius = UIScreen.main.bounds.width / 8
        self.passwordNumberLabel3.clipsToBounds = true
        self.passwordNumberLabel3.layer.borderWidth = 1.0
        self.passwordNumberLabel3.layer.borderColor = UIColor.black.cgColor
        
        self.passwordNumberLabel4.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        self.passwordNumberLabel4.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        self.passwordNumberLabel4.layer.cornerRadius = UIScreen.main.bounds.width / 8
        self.passwordNumberLabel4.clipsToBounds = true
        self.passwordNumberLabel4.layer.borderWidth = 1.0
        self.passwordNumberLabel4.layer.borderColor = UIColor.black.cgColor
    }
}
extension PasswordViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    //セルの行の値を表示する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    //コレクションビューのヘッダーを表示しない
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //横のマージン10*2個の横マージンがある
        let width = (collectionView.frame.width - 3 * 10) / 3
        let height = collectionView.frame.height / 4
        return .init(width: width, height:  height)
    }
    //横のマージンの設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //縦方向のマージンの設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //cellの情報を変えることができる
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = caluculatorCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PasswordViewCell
        if numbers[indexPath.section][indexPath.row] == "delete.left" || numbers[indexPath.section][indexPath.row] == "arrow.uturn.backward" {
            let image = UIImage(systemName: numbers[indexPath.section][indexPath.row])
            passwordImageView = UIImageView(image: image)
            passwordImageView.frame.size = cell.sizeThatFits(CGSize(width: cell.frame.size.width / 2, height: cell.frame.size.height / 2))
            passwordImageView.center = CGPoint(x: cell.frame.size.width / 2, y: cell.frame.size.height / 2)
            passwordImageView.tintColor = .white
            cell.numberLabel.isHidden = true
            cell.addSubview(passwordImageView)
            
            //表示しないときのコードも書かないとcellの再利用で以前の記憶のまま表示されてしまう
            cell.numberLabel.text = ""
            //arrow.uturn.backwardは表示させたいから、removeFromSuperview()をさせないためにフラッグを使ってコードを読み込ませないようにする(一時的)
            if numbers[indexPath.section][indexPath.row] == "arrow.uturn.backward" {
                imageDisplayFlag = false
            }
        } else {
            //表示しないときのコードも書かないとcellの再利用で以前の記憶のまま表示されてしまう
            cell.numberLabel.isHidden = false
            if imageDisplayFlag != false {
                passwordImageView.removeFromSuperview()
            }
            
            cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        }
        
        return cell
    }
    //クリックしたものを認識させる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedNumber = numbers[indexPath.section][indexPath.row]
        //MARK: パスワード設定画面を表示
        if movefromDetail == true || movefromPassword2times == true {
            passwordForSetting(clickedNumber: clickedNumber)
        } else { //MARK: 初回起動時の初期画面
            launchDisplayPasswordController(clickedNumber: clickedNumber, collectionView: collectionView)
        }
        
    }
    
    func launchDisplayPasswordController(clickedNumber: String, collectionView: UICollectionView) {
        switch clickedNumber {
        case "0"..."9":
            if passwordNumberLabel1.text == "" {
                passwordNumberLabel1.text = clickedNumber
                numberBox.append(Int(clickedNumber) ?? 0)
            } else if passwordNumberLabel2.text == "" {
                passwordNumberLabel2.text = clickedNumber
                numberBox.append(Int(clickedNumber) ?? 0)
            } else if passwordNumberLabel3.text == "" {
                passwordNumberLabel3.text = clickedNumber
                numberBox.append(Int(clickedNumber) ?? 0)
            } else if passwordNumberLabel4.text == "" {
                passwordNumberLabel4.text = clickedNumber
                numberBox.append(Int(clickedNumber) ?? 0)
                //入力された数字とUserDefalutsに保存されている配列が同じか確認する
                let passwordNumber = userDefaults.array(forKey: "passwordNumber") as? [Int] ?? [Int]()
                
                if passwordNumber == numberBox {
                    print("🟩🟩🟩")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextVc = storyboard.instantiateViewController(withIdentifier: "MainStoryboard") as! UITabBarController
                    self.present(nextVc, animated: true, completion: nil)
                } else {
                    resetPasswordNumber()
                    passwordTitleLabel.text = "パスコードが違います"
                    passwordSubTitleLabel.text = "起動時に使用する\n4つのパスコードを入力してください"
                    //戻るボタンを表示
                    numbers[3].remove(at: 0)
                    numbers[3].insert("arrow.uturn.backward", at: 0)
                    //初回で間違えた時だけリロードしてuturnのアイコンを表示させるから、フラッグはfalseのままにしてリロードさせないでおく
                    if imageDisplayFlag == true {
                        collectionView.reloadData()
                    }
                }
            }
        case "delete.left":
            resetPasswordNumber()
        case "arrow.uturn.backward":
            let storyboard = UIStoryboard(name: "Top", bundle: nil)
            let nextVc = storyboard.instantiateViewController(withIdentifier: "NavgationTopStoryboard") as! TopViewController
            nextVc.modalPresentationStyle = .fullScreen
            self.present(nextVc, animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    func passwordForSetting(clickedNumber: String) {
        print(clickedNumber)
        switch clickedNumber {
        case "0"..."9":
            if passwordNumberLabel1.text == "" {
                passwordNumberLabel1.text = clickedNumber
                numberBox.append(Int(clickedNumber) ?? 0)
            } else if passwordNumberLabel2.text == "" {
                passwordNumberLabel2.text = clickedNumber
                numberBox.append(Int(clickedNumber) ?? 0)
            } else if passwordNumberLabel3.text == "" {
                passwordNumberLabel3.text = clickedNumber
                numberBox.append(Int(clickedNumber) ?? 0)
            } else if passwordNumberLabel4.text == "" {
                passwordNumberLabel4.text = clickedNumber
                numberBox.append(Int(clickedNumber) ?? 0)
                print("🔶recieveNumber\(recieveNumber)")
                if recieveNumber == numberBox {
                    userDefaults.set(recieveNumber, forKey: "passwordNumber")
                    HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                        let index = self.navigationController!.viewControllers.count - 3
                        self.navigationController?.popToViewController(self.navigationController!.viewControllers[index], animated: true)
                    }
                } else if recieveNumber != [] {
                    resetPasswordNumber()
                } else {
                    let storyboard = UIStoryboard(name: "Password", bundle: nil)
                    let nextVc = storyboard.instantiateViewController(withIdentifier: "PasswordStoryboard") as! PasswordViewController
                    nextVc.movefromPassword2times = true
                    nextVc.recieveNumber = numberBox
                    resetPasswordNumber()
                    self.navigationController?.pushViewController(nextVc, animated: true)
                }
            }
        case "delete.left":
            resetPasswordNumber()
        case "arrow.uturn.backward":
            resetPasswordNumber()
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    //ラベルとタップされた数字配列をリセットする関数
    private func resetPasswordNumber() {
        passwordNumberLabel1.text = ""
        passwordNumberLabel2.text = ""
        passwordNumberLabel3.text = ""
        passwordNumberLabel4.text = ""
        numberBox = []
    }
}
class PasswordViewCell: UICollectionViewCell {
    
    //押した時に薄くなる
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.numberLabel.backgroundColor = .rgb(red: 240, green: 240, blue: 240, alpha: 0.5)
            } else {
                self.numberLabel.backgroundColor = .rgb(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    //cellのnumberLabel
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        label.text = "1"
        label.font = .boldSystemFont(ofSize: 32)
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numberLabel)
        numberLabel.frame.size = self.frame.size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
