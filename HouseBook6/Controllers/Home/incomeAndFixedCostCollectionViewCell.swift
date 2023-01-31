//
//  incomeAndFixedCostCollectionViewCell.swift
//  HouseBook
//
//  Created by Dora on 2022/03/29.
//

import UIKit
import Firebase
import PKHUD

class incomeAndFixedCostCollectionViewCell: UICollectionViewCell {
    
    // FirestoreのDB取得
    let db = Firestore.firestore()
    
    //今のホーム画面のタイトル月
    var currentHomeTitleMonth: Int?
    var currentHomeTitleYear: Int?
    
    let calendarViewController = CalendarViewController.calendarViewControllerInstance
    
    //HomeViewの生活費(収入ー固定費)のテキストを更新するためのプロトコル
    var homeLivingExpensesUpdateDelegate: IncomeAndFixedToHomeProtocol?
    var incomeSumText: String!
    var fixedCostSumText: String!
    
    //InputViewControllerへ移動するためのプロトコル
    var delegate: PassIncomeAndFixedCollectionCellProtocol!
    //±を行うプロトコル
    var plusMinusDelegate: PlusMinusProtocol?
    //incomeテーブルのcell数
    var incomeTableCellRowCount = 0
    //Fixedテーブルのcell数
    var fixedCostTableCellRowCount = 0
    //収入コレクションを格納するデータ配列
    var incomeCollectionCellTitle: [String] = []
    var incomeCollectionCellImage: [UIImage] = []
    var incomeCollectionCellMoney: [Int] = []
    //収入のサブカテゴリー配列を格納するデータ配列
    var salaryIncomeSubCategoryArray: [String] = []
    var sideBusinessIncomeSubCategoryArray: [String] = []
    var extraordinaryIncomeSubCategoryArray: [String] = []
    var investmentIncomeSubCategoryArray: [String] = []
    var prizeIncomeSubCategoryArray: [String] = []
    //固定費コレクションを格納するデータ配列
    var fixedCostCollectionCellTitle: [String] = []
    var fixedCostCollectionCellImage: [UIImage] = []
    var fixedCostCollectionCellMoney: [Int] = []
    //固定費のサブカテゴリー配列を格納するデータ配列
    var foodFixedCostSubCategoryArray: [String] = []
    var dailyGoodsFixedCostSubCategoryArray: [String] = []
    var clothFixedCostSubCategoryArray: [String] = []
    var healthFixedCostSubCategoryArray: [String] = []
    var datingFixedCostSubCategoryArray: [String] = []
    var hobbiesFixedCostSubCategoryArray: [String] = []
    var liberalArtsFixedCostSubCategoryArray: [String] = []
    var transportationFixedCostSubCategoryArray: [String] = []
    var cosmetologyFixedCostSubCategoryArray: [String] = []
    var sightseeingFixedCostSubCategoryArray: [String] = []
    var carFixedCostSubCategoryArray: [String] = []
    var motorcycleFixedCostSubCategoryArray: [String] = []
    var netWorkFixedCostSubCategoryArray: [String] = []
    var waterFixedCostSubCategoryArray: [String] = []
    var gasFixedCostSubCategoryArray: [String] = []
    var electricityFixedCostSubCategoryArray: [String] = []
    var insuranceFixedCostSubCategoryArray: [String] = []
    var taxFixedCostSubCategoryArray: [String] = []
    var housingFixedCostSubCategoryArray: [String] = []
    var medicalFixedCostSubCategoryArray: [String] = []
    var petFixedCostSubCategoryArray: [String] = []
    
    static var incomeAndFixedCollectionInstance = incomeAndFixedCostCollectionViewCell()
    var incomeAndFixedIconNameReciever: String!
    var incomeAndFIxedIconMoneyReciever: String!
    
    //収入と固定費の数
    let tableCountUp = 3
    
    let colors = Colors()
    
    //収入・固定費コレクションのタイトル
    @IBOutlet weak var incomeLabel: UILabel!
    //storyboardにTableViewを載せる
    @IBOutlet weak var incomeTableView: UITableView!
    //TableView自体の高さ
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    //TableViewのセルの高さ
    let tableViewCellHeight: CGFloat = 44
    //総合計のテキスト
    @IBOutlet weak var incomeSumMoneyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //現在の年月を取得
        calendarViewController.currentMonth.dateFormat = "MM"
        calendarViewController.currentYear.dateFormat = "yyyy"
        
        currentHomeTitleMonth = Int(calendarViewController.currentMonth.string(from: calendarViewController.currentDate)) ?? 0
        currentHomeTitleYear = Int(calendarViewController.currentYear.string(from: calendarViewController.currentDate)) ?? 0
        
