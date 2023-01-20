//
//  PasswordViewController.swift
//  HouseBook
//
//  Created by Dora on 2022/03/29.
//

import UIKit
import Firebase

class PasswordViewController: UIViewController {
    
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
        self.passwordNumberLabel1.layer.borderWidth = 1.0
        self.passwordNumberLabel1.layer.borderColor = UIColor.black.cgColor
        self.passwordNumberLabel2.layer.borderWidth = 1.0
        self.passwordNumberLabel2.layer.borderColor = UIColor.black.cgColor
        self.passwordNumberLabel3.layer.borderWidth = 1.0
        self.passwordNumberLabel3.layer.borderColor = UIColor.black.cgColor
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
            switch countUp {
            case 2:
                passwordNumberLabel2.text = clickedNumber
            case 3:
                passwordNumberLabel3.text = clickedNumber
            case 4:
                passwordNumberLabel4.text = clickedNumber
                let storyboard = UIStoryboard(name: "Password", bundle: nil)
                let nextVc = storyboard.instantiateViewController(withIdentifier: "PasswordStoryboard") as! PasswordViewController
                self.present(nextVc, animated: true, completion: nil)
            default:
                passwordNumberLabel1.text = clickedNumber
            }
            countUp += 1
        case "delete.left":
            passwordNumberLabel1.text = ""
            passwordNumberLabel2.text = ""
            passwordNumberLabel3.text = ""
            passwordNumberLabel4.text = ""
        default:
            break
        }
    }
}
class PasswordViewCell: UICollectionViewCell {
    
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
