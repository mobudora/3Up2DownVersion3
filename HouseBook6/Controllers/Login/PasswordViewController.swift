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
    
    var recieveNumber: [Int] = []
    var numberBox: [Int] = []
    
    var movefromDetail: Bool = false
    var movefromPassword2times: Bool = false
    
    var countUp = 1
    //パスワードを格納するための配列
    var recievePasswordNumber: [String] = []
    
    let numbers = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        ["arrow.uturn.backward","0","delete.left"],
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        confirmLoggedInUser()
    }
    
    //ログインしている状態か初期登録状態か判断する
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil || user == nil {
            presentToFirstLoginViewController()
        }
    }
    
    private func presentToFirstLoginViewController() {
        let storyBoard = UIStoryboard(name: "FirstLogin", bundle: nil)
        let firstLoginViewController = storyBoard.instantiateViewController(withIdentifier: "FirstLoginViewController") as! UINavigationController
        firstLoginViewController.modalPresentationStyle = .fullScreen
        self.present(firstLoginViewController, animated: true, completion: nil)
    }
    
    private func labelSetUp() {
        if movefromDetail == true {
            passwordTitleLabel.text = "新しいパスコード入力"
            passwordSubTitleLabel.text = "起動時に使用する\n新しいパスコードを4つ入力"
        } else if movefromPassword2times == true {
            passwordTitleLabel.text = "新しいパスコード再入力"
            passwordSubTitleLabel.text = "確認のためにもう一度入力してください"
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
        let width = (collectionView.frame.width - 2 * 10) / 3
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
            let deleteImage = UIImage(systemName: numbers[indexPath.section][indexPath.row])
            let deleteImageView = UIImageView(image: deleteImage)
            deleteImageView.frame.size = cell.sizeThatFits(CGSize(width: cell.frame.size.width / 2, height: cell.frame.size.height / 2))
            deleteImageView.center = CGPoint(x: cell.frame.size.width / 2, y: cell.frame.size.height / 2)
            deleteImageView.tintColor = .white
            cell.numberLabel.isHidden = true
            cell.addSubview(deleteImageView)
        } else {
            cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        }
        
        return cell
    }
    //クリックしたものを認識させる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedNumber = numbers[indexPath.section][indexPath.row]
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
                    HUD.flash(.success, onView: self.view, delay: 1)
                    let index = navigationController!.viewControllers.count - 3
                    navigationController?.popToViewController(navigationController!.viewControllers[index], animated: true)
                } else if recieveNumber != [] {
                    passwordNumberLabel1.text = ""
                    passwordNumberLabel2.text = ""
                    passwordNumberLabel3.text = ""
                    passwordNumberLabel4.text = ""
                    numberBox = []
                } else {
                    let storyboard = UIStoryboard(name: "Password", bundle: nil)
                    let nextVc = storyboard.instantiateViewController(withIdentifier: "PasswordStoryboard") as! PasswordViewController
                    nextVc.movefromPassword2times = true
                    nextVc.recieveNumber = numberBox
                    passwordNumberLabel1.text = ""
                    passwordNumberLabel2.text = ""
                    passwordNumberLabel3.text = ""
                    passwordNumberLabel4.text = ""
                    numberBox = []
                    self.navigationController?.pushViewController(nextVc, animated: true)
                }
            }
        case "delete.left":
            passwordNumberLabel1.text = ""
            passwordNumberLabel2.text = ""
            passwordNumberLabel3.text = ""
            passwordNumberLabel4.text = ""
        case "arrow.uturn.backward":
            passwordNumberLabel1.text = ""
            passwordNumberLabel2.text = ""
            passwordNumberLabel3.text = ""
            passwordNumberLabel4.text = ""
            numberBox = []
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
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