        print("最初のTableViewのデータ取得行います。")
        getIncomeCollectionDataFromFirestore()
        //コレクションビューのデザイン
        baseCollectionViewSetUp()
        //TableViewの準備
        incomeTableView.dataSource = self
        incomeTableView.delegate = self
        //TableViewCellの登録
        //入力するところ
        incomeTableView.register(UINib(nibName: "incomeTableViewCell", bundle: nil), forCellReuseIdentifier: "incomeCustomCell")
        //入力する欄を増やしたり減らしたりするところ
        incomeTableView.register(UINib(nibName: "incomePlusMinusTableViewCell", bundle: nil), forCellReuseIdentifier: "incomeTableViewPlusMinusCustomCell")
        //初期設定では入力する欄2 + 増やしたり減らす欄1 = 3
        tableViewHeightConstraint.constant = CGFloat(Int(tableViewCellHeight) * 4)
    }
    
    func getIncomeCollectionDataFromFirestore() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let year = calendarViewController.currentYear.string(from: calendarViewController.currentDate)
        
        //incomeAndExpenditureコレクションを取得
        db.collection("\(year)superCategoryIncomeAndExpenditure").document(uid).getDocument { snapshot, err in
            // エラー発生時
            if let err = err {
                print("Firestoreからの収入SuperCategoryDataの取得に失敗しました: \(err)")
            } else {
                // コレクション内のドキュメントを取得
                guard let data = snapshot?.data() else { return }
                print("🟩収入と固定費に使うdata\(data)")
                //受け取った収入コレクション用に収入親カテゴリー情報の整理
                let incomeSuperCategory = IncomeFromFirestore.init(dic: data, month: self.currentHomeTitleMonth ?? 0)
                print("🔶self.currentHomeTitleMonth\(self.currentHomeTitleMonth)")
                //受け取った固定費コレクション用に固定費親カテゴリー情報の整理
                let fixedCostSuperCategory = FixedCostFromFirestore.init(dic: data, month: self.currentHomeTitleMonth ?? 0)
                
                print("🔷incomeSuperCategory\(incomeSuperCategory)")
                print("🔷fixedCostSuperCategory\(fixedCostSuperCategory)")
                
                //初期化
                self.incomeCollectionCellTitle = []
                self.incomeCollectionCellImage = []
                self.incomeCollectionCellMoney = []
                
                self.fixedCostCollectionCellTitle = []
                self.fixedCostCollectionCellImage = []
                self.fixedCostCollectionCellMoney = []
                
                print("🟥Firestoreから読み取った収入と固定費を配列に代入してHomeViewにも生活費を出すために渡す")
                //収入と固定費TableView用の情報を取得
                //給料の金額が入っていたら、タイトルに給料と金額を代入する
                if incomeSuperCategory.salaryMoneyFromFirestore != nil {
                    self.incomeCollectionViewSetUp(superCategory: "給料", sumIncomeMoneyFromFirestore: incomeSuperCategory.salaryMoneyFromFirestore, subCategoryIncomeArray: incomeSuperCategory.salaryIncomeSubCategoryArrayFromFirestore)
                }
                if incomeSuperCategory.sideBusinessMoneyFromFirestore != nil {
                    self.incomeCollectionViewSetUp(superCategory: "副業", sumIncomeMoneyFromFirestore: incomeSuperCategory.sideBusinessMoneyFromFirestore, subCategoryIncomeArray: incomeSuperCategory.sideBusinessIncomeSubCategoryArrayFromFirestore)
                }
                if incomeSuperCategory.extraordinaryMoneyFromFirestore != nil {
                    self.incomeCollectionViewSetUp(superCategory: "臨時収入", sumIncomeMoneyFromFirestore: incomeSuperCategory.extraordinaryMoneyFromFirestore, subCategoryIncomeArray: incomeSuperCategory.extraordinaryIncomeSubCategoryArrayFromFirestore)
                }
                if incomeSuperCategory.investmentMoneyFromFirestore != nil {
                    self.incomeCollectionViewSetUp(superCategory: "投資", sumIncomeMoneyFromFirestore: incomeSuperCategory.investmentMoneyFromFirestore, subCategoryIncomeArray: incomeSuperCategory.investmentIncomeSubCategoryArrayFromFirestore)
                }
                if incomeSuperCategory.prizeMoneyFromFirestore != nil {
                    self.incomeCollectionViewSetUp(superCategory: "賞", sumIncomeMoneyFromFirestore: incomeSuperCategory.prizeMoneyFromFirestore, subCategoryIncomeArray: incomeSuperCategory.prizeIncomeSubCategoryArrayFromFirestore)
                }
                
                //固定費のデータ取得
                // ???: if文がしつこい
                if let foodMoneyFromFirestore = fixedCostSuperCategory.foodMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "食費", sumIncomeMoneyFromFirestore: foodMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.foodFixedCostSubCategoryArrayFromFirestore)
                }
                if let dailyGoodsMoneyFromFirestore = fixedCostSuperCategory.dailyGoodsMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "日用品", sumIncomeMoneyFromFirestore: dailyGoodsMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.dailyGoodsFixedCostSubCategoryArrayFromFirestore)
                }
                if let clothMoneyFromFirestore = fixedCostSuperCategory.clothMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "服飾", sumIncomeMoneyFromFirestore: clothMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.clothFixedCostSubCategoryArrayFromFirestore)
                }
                if let healthMoneyFromFirestore = fixedCostSuperCategory.healthMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "健康", sumIncomeMoneyFromFirestore: healthMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.healthFixedCostSubCategoryArrayFromFirestore)
                }
                if let datingMoneyFromFirestore = fixedCostSuperCategory.datingMoneyFromFirestore { self.fixedCollectionViewSetUp(superCategory: "交際", sumIncomeMoneyFromFirestore: datingMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.datingFixedCostSubCategoryArrayFromFirestore)
                }
                if let hobbiesMoneyFromFirestore = fixedCostSuperCategory.hobbiesMoneyFromFirestore { self.fixedCollectionViewSetUp(superCategory: "趣味", sumIncomeMoneyFromFirestore: hobbiesMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.hobbiesFixedCostSubCategoryArrayFromFirestore)
                }
                if let liberalArtsMoneyFromFirestore = fixedCostSuperCategory.liberalArtsMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "教養", sumIncomeMoneyFromFirestore: liberalArtsMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.liberalArtsFixedCostSubCategoryArrayFromFirestore)
                }
                if let transportationMoneyFromFirestore = fixedCostSuperCategory.transportationMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "交通", sumIncomeMoneyFromFirestore: transportationMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.transportationFixedCostSubCategoryArrayFromFirestore)
                }
                if let cosmetologyMoneyFromFirestore = fixedCostSuperCategory.cosmetologyMoneyFromFirestore { self.fixedCollectionViewSetUp(superCategory: "美容", sumIncomeMoneyFromFirestore: cosmetologyMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.cosmetologyFixedCostSubCategoryArrayFromFirestore)
                }
                if let sightseeingMoneyFromFirestore =  fixedCostSuperCategory.sightseeingMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "観光", sumIncomeMoneyFromFirestore: sightseeingMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.sightseeingFixedCostSubCategoryArrayFromFirestore)
                }
                if let carMoneyFromFirestore = fixedCostSuperCategory.carMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "車", sumIncomeMoneyFromFirestore: carMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.carFixedCostSubCategoryArrayFromFirestore)
                }
                if let motorcycleMoneyFromFirestore = fixedCostSuperCategory.motorcycleMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "バイク", sumIncomeMoneyFromFirestore: motorcycleMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.motorcycleFixedCostSubCategoryArrayFromFirestore)
                }
                if let netWorkMoneyFromFirestore = fixedCostSuperCategory.netWorkMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "通信", sumIncomeMoneyFromFirestore: netWorkMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.netWorkFixedCostSubCategoryArrayFromFirestore)
                }
                if let waterMoneyFromFirestore = fixedCostSuperCategory.waterMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "水道代", sumIncomeMoneyFromFirestore: waterMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.waterFixedCostSubCategoryArrayFromFirestore)
                }
                if let gasMoneyFromFirestore = fixedCostSuperCategory.gasMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "ガス代", sumIncomeMoneyFromFirestore: gasMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.gasFixedCostSubCategoryArrayFromFirestore)
                }
                if let electricityMoneyFromFirestore = fixedCostSuperCategory.electricityMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "電気代", sumIncomeMoneyFromFirestore: electricityMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.electricityFixedCostSubCategoryArrayFromFirestore)
                }
                if let insuranceMoneyFromFirestore = fixedCostSuperCategory.insuranceMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "保険", sumIncomeMoneyFromFirestore: insuranceMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.insuranceFixedCostSubCategoryArrayFromFirestore)
                }
                if let taxMoneyFromFirestore = fixedCostSuperCategory.taxMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "税金", sumIncomeMoneyFromFirestore: taxMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.taxFixedCostSubCategoryArrayFromFirestore)
                }
                if let housingMoneyFromFirestore = fixedCostSuperCategory.housingMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "住宅", sumIncomeMoneyFromFirestore: housingMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.housingFixedCostSubCategoryArrayFromFirestore)
                }
                if let medicalMoneyFromFirestore = fixedCostSuperCategory.medicalMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "医療", sumIncomeMoneyFromFirestore: medicalMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.medicalFixedCostSubCategoryArrayFromFirestore)
                }
                if let petMoneyFromFirestore = fixedCostSuperCategory.petMoneyFromFirestore {
                    self.fixedCollectionViewSetUp(superCategory: "ペット", sumIncomeMoneyFromFirestore: petMoneyFromFirestore, subCategoryIncomeArray: fixedCostSuperCategory.petFixedCostSubCategoryArrayFromFirestore)
                }
                
                //incomeTableCellのCellの数
                self.incomeTableCellRowCount = self.incomeCollectionCellMoney.count
                //fixedCostTableCellのCellの数
                self.fixedCostTableCellRowCount = self.fixedCostCollectionCellMoney.count
                
                //HomeViewのlivingExpensesTextを更新するために収入コレクションの総合計と固定費コレクションの総合計を渡す
                self.incomeSumText = String(self.incomeCollectionCellMoney.reduce(0, +))
                self.fixedCostSumText = String(self.fixedCostCollectionCellMoney.reduce(0, +))
                
                //データを取得したらリロード
                print("リロードするよ")
                self.incomeTableView.reloadData()
                
                print("Homeの更新をするよ")
                self.homeLivingExpensesUpdateDelegate?.livingExpensesLabelUpdate(incomeSumText: self.incomeSumText ?? "0", fixedCostSumText: self.fixedCostSumText ?? "0")
            }
        }
    }
    
    func incomeCollectionViewSetUp(superCategory: String, sumIncomeMoneyFromFirestore: Int, subCategoryIncomeArray: [String]) {
        print("\(superCategory)の取得に成功しました。\(String(describing: sumIncomeMoneyFromFirestore))")
        self.incomeCollectionCellTitle.append("\(superCategory)")
        self.incomeCollectionCellImage.append((SuperCategoryIcon.IncomeIcon["\(superCategory)"] ?? UIImage(systemName: "questionmark.folder"))!)
        //収入の親カテゴリーの合計をFirestoreからとってきている
        self.incomeCollectionCellMoney.append(sumIncomeMoneyFromFirestore)
        //Firestoreに保存する給料サブカテゴリー固定費に追加する(既にif letで親の給料カテゴリー固定費があるかないか判断されている)(給料のサブカテゴリー→ボーナス、その他など)
        //収入の親カテゴリーのサブカテゴリーの配列をFirestoreからとってきている
        switch superCategory {
        case "給料":
            self.salaryIncomeSubCategoryArray = subCategoryIncomeArray
        case "副業":
            self.sideBusinessIncomeSubCategoryArray = subCategoryIncomeArray
        case "臨時収入":
            self.extraordinaryIncomeSubCategoryArray = subCategoryIncomeArray
        case "投資":
            self.investmentIncomeSubCategoryArray = subCategoryIncomeArray
        case "賞":
            self.prizeIncomeSubCategoryArray = subCategoryIncomeArray
        default:
            break
        }
    }

    func fixedCollectionViewSetUp(superCategory: String, sumIncomeMoneyFromFirestore: Int, subCategoryIncomeArray: [String]) {
        print("\(superCategory)の取得に成功しました。\(String(describing: sumIncomeMoneyFromFirestore))")
        self.fixedCostCollectionCellTitle.append("\(superCategory)")
        self.fixedCostCollectionCellImage.append((SuperCategoryIcon.CostIcon["\(superCategory)"] ?? UIImage(systemName: "questionmark.folder"))!)
        //収入の親カテゴリーの合計をFirestoreからとってきている
        self.fixedCostCollectionCellMoney.append(sumIncomeMoneyFromFirestore)
        //Firestoreに保存する給料サブカテゴリー固定費に追加する(既にif letで親の給料カテゴリー固定費があるかないか判断されている)(給料のサブカテゴリー→ボーナス、その他など)
        //収入の親カテゴリーのサブカテゴリーの配列をFirestoreからとってきている
        switch superCategory {
        case "食費":
            self.foodFixedCostSubCategoryArray = subCategoryIncomeArray
        case "日用品":
            self.dailyGoodsFixedCostSubCategoryArray = subCategoryIncomeArray
        case "服飾":
            self.clothFixedCostSubCategoryArray = subCategoryIncomeArray
        case "健康":
            self.healthFixedCostSubCategoryArray = subCategoryIncomeArray
        case "交際":
            self.datingFixedCostSubCategoryArray = subCategoryIncomeArray
        case "趣味":
            self.hobbiesFixedCostSubCategoryArray = subCategoryIncomeArray
        case "教養":
            self.liberalArtsFixedCostSubCategoryArray = subCategoryIncomeArray
        case "交通":
            self.transportationFixedCostSubCategoryArray = subCategoryIncomeArray
        case "美容":
            self.cosmetologyFixedCostSubCategoryArray = subCategoryIncomeArray
        case "観光":
            self.sightseeingFixedCostSubCategoryArray = subCategoryIncomeArray
        case "車":
            self.carFixedCostSubCategoryArray = subCategoryIncomeArray
        case "バイク":
            self.motorcycleFixedCostSubCategoryArray = subCategoryIncomeArray
        case "通信":
            self.netWorkFixedCostSubCategoryArray = subCategoryIncomeArray
        case "水道代":
            self.waterFixedCostSubCategoryArray = subCategoryIncomeArray
        case "ガス代":
            self.gasFixedCostSubCategoryArray = subCategoryIncomeArray
        case "電気代":
            self.electricityFixedCostSubCategoryArray = subCategoryIncomeArray
        case "保険":
            self.insuranceFixedCostSubCategoryArray = subCategoryIncomeArray
        case "税金":
            self.taxFixedCostSubCategoryArray = subCategoryIncomeArray
        case "住宅":
            self.housingFixedCostSubCategoryArray = subCategoryIncomeArray
        case "医療":
            self.medicalFixedCostSubCategoryArray = subCategoryIncomeArray
        case "ペット":
            self.petFixedCostSubCategoryArray = subCategoryIncomeArray
        default:
            break
        }
    }
    
    //一番大元となるcollectionviewのデザイン
    func baseCollectionViewSetUp() {
        backgroundColor = .white
        layer.cornerRadius = 10
        //shadowOffset = CGSize(width: 大きければ大きほど右に動く, height: 大きければ大きいほど下に動く)
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.borderWidth = 1
        layer.borderColor = colors.black.cgColor
        //CollectionCellの高さを決める
        let incomeAndFixedCostLabelHeight = 44
        let sumMoneyLabelHeight = 44
        self.anchor(width: UIScreen.main.bounds.width / 2 - 20, height: CGFloat((incomeAndFixedCostLabelHeight + sumMoneyLabelHeight) + (44 * tableCountUp)))
    }

}
extension incomeAndFixedCostCollectionViewCell: UITableViewDataSource , UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
      }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //収入コレクション
        if incomeLabel.text == "収入" {
            if section == 0 {
                print("読み込まれるincomeTableCellRowCount: \(incomeTableCellRowCount)")
                return incomeTableCellRowCount
            }
        } else { //固定費コレクション
            if section == 0 {
                print("読み込まれるfixedCostTableCellRowCount: \(fixedCostTableCellRowCount)")
                return fixedCostTableCellRowCount
            }
        }
        //PlusMinusCell
        if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        //PlusMinusCellに対して
        case 1:
            let plusMinusCell = tableView.dequeueReusableCell(withIdentifier: "incomeTableViewPlusMinusCustomCell", for: indexPath) as! incomePlusMinusTableViewCell
            if incomeLabel.text == "収入" {
                //tableCellの数を増減するためのプロトコルとInputViewControllerへ遷移するプロトコルを使う
                plusMinusCell.incomeTableViewCellPlusButton.addTarget(self, action: #selector(incomePlusCellButtonTapped), for: .touchUpInside)
            } else {
                //tableCellの数を増減するためのプロトコルとInputViewControllerへ遷移するプロトコルを使う
                plusMinusCell.incomeTableViewCellPlusButton.addTarget(self, action: #selector(fixedCostPlusCellButtonTapped), for: .touchUpInside)
            }
            return plusMinusCell
        //CategoryTextCellに対して
        default:
            print("TableView読み込まれたよ")
            let cell = incomeTableView.dequeueReusableCell(withIdentifier: "incomeCustomCell", for: indexPath) as! incomeTableViewCell
            //収入コレクションのTableViewレイアウト
            if incomeLabel.text == "収入" {
                print("収入コレクション読み込まれたよ")
                if cell.incomeSuperCategoryNameLabel.text == nil {
                    cell.incomeSuperCategoryNameLabel.text = "収入名"
                }
                // ???: なぜかincomeCategoryCollectionViewControllerでは配列の数チェックなしで通るが、このTableViewでは配列の数チェックがいる
                if incomeCollectionCellMoney != [] {
                    print(incomeCollectionCellMoney)
                    cell.incomeSuperCategoryMoneyLabel.text = String(incomeCollectionCellMoney[indexPath.row])
                    cell.incomeSuperCategoryNameLabel.text = incomeCollectionCellTitle[indexPath.row]
                    cell.incomeSuperCategoryImageButton.setImage(incomeCollectionCellImage[indexPath.row], for: .normal)
                    print("タイトルの名前\(String(describing: cell.incomeSuperCategoryNameLabel.text))")
                }
                print("収入TableView更新完了")
                //収入コレクションの総合計金額を更新
                self.incomeSumMoneyLabel.text = incomeSumText
                return cell
            } else { //固定費コレクションのTableViewレイアウト
                print("固定費コレクション読み込まれたよ")
                //一回読み込まれているからテキストがnilから"収入名"になっている
                if cell.incomeSuperCategoryNameLabel.text == "収入名" {
                    cell.incomeSuperCategoryNameLabel.text = "固定費名"
                }
                // ???: なぜかincomeCategoryCollectionViewControllerでは配列の数チェックなしで通るが、このTableViewでは配列の数チェックがいる
                if fixedCostCollectionCellMoney != [] {
                    print(fixedCostCollectionCellMoney)
                    cell.incomeSuperCategoryMoneyLabel.text = String(fixedCostCollectionCellMoney[indexPath.row])
                    cell.incomeSuperCategoryNameLabel.text = fixedCostCollectionCellTitle[indexPath.row]
                    cell.incomeSuperCategoryImageButton.setImage(fixedCostCollectionCellImage[indexPath.row], for: .normal)
                    print("タイトルの名前\(String(describing: cell.incomeSuperCategoryNameLabel.text))")
                }
                print("固定費TableView更新完了")
                //固定費コレクションの総合計金額を更新
                print("fixedCostSumText: \(fixedCostSumText)")
                self.incomeSumMoneyLabel.text = fixedCostSumText
                return cell
            }
        }
    }

    //収入コレクションのプラスボタンがクリックされたとき
    @objc func incomePlusCellButtonTapped() {
        plusMinusDelegate?.calcIncomeTableViewCell(calc: { (tableCellRowCount: Int) -> Int in
            tableCellRowCount + 1
        })
        delegate.goInputViewController(h1Label: "収入名")
    }

    //固定費コレクションのプラスボタンがクリックされたとき
    @objc func fixedCostPlusCellButtonTapped() {
        plusMinusDelegate?.calcFixedCostTableViewCell(calc: { (tableCellRowCount: Int) -> Int in
            tableCellRowCount + 1
        })
        delegate.goInputViewController(h1Label: "固定費名")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            //ここにプラスマイナスが選択された時のコードを書く
            break
        default:
            print("クリックしたセル\(indexPath.row)")
            var h1LabelReciver: String!
            var clickedCellNumber: Int!
            if incomeLabel.text == "収入" {
                h1LabelReciver = "収入名"
                clickedCellNumber = indexPath.row
            } else {
                h1LabelReciver = "固定費名"
                clickedCellNumber = indexPath.row
            }
            self.delegate.goInputViewController(h1Label: h1LabelReciver)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //Cellの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        print("deleteされるよ")
        //nilチェック
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let currentHomeTitleMonth = currentHomeTitleMonth else { return }
        let stringCurrentHomeTitleMonth = String(currentHomeTitleMonth)
        guard let currentHomeTitleYear = currentHomeTitleYear else { return }
        calendarViewController.currentDay.dateFormat = "dd"
        let day = calendarViewController.currentDay.string(from: calendarViewController.currentDate)

        switch editingStyle {
        case .delete:
            //収入コレクション
            if incomeLabel.text == "収入" {

                //親カテゴリーの情報を削除
                db.collection("\(currentHomeTitleYear)superCategoryIncomeAndExpenditure").document(uid).updateData([

                    // ???: selfがついていないincomeCollectionCellTitleは正しく読み込まれるが、selfがついている、incomeCollectionCellMoneyはnilになる。なぜか？→対応策としてとりあえず、配列Idを取得しないといけないからついでに格納されているお金を取得して削除している
                    //月の親カテゴリーを削除
                    "\(currentHomeTitleMonth)\(incomeCollectionCellTitle[indexPath.row])SumMoney": FieldValue.delete(),
                    //年の親カテゴリーから削除した月の親カテゴリーお金を引いていく
                    "\(currentHomeTitleYear)\(incomeCollectionCellTitle[indexPath.row])SumMoney": FieldValue.increment(Int64(-incomeCollectionCellMoney[indexPath.row])),
                    //サブカテゴリー固定費名前配列(サブカテゴリーの名前が格納されている配列)を削除する
                    "\(currentHomeTitleMonth)\(incomeCollectionCellTitle[indexPath.row])配列": FieldValue.delete()

                ]) { err in
                    if let err = err {
                        print("収入Cellのデータ削除・更新に失敗しました: \(err)")
                    } else {
                        print("収入Cellのデータ削除・更新に成功しました")
                    }
                }

                switch incomeCollectionCellTitle[indexPath.row] {
                case "給料":
                    //予め、salaryIncomeSubCategoryArrayに親カテゴリーが読み込まれたときにサブカテゴリー配列として持っておく
                    for sabuCategoryIncomeName in salaryIncomeSubCategoryArray {
                        //サブカテゴリーのdayId配列を削除するために取得する
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).getDocument { snapshot, err in
                            // エラー発生時
                            if let err = err {
                                print("FirestoreからのサブカテゴリーdaiId配列の取得に失敗しました: \(err)")
                            } else {
                                // コレクション内のドキュメントを取得
                                guard let data = snapshot?.data() else { return }
                                //受け取った収入コレクション用に収入親カテゴリー情報の整理
                                let daySubCategory = DaySubCategoryFromFireStore.init(dic: data, month: currentHomeTitleMonth, subCategoryName: sabuCategoryIncomeName)
                                let dayIdArray = DayIdArrayFromFireStore.init(dic: data, month: stringCurrentHomeTitleMonth, day: day, subCategoryName: sabuCategoryIncomeName)

                                guard let daySubCategoryAray = dayIdArray.daySubCategoryIdArray else { return }
                                guard let daySubCategoryMoney = daySubCategory.daySubCategoryMoney else { return }

                                for daySubCategoryId in daySubCategoryAray {
                                    //サブカテゴリーの情報の削除
                                    print("sabuCategoryIncomeName: \(sabuCategoryIncomeName)")
                                    print("incomeCollectionCellMoney:\(daySubCategoryMoney)")
                                    self.db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([

                                        //日のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //dayId配列のまとめを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)dayId配列": FieldValue.delete(),
                                        //個別のdayIdが付与されたフィールドを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)\(daySubCategoryId)": FieldValue.delete(),
                                        //月のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //年のサブカテゴリーを引く
                                        "\(currentHomeTitleYear)\(sabuCategoryIncomeName)SumMoney": FieldValue.increment(Int64(-daySubCategoryMoney))

                                        ]) { err in
                                        if let err = err {
                                            print("給料サブカテゴリーのデータ削除・更新に失敗しました: \(err)")
                                        } else {
                                            print("給料サブカテゴリーのデータ削除・更新に成功しました")
                                        }
                                    }
                                }
                            }
                        }
                    }
                case "副業":
                    for sabuCategoryIncomeName in sideBusinessIncomeSubCategoryArray {
                        //サブカテゴリーのdayId配列を削除するために取得する
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).getDocument { snapshot, err in
                            // エラー発生時
                            if let err = err {
                                print("FirestoreからのサブカテゴリーdaiId配列の取得に失敗しました: \(err)")
                            } else {
                                // コレクション内のドキュメントを取得
                                guard let data = snapshot?.data() else { return }
                                //受け取った収入コレクション用に収入親カテゴリー情報の整理
                                let daySubCategory = DaySubCategoryFromFireStore.init(dic: data, month: currentHomeTitleMonth, subCategoryName: sabuCategoryIncomeName)
                                let dayIdArray = DayIdArrayFromFireStore.init(dic: data, month: stringCurrentHomeTitleMonth, day: day, subCategoryName: sabuCategoryIncomeName)

                                guard let daySubCategoryAray = dayIdArray.daySubCategoryIdArray else { return }
                                guard let daySubCategoryMoney = daySubCategory.daySubCategoryMoney else { return }

                                for daySubCategoryId in daySubCategoryAray {
                                    //サブカテゴリーの情報の削除
                                    print("sabuCategoryIncomeName: \(sabuCategoryIncomeName)")
                                    print("incomeCollectionCellMoney:\(daySubCategoryMoney)")
                                    self.db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([

                                        //日のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //dayId配列のまとめを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)dayId配列": FieldValue.delete(),
                                        //個別のdayIdが付与されたフィールドを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)\(daySubCategoryId)": FieldValue.delete(),
                                        //月のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //年のサブカテゴリーを引く
                                        "\(currentHomeTitleYear)\(sabuCategoryIncomeName)SumMoney": FieldValue.increment(Int64(-daySubCategoryMoney))

                                        ]) { err in
                                        if let err = err {
                                            print("副業サブカテゴリーのデータ削除・更新に失敗しました: \(err)")
                                        } else {
                                            print("副業サブカテゴリーのデータ削除・更新に成功しました")
                                        }
                                    }
                                }
                            }
                        }
                    }
                case "臨時収入":
                    for sabuCategoryIncomeName in extraordinaryIncomeSubCategoryArray {
                        //サブカテゴリーのdayId配列を削除するために取得する
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).getDocument { snapshot, err in
                            // エラー発生時
                            if let err = err {
                                print("FirestoreからのサブカテゴリーdaiId配列の取得に失敗しました: \(err)")
                            } else {
                                // コレクション内のドキュメントを取得
                                guard let data = snapshot?.data() else { return }
                                //受け取った収入コレクション用に収入親カテゴリー情報の整理
                                let daySubCategory = DaySubCategoryFromFireStore.init(dic: data, month: currentHomeTitleMonth, subCategoryName: sabuCategoryIncomeName)
                                let dayIdArray = DayIdArrayFromFireStore.init(dic: data, month: stringCurrentHomeTitleMonth, day: day, subCategoryName: sabuCategoryIncomeName)

                                guard let daySubCategoryAray = dayIdArray.daySubCategoryIdArray else { return }
                                guard let daySubCategoryMoney = daySubCategory.daySubCategoryMoney else { return }

                                for daySubCategoryId in daySubCategoryAray {
                                    //サブカテゴリーの情報の削除
                                    print("sabuCategoryIncomeName: \(sabuCategoryIncomeName)")
                                    print("incomeCollectionCellMoney:\(daySubCategoryMoney)")
                                    self.db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([

                                        //日のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //dayId配列のまとめを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)dayId配列": FieldValue.delete(),
                                        //個別のdayIdが付与されたフィールドを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)\(daySubCategoryId)": FieldValue.delete(),
                                        //月のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //年のサブカテゴリーを引く
                                        "\(currentHomeTitleYear)\(sabuCategoryIncomeName)SumMoney": FieldValue.increment(Int64(-daySubCategoryMoney))

                                        ]) { err in
                                        if let err = err {
                                            print("臨時収入サブカテゴリーのデータ削除・更新に失敗しました: \(err)")
                                        } else {
                                            print("臨時収入サブカテゴリーのデータ削除・更新に成功しました")
                                        }
                                    }
                                }
                            }
                        }
                    }
                case "投資":
                    for sabuCategoryIncomeName in investmentIncomeSubCategoryArray {
                        //サブカテゴリーのdayId配列を削除するために取得する
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).getDocument { snapshot, err in
                            // エラー発生時
                            if let err = err {
                                print("FirestoreからのサブカテゴリーdaiId配列の取得に失敗しました: \(err)")
                            } else {
                                // コレクション内のドキュメントを取得
                                guard let data = snapshot?.data() else { return }
                                //受け取った収入コレクション用に収入親カテゴリー情報の整理
                                let daySubCategory = DaySubCategoryFromFireStore.init(dic: data, month: currentHomeTitleMonth, subCategoryName: sabuCategoryIncomeName)
                                let dayIdArray = DayIdArrayFromFireStore.init(dic: data, month: stringCurrentHomeTitleMonth, day: day, subCategoryName: sabuCategoryIncomeName)

                                guard let daySubCategoryAray = dayIdArray.daySubCategoryIdArray else { return }
                                guard let daySubCategoryMoney = daySubCategory.daySubCategoryMoney else { return }

                                for daySubCategoryId in daySubCategoryAray {
                                    //サブカテゴリーの情報の削除
                                    print("sabuCategoryIncomeName: \(sabuCategoryIncomeName)")
                                    print("incomeCollectionCellMoney:\(daySubCategoryMoney)")
                                    self.db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([

                                        //日のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //dayId配列のまとめを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)dayId配列": FieldValue.delete(),
                                        //個別のdayIdが付与されたフィールドを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)\(daySubCategoryId)": FieldValue.delete(),
                                        //月のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //年のサブカテゴリーを引く
                                        "\(currentHomeTitleYear)\(sabuCategoryIncomeName)SumMoney": FieldValue.increment(Int64(-daySubCategoryMoney))

                                        ]) { err in
                                        if let err = err {
                                            print("投資サブカテゴリーのデータ削除・更新に失敗しました: \(err)")
                                        } else {
                                            print("投資サブカテゴリーのデータ削除・更新に成功しました")
                                        }
                                    }
                                }
                            }
                        }
                    }
                case "賞":
                    for sabuCategoryIncomeName in prizeIncomeSubCategoryArray {
                        //サブカテゴリーのdayId配列を削除するために取得する
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).getDocument { snapshot, err in
                            // エラー発生時
                            if let err = err {
                                print("FirestoreからのサブカテゴリーdaiId配列の取得に失敗しました: \(err)")
                            } else {
                                // コレクション内のドキュメントを取得
                                guard let data = snapshot?.data() else { return }
                                //受け取った収入コレクション用に収入親カテゴリー情報の整理
                                let daySubCategory = DaySubCategoryFromFireStore.init(dic: data, month: currentHomeTitleMonth, subCategoryName: sabuCategoryIncomeName)
                                let dayIdArray = DayIdArrayFromFireStore.init(dic: data, month: stringCurrentHomeTitleMonth, day: day, subCategoryName: sabuCategoryIncomeName)

                                guard let daySubCategoryAray = dayIdArray.daySubCategoryIdArray else { return }
                                guard let daySubCategoryMoney = daySubCategory.daySubCategoryMoney else { return }

                                for daySubCategoryId in daySubCategoryAray {
                                    //サブカテゴリーの情報の削除
                                    print("sabuCategoryIncomeName: \(sabuCategoryIncomeName)")
                                    print("incomeCollectionCellMoney:\(daySubCategoryMoney)")
                                    self.db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([

                                        //日のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //dayId配列のまとめを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)dayId配列": FieldValue.delete(),
                                        //個別のdayIdが付与されたフィールドを削除
                                        "\(currentHomeTitleMonth)\(day)\(sabuCategoryIncomeName)\(daySubCategoryId)": FieldValue.delete(),
                                        //月のサブカテゴリーを削除
                                        "\(currentHomeTitleMonth)\(sabuCategoryIncomeName)SumMoney": FieldValue.delete(),
                                        //年のサブカテゴリーを引く
                                        "\(currentHomeTitleYear)\(sabuCategoryIncomeName)SumMoney": FieldValue.increment(Int64(-daySubCategoryMoney))

                                        ]) { err in
                                        if let err = err {
                                            print("賞サブカテゴリーのデータ削除・更新に失敗しました: \(err)")
                                        } else {
                                            print("賞サブカテゴリーのデータ削除・更新に成功しました")
                                        }
                                    }
                                }
                            }
                        }
                    }
                default:
                    break
                }
                //親カテゴリー固定費の金額==サブカテゴリー固定費の金額
                let intIncomeCollectionCellMoney = Int(incomeCollectionCellMoney[indexPath.row])
                guard let intIncomeSumText = Int(self.incomeSumText) else { return }
                //今の収入の総合計金額ラベルテキストから削除する金額を引く
                self.incomeSumText = String(intIncomeSumText - intIncomeCollectionCellMoney)
                print("deleteした後のincomeSumText: \(self.incomeSumText)")
                //生活費(収入ー固定費)を更新するためのプロトコル
                self.homeLivingExpensesUpdateDelegate?.livingExpensesLabelUpdate(incomeSumText: self.incomeSumText ?? "0", fixedCostSumText: self.fixedCostSumText ?? "0")
                //固定費の総合計金額を更新(incomeSumMoneyLabelは名前がややこしいが、収入と固定費の総合計ラベル)
                self.incomeSumMoneyLabel.text = self.incomeSumText
                incomeCollectionCellMoney.remove(at: indexPath.row)
                incomeTableCellRowCount = incomeCollectionCellMoney.count
            } else { //固定費コレクション

                //親カテゴリーの固定費情報を削除
                db.collection("\(currentHomeTitleYear)superCategoryIncomeAndExpenditure").document(uid).updateData([

                    //月の固定費を削除
                    "\(currentHomeTitleMonth)\(fixedCostCollectionCellTitle[indexPath.row])固定費SumMoney": FieldValue.delete(),
                    //サブカテゴリー固定費名前配列を削除する
                    "\(currentHomeTitleMonth)\(fixedCostCollectionCellTitle[indexPath.row])固定費配列": FieldValue.delete(),
                    //年の固定費を削除
                    "\(currentHomeTitleYear)\(fixedCostCollectionCellTitle[indexPath.row])固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))


                ]) { err in
                    if let err = err {
                        print("固定費Cellのデータ削除・更新に失敗しました: \(err)")
                    } else {
                        print("固定費Cellのデータ削除・更新に成功しました")
                    }
                }
                //サブカテゴリーの固定費情報を削除
                switch fixedCostCollectionCellTitle[indexPath.row] {
                case "食費":
                    //削除されるときにサブカテゴリーの固定費情報を消す→こうすることでデータの読み取りが最小限になる
                    //予め、foodFixedCostSubCategoryArrayに親カテゴリー固定費が読み込まれたときにサブカテゴリー固定費配列として持っておく
                    for sabuCategoryFixedCostName in foodFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("食費サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("食費サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "日用品":
                    for sabuCategoryFixedCostName in dailyGoodsFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("日用品サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("日用品サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "服飾":
                    for sabuCategoryFixedCostName in clothFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("服飾サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("服飾サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "健康":
                    for sabuCategoryFixedCostName in healthFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("健康サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("健康サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "交際":
                    for sabuCategoryFixedCostName in datingFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("交際サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("交際サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "趣味":
                    for sabuCategoryFixedCostName in hobbiesFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("趣味サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("趣味サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "教養":
                    for sabuCategoryFixedCostName in liberalArtsFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("教養サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("教養サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "交通":
                    for sabuCategoryFixedCostName in transportationFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("交通サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("交通サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "美容":
                    for sabuCategoryFixedCostName in cosmetologyFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("美容サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("美容サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "観光":
                    for sabuCategoryFixedCostName in sightseeingFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("観光サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("観光サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "車":
                    for sabuCategoryFixedCostName in carFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("車サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("車サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "バイク":
                    for sabuCategoryFixedCostName in motorcycleFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("バイクサブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("バイクサブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "通信":
                    for sabuCategoryFixedCostName in netWorkFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("通信サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("通信サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "水道代":
                    for sabuCategoryFixedCostName in waterFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("水道代サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("水道代サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "ガス代":
                    for sabuCategoryFixedCostName in gasFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("ガス代サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("ガス代サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "電気代":
                    for sabuCategoryFixedCostName in electricityFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("電気代サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("電気代サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "保険":
                    for sabuCategoryFixedCostName in insuranceFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("保険サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("保険サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "税金":
                    for sabuCategoryFixedCostName in taxFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("税金サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("税金サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "住宅":
                    for sabuCategoryFixedCostName in housingFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("住宅サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("住宅サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "医療":
                    for sabuCategoryFixedCostName in medicalFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("医療サブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("医療サブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                case "ペット":
                    for sabuCategoryFixedCostName in petFixedCostSubCategoryArray {
                        //固定費サブカテゴリーの削除
                        print("sabuCategoryFixedCostName: \(sabuCategoryFixedCostName)")
                        db.collection("\(currentHomeTitleYear)subCategoryIncomeAndExpenditure").document(uid).updateData([
                            //月のサブカテゴリー名前固定費を削除
                            "\(currentHomeTitleMonth)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.delete(),
                            //年のサブカテゴリー名前固定費を引く
                            "\(currentHomeTitleYear)\(sabuCategoryFixedCostName)固定費SumMoney": FieldValue.increment(Int64(-fixedCostCollectionCellMoney[indexPath.row]))

                        ]) { err in
                            if let err = err {
                                print("ペットサブカテゴリー固定費Cellのデータ削除・更新に失敗しました: \(err)")
                            } else {
                                print("ペットサブカテゴリー固定費Cellのデータ削除・更新に成功しました")
                            }
                        }
                    }
                default:
                    break
                }

                //親カテゴリー固定費の金額==サブカテゴリー固定費の金額
                let intfixedCostCollectionCellMoney = Int(fixedCostCollectionCellMoney[indexPath.row])
                guard let intfixedCostSumText = Int(self.fixedCostSumText) else { return }
                //今の固定費の総合計金額から保存してある固定費を引く
                self.fixedCostSumText = String(intfixedCostSumText - intfixedCostCollectionCellMoney)
                print("deleteした後のfixedCostSumText: \(self.fixedCostSumText)")
                //生活費(収入ー固定費)を更新するためのプロトコル
                self.homeLivingExpensesUpdateDelegate?.livingExpensesLabelUpdate(incomeSumText: self.incomeSumText ?? "0", fixedCostSumText: self.fixedCostSumText ?? "0")
                //固定費の総合計金額を更新
                self.incomeSumMoneyLabel.text = self.fixedCostSumText

                //配列から消したものを取り除く
                fixedCostCollectionCellMoney.remove(at: indexPath.row)
                fixedCostTableCellRowCount = fixedCostCollectionCellMoney.count
            }

            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        //???: 以下の2つは何を表しているのか？
        case .insert, .none:
            // NOP
            break
        @unknown default:
            break
        }
    }
}
//収入と固定費テーブルビューのcell増減
extension incomeAndFixedCostCollectionViewCell: PlusMinusProtocol {

    //IncomeCollectionのCellの数の増減
    func calcIncomeTableViewCell(calc: (Int) -> Int) {
        //プラスかマイナスを受け取る
        incomeTableCellRowCount = calc(incomeTableCellRowCount)
    }

    //FixedCostCollectionのCellの数の増減
    func calcFixedCostTableViewCell(calc: (Int) -> Int) {
        fixedCostTableCellRowCount = calc(fixedCostTableCellRowCount)
    }

}
