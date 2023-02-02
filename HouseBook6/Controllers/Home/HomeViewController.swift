//
//  Home2ViewController.swift
//  HouseBook
//
//  Created by Dora on 2022/03/29.
//

import UIKit
import Firebase
import PKHUD
import GoogleMobileAds

class HomeViewController: UIViewController {
    
    let yearArray: [String] = ["2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033"]
    let monthArray: [String] = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    
    var bannerView: GADBannerView!
    
    //インスタンス化
    let db = Firestore.firestore()
    var costMonthSuperCategory: CostMothSuperCategoryFromFireStore?
    let dicForNil: [String:Any] = [:]
    
    //インスタンス化
    var userDefaults = UserDefaults.standard
    
    static var homeViewInstance = HomeViewController()
    
    // 収入と固定費のコレクションの共有インスタンス
    let incomeAndFixedCollectionInstance = incomeAndFixedCostCollectionViewCell.incomeAndFixedCollectionInstance
    var incomeAndFixedIconNameReciever: String!
    var incomeAndFixedIconMoneyReciever: String!
    
    let colors = Colors()
    
    //カレンダーの日付をとる共有インスタンス
    let calendarViewController = CalendarViewController.calendarViewControllerInstance
    
    var currentTitleMonth: String!
    var currentTitleYear: String!
    
    @IBAction func goDetailSettingStoryboardButton(_ sender: Any) {
        performSegue(withIdentifier: "goDetailSettingStoryboard", sender: nil)
    }
    
    //HomeViewの高さ
    @IBOutlet weak var homeViewHeightConstraint: NSLayoutConstraint!
    
    var sumMoneyButtonFlag: Bool = false
    //総資産と純資産のボタン
    @IBOutlet weak var sumMoneyButton: UIButton!
    @IBAction func changeNetWorth(_ sender: Any) {
        //真偽値を入れ替える。最初はfalseからtrueに変換
        sumMoneyButtonFlag.toggle()
        
        if sumMoneyButtonFlag {
            sumMoneyButton.setTitle("純資産(貯金額)", for: .normal)
        } else {
            sumMoneyButton.setTitle("総資産(貯金額+投資)", for: .normal)
        }
    }
    
    //総資産と純資産の表示箇所
    @IBOutlet weak var sumMoneyBackgroundView: UIView!
    @IBOutlet weak var sumMoneyLabel: UILabel!
    
    //収入と固定費のコレクションビュー
    @IBOutlet weak var incomeAndFixedCostCollection: UICollectionView!
    //収入と固定費のコレクションビューの高さ指定
    @IBOutlet weak var incomeAndFixedCollectionHeightConstraint: NSLayoutConstraint!
    //収入と固定費の数
    let tableCountUp = 3
    //収入と固定費のコレクションビューの題名を入れる配列
    let incomeLabelHeader = ["収入","固定費"]
    
    //投資コレクション
    @IBOutlet weak var investCollectionView: UICollectionView!
    
    @IBAction func investPlusButtonAction(_ sender: Any) {
        //投資の種類を追加する時の処理
        
    }
    //生活費のボタン
    @IBOutlet weak var livingExpensesButton: UIButton!
    //生活費の表示箇所
    @IBOutlet weak var livingExpensesBackgroundView: UIView!
    //生活費(収入ー固定費)のテキストラベル
    @IBOutlet weak var livingExpensesTextLabel: UILabel!
    
    //生活費のコレクションビュー
    @IBOutlet weak var livingExpensesCollection: UICollectionView!
    //生活費のコレクションビューの高さ指定
    @IBOutlet weak var livingExpensesCollectionHeightConstraint: NSLayoutConstraint!
    //生活費のタイトル
    var livingExpensesCollectionCellTitle: [String] = []
    //生活費のImgae
    var livingExpensesCollectionCellImage: [UIImage] = []
    //生活費の目標金額を格納する配列
    var livingExpensesTargetAmountArray: [String] = []
    //生活費の使用金額
    var livingExpensesCollectionCellMoney: [Int] = []
    //使用金額の合計値を計算して代入する変数
    var usageSum = 0
    
    //貯金額のボタン
    @IBOutlet weak var savingAmountButton: UIButton!
    //貯金額の表示箇所
    @IBOutlet weak var savingAmountBackgroundView: UIView!
    //貯金額のテキストラベル
    @IBOutlet weak var savingAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: AdMob
        //        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        //        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //        bannerView.rootViewController = self
        //        bannerView.load(GADRequest())
        //        addBannerViewToView(bannerView)
        
        let sumMoneyButtonHeight: CGFloat = 40
        let paddingHeight: CGFloat = 10
        let paddingCount: CGFloat = 10
        let sumMoneyBackgroundHeight: CGFloat = 64
        let incomeAndFixedCostCollectionHeight = CGFloat(44 * 2 + 44 * tableCountUp + 20)
        let livingExpensesButtonHeight: CGFloat = 40
        let livingExpensesBackgroundHeight: CGFloat = 64
        let livingExpensesCollectionHeight = CGFloat((UIScreen.main.bounds.width / 2 - 20) * 8 / 2 + 50)
        let savingAmountButtonHeight: CGFloat = 40
        let savingAmountBackgroundHeight: CGFloat = 64
        let investLabelHeight: CGFloat = 40
        let investCollectionHeight: CGFloat = 100
        //HomeViewの高さを画面サイズによって変える
        homeViewHeightConstraint.constant = CGFloat(sumMoneyButtonHeight + paddingHeight * paddingCount + sumMoneyBackgroundHeight + incomeAndFixedCostCollectionHeight + livingExpensesButtonHeight + livingExpensesBackgroundHeight +
        livingExpensesCollectionHeight + savingAmountButtonHeight + savingAmountBackgroundHeight + investLabelHeight + investCollectionHeight)
        //タイトルの日付を取得
        calendarViewController.currentMonth.dateFormat = "MM"
        calendarViewController.currentYear.dateFormat = "yyyy"
        
        self.navigationItem.setTitleView(withTitle: "\(calendarViewController.currentMonth.string(from: calendarViewController.currentDate))", subTitile: "\(calendarViewController.currentYear.string(from: calendarViewController.currentDate))")
        
        //収入と固定費の入力の際に何年何月の入力か判断するための変数
        currentTitleYear = calendarViewController.currentYear.string(from: calendarViewController.currentDate)
        currentTitleMonth = calendarViewController.currentMonth.string(from: calendarViewController.currentDate)
        
        //総資産の背景Viewをセットアップ
        setUpSumMoneyBackgroundContent()
        
        //incomeAndFixedCostのコレクションセルを登録
        incomeAndFixedCostCollection.register(UINib(nibName: "incomeAndFixedCostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "incomeAndFixedCostCell")
        //incomeAndFixedCostCollectionViewの高さを決める(ラベル*2+cell*初期3列+ margin)
        incomeAndFixedCollectionHeightConstraint.constant = incomeAndFixedCostCollectionHeight
        
        //生活費(収入ー固定費)の背景Viewをセットアップ
        setUpLivingExpensesBackgroundContent()
        
        //livingExpensesCollectionのコレクションセルを登録
        livingExpensesCollection.register(UINib(nibName: "livingExpensesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "livingExpensesCustomCell")
        //livingExpensesCollectionViewの高さを決める
        livingExpensesCollectionHeightConstraint.constant = livingExpensesCollectionHeight
        
        //貯金額の背景Viewをセットアップ
        setUpsavingAmountBackgroundContent()
        
        //投資コレクションセルを登録
        investCollectionView.register(UINib(nibName: "InvestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InvestCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLivingExpensesCollectionDataFromFirestore()
    }
    
    //HomeViewが見られるたびに呼ばれる関数
    //生活費の"\(month)食費SumMoney"をFirestoreからとってくる
    //???: 収入と固定費でFirestoreから同じドキュメントを読み取っているので、2回読み込む必要はない？
    func getLivingExpensesCollectionDataFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let currentTitleYear = currentTitleYear else { return }
        
        db.collection("\(currentTitleYear)superCategoryIncomeAndExpenditure").document(uid).getDocument { snapshot, err in
            // エラー発生時
            if let err = err {
                print("Firestoreからの生活費SuperCategoryDataの取得に失敗しました: \(err)")
            } else {
                // コレクション内のドキュメントを取得
                guard let data = snapshot?.data() else { return }
                print("🔶🔷生活費に使うdata\(data)")
                
                //受け取ったユーザー情報の整理
                let livingExpensesMonthSuperCategory = CostMothSuperCategoryFromFireStore.init(dic: data, month: self.currentTitleMonth ?? "0")
                
                print("🔷livingExpensesMonthSuperCategory\(livingExpensesMonthSuperCategory)")
                
                //初期化
                self.livingExpensesCollectionCellTitle = []
                self.livingExpensesCollectionCellImage = []
                self.livingExpensesTargetAmountArray = []
                self.livingExpensesCollectionCellMoney = []
                self.usageSum = 0
                
                print("🟥Firestoreから読み取った生活費の月の合計を配列に代入してHomeViewに反映させる")
                
                //生活費のデータ取得
                // ???: if文がしつこい
                if let foodMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.foodMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "食費", sumLivingExpensesMoneyFromFirestore: foodMonthSumMoneyFromFirestore)
                }
                if let dailyGoodsMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.dailyGoodsMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "日用品", sumLivingExpensesMoneyFromFirestore: dailyGoodsMonthSumMoneyFromFirestore)
                }
                if let clothMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.clothMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "服飾", sumLivingExpensesMoneyFromFirestore: clothMonthSumMoneyFromFirestore)
                }
                if let healthMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.healthdMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "健康", sumLivingExpensesMoneyFromFirestore: healthMonthSumMoneyFromFirestore)
                }
                if let datingMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.datingMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "交際", sumLivingExpensesMoneyFromFirestore: datingMonthSumMoneyFromFirestore)
                }
                if let hobbiesMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.hobbiesMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "趣味", sumLivingExpensesMoneyFromFirestore: hobbiesMonthSumMoneyFromFirestore)
                }
                if let liberalArtsMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.liberalArtsMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "教養", sumLivingExpensesMoneyFromFirestore: liberalArtsMonthSumMoneyFromFirestore)
                }
                if let transportationMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.transportationMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "交通", sumLivingExpensesMoneyFromFirestore: transportationMonthSumMoneyFromFirestore)
                }
                if let cosmetologyMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.cosmetologyMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "美容", sumLivingExpensesMoneyFromFirestore: cosmetologyMonthSumMoneyFromFirestore)
                }
                if let sightseeingMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.sightseeingMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "観光", sumLivingExpensesMoneyFromFirestore: sightseeingMonthSumMoneyFromFirestore)
                }
                if let carMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.carMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "車", sumLivingExpensesMoneyFromFirestore: carMonthSumMoneyFromFirestore)
                }
                if let motorcycleMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.motorcycleMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "バイク", sumLivingExpensesMoneyFromFirestore: motorcycleMonthSumMoneyFromFirestore)
                }
                if let netWorkMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.netWorkMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "通信", sumLivingExpensesMoneyFromFirestore: netWorkMonthSumMoneyFromFirestore)
                }
                if let waterMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.waterMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "水道代", sumLivingExpensesMoneyFromFirestore: waterMonthSumMoneyFromFirestore)
                }
                if let gasMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.gasMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "ガス代", sumLivingExpensesMoneyFromFirestore: gasMonthSumMoneyFromFirestore)
                }
                if let electricityMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.electricityMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "電気代", sumLivingExpensesMoneyFromFirestore: electricityMonthSumMoneyFromFirestore)
                }
                if let insuranceMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.insuranceMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "保険", sumLivingExpensesMoneyFromFirestore: insuranceMonthSumMoneyFromFirestore)
                }
                if let taxMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.taxMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "税金", sumLivingExpensesMoneyFromFirestore: taxMonthSumMoneyFromFirestore)
                }
                if let housingMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.housingMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "住宅", sumLivingExpensesMoneyFromFirestore: housingMonthSumMoneyFromFirestore)
                }
                if let medicalMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.medicalMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "医療", sumLivingExpensesMoneyFromFirestore: medicalMonthSumMoneyFromFirestore)
                }
                if let petMonthSumMoneyFromFirestore = livingExpensesMonthSuperCategory.petMonthSuperCategoryFromFirestore {
                    self.livingExpensesCollectionViewSetUp(superCategory: "ペット", sumLivingExpensesMoneyFromFirestore: petMonthSumMoneyFromFirestore)
                }
                self.livingExpensesCollection.reloadData()
                //収入と固定費のコレクションが読み取られるまで待つ
                //待ってから生活費のラベルのテキストを読み込む
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    //貯金額のリロード
                    //使用金額の合計値を出す
                    for usageCellMoney in self.livingExpensesCollectionCellMoney {
                        self.usageSum += usageCellMoney
                    }
                    //生活費
                    let intLivingExpensesTextLabel = Int(self.livingExpensesTextLabel.text ?? "0") ?? 0
                    print("生活費金額の合計:\(intLivingExpensesTextLabel)")
                    //貯金額
                    self.savingAmountLabel.text = String(intLivingExpensesTextLabel - self.usageSum)
                    print("貯金額の合計:\(String(describing: self.savingAmountLabel.text))")
                    //総資産への反映
                    self.userDefaults.set(intLivingExpensesTextLabel - self.usageSum, forKey: "\(self.currentTitleYear ?? "0")\(self.currentTitleMonth ?? "0")sumMoney")
                    
                    //???: 総資産足していく?
                    for year in self.yearArray {
                        for month in self.monthArray {
                            self.sumMoneyLabel.text = String(intLivingExpensesTextLabel - self.usageSum + self.userDefaults.integer(forKey: "\(year)\(month)sumMoney"))
                        }
                    }
                }
            }
        }
    }
    
    func livingExpensesCollectionViewSetUp(superCategory: String, sumLivingExpensesMoneyFromFirestore: Int) {
        print("\(superCategory)の取得に成功しました。\(String(describing: sumLivingExpensesMoneyFromFirestore))")
        self.livingExpensesCollectionCellTitle.append("\(superCategory)")
        self.livingExpensesCollectionCellImage.append((SuperCategoryIcon.CostIcon["\(superCategory)"] ?? UIImage(systemName: "questionmark.folder"))!)
        //収入の親カテゴリーの合計をFirestoreからとってきている
        self.livingExpensesCollectionCellMoney.append(sumLivingExpensesMoneyFromFirestore)
        //ifletで目標金額の存在の確認をする理由は、使用金額があったからといって目標金額を全てに設定するわけではないから
        //livingExpensesCollectionCellMoneyの同じ数しか目標金額をlivingExpensesTargetAmountArrayに入れないために1つ上の関数のFirestoreでiflet確認している
        switch superCategory {
        case "食費":
            if let foodTargetAmountTextField = userDefaults.string(forKey: "foodTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(foodTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "日用品":
            if let dailyGoodsTargetAmountTextField = userDefaults.string(forKey: "dailyGoodsTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(dailyGoodsTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "服飾":
            if let clothTargetAmountTextField = userDefaults.string(forKey: "clothTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(clothTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "健康":
            if let healthTargetAmountTextField = userDefaults.string(forKey: "healthTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(healthTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "交際":
            if let datingTargetAmountTextField = userDefaults.string(forKey: "datingTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(datingTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "趣味":
            if let hobbiesTargetAmountTextField = userDefaults.string(forKey: "hobbiesTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(hobbiesTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "教養":
            if let liberalArtsTargetAmountTextField = userDefaults.string(forKey: "liberalArtsTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(liberalArtsTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "交通":
            if let transportationTargetAmountTextField = userDefaults.string(forKey: "transportationTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(transportationTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "美容":
            if let cosmetologyTargetAmountTextField = userDefaults.string(forKey: "cosmetologyTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(cosmetologyTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "観光":
            if let sightseeingTargetAmountTextField = userDefaults.string(forKey: "sightseeingTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(sightseeingTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "車":
            if let carTargetAmountTextField = userDefaults.string(forKey: "carTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(carTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "バイク":
            if let motorcycleTargetAmountTextField = userDefaults.string(forKey: "motorcycleTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(motorcycleTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "通信":
            if let netWorkTargetAmountTextField = userDefaults.string(forKey: "netWorkTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(netWorkTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "水道代":
            if let waterTargetAmountTextField = userDefaults.string(forKey: "waterTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(waterTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "ガス代":
            if let gasTargetAmountTextField = userDefaults.string(forKey: "gasTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(gasTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "電気代":
            if let electricityTargetAmountTextField = userDefaults.string(forKey: "electricityTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(electricityTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "保険":
            if let insuranceTargetAmountTextField = userDefaults.string(forKey: "insuranceTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(insuranceTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "税金":
            if let taxTargetAmountTextField = userDefaults.string(forKey: "taxTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(taxTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "住宅":
            if let housingTargetAmountTextField = userDefaults.string(forKey: "housingTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(housingTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "医療":
            if let medicalTargetAmountTextField = userDefaults.string(forKey: "medicalTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(medicalTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        case "ペット":
            if let petTargetAmountTextField = userDefaults.string(forKey: "petTargetAmountTextField") {
                livingExpensesTargetAmountArray.append(petTargetAmountTextField)
            } else {
                livingExpensesTargetAmountArray.append("0")
            }
        default:
            break
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func setUpSumMoneyBackgroundContent() {
        sumMoneyBackgroundView.backgroundColor = colors.white
        sumMoneyBackgroundView.layer.cornerRadius = 10
        //shadowOffset = CGSize(width: 大きければ大きほど右に動く, height: 大きければ大きいほど下に動く)
        sumMoneyBackgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        sumMoneyBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        sumMoneyBackgroundView.layer.shadowOpacity = 0.2
        sumMoneyBackgroundView.layer.borderWidth = 1
        sumMoneyBackgroundView.layer.borderColor = colors.black.cgColor
    }
    
    func setUpLivingExpensesBackgroundContent() {
        livingExpensesBackgroundView.backgroundColor = colors.white
        livingExpensesBackgroundView.layer.cornerRadius = 10
        livingExpensesBackgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        livingExpensesBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        livingExpensesBackgroundView.layer.shadowOpacity = 0.2
        livingExpensesBackgroundView.layer.borderWidth = 1
        livingExpensesBackgroundView.layer.borderColor = colors.black.cgColor
    }
    
    func setUpsavingAmountBackgroundContent() {
        savingAmountBackgroundView.backgroundColor = colors.white
        savingAmountBackgroundView.layer.cornerRadius = 10
        savingAmountBackgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        savingAmountBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        savingAmountBackgroundView.layer.shadowOpacity = 0.2
        savingAmountBackgroundView.layer.borderWidth = 1
        savingAmountBackgroundView.layer.borderColor = colors.black.cgColor
    }
    
}
//MARK: 収入固定費Cell,生活費Cell,投資Cell
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0 {
            return 1
        } else if collectionView.tag == 1 {
            return 1
        } else {
            return 1
        }
    }
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return 2
        } else if collectionView.tag == 1 {
            print("livingExpensesCollectionCellMoney: \(livingExpensesCollectionCellMoney)")
            return livingExpensesCollectionCellMoney.count
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //MARK: 収入と固定費のコレクションCell
        if collectionView.tag == 0 {
            print("🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷")
            print("収入と固定費のコレクションが読み込まれたよ")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "incomeAndFixedCostCell", for: indexPath) as! incomeAndFixedCostCollectionViewCell
            //コレクションビューの題名を入れている配列をラベルに表示
            cell.incomeLabel.text = self.incomeLabelHeader[indexPath.row]
            //InputViewControllerへ移動するプロトコル
            cell.delegate = self
            cell.homeLivingExpensesUpdateDelegate = self
            print("最初のCollectionViewの描画を行います。")
            cell.getIncomeCollectionDataFromFirestore()
            return cell
        } else if collectionView.tag == 1 { //MARK: 生活費のコレクションCell
            print("🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩")
            print("🔶生活費のコレクションが読み込まれたよ")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "livingExpensesCustomCell", for: indexPath) as! livingExpensesCollectionViewCell
            print("🔶livingExpensesTargetAmountArray: \(livingExpensesTargetAmountArray)")
            print("🔶今何番目のCell\(indexPath.row)")
            //カテゴリータイトル
            cell.livingExpensesHeaderLabel.text = self.livingExpensesCollectionCellTitle[indexPath.row]
            //カテゴリーImage
            cell.livingExpensesIconImageView.image = SuperCategoryIcon.CostIcon[livingExpensesCollectionCellTitle[indexPath.row]]
            //UserDefaultsで取得した目標金額の反映
            cell.targetAmountTextField.text = self.livingExpensesTargetAmountArray[indexPath.row]
            //使用金額
            cell.usageAmountLabel.text = String(livingExpensesCollectionCellMoney[indexPath.row])
            //残高
            cell.balanceLabel.text = String((Int(livingExpensesTargetAmountArray[indexPath.row]) ?? 0) - livingExpensesCollectionCellMoney[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvestCell", for: indexPath) as! InvestCollectionViewCell
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
//Navigationタイトル変更
extension UINavigationItem {
    
    func setTitleView(withTitle title: String, subTitile: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 30, weight: .medium)
        titleLabel.textColor = .black
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = subTitile
        subTitleLabel.font = .systemFont(ofSize: 10)
        subTitleLabel.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.alignment = .firstBaseline
        stackView.axis = .horizontal
        
        self.titleView = stackView
    }
}

//HomeViewの収入・固定費テーブルビューからInputViewへ情報が渡されるためのdelegate
extension HomeViewController: PassIncomeAndFixedCollectionCellProtocol {
    
    func goInputViewController(h1Label: String) {
        let storyboard = UIStoryboard(name: "Input", bundle: nil)
        // ここに画面遷移処理(NextViewControllerに遷移する処理)を記載
        let nextVc = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        nextVc.incomeAndFixedCellReciever = h1Label
        if h1Label == "固定費名" {
            //Firestoreへ保存する固定費と他を区別するための名前
            nextVc.fixedCostReciever = "固定費"
        } else if h1Label == "収入名" {
            nextVc.incomeReciever = "収入"
        }
        nextVc.calendarYearReciver = currentTitleYear
        nextVc.calendarMonthReciver = currentTitleMonth
        //遷移先がpageshhetでもdismiss時にviewwillApeearが呼ばれるようにする
        nextVc.presentationController?.delegate = self
        self.present(nextVc, animated: true)
    }
}
//戻ったときに通知される処理
extension HomeViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Modal画面から戻った際の画面の更新処理を行う。収入か固定費のプラスをクリックして戻るとき
        print("戻ってリロードするよ")
        self.incomeAndFixedCostCollection.reloadData()
    }
}
//生活費(収入ー固定費)を更新するためのプロトコル
extension HomeViewController: IncomeAndFixedToHomeProtocol {
    
    func livingExpensesLabelUpdate(incomeSumText: String, fixedCostSumText: String) {
        //生活費(収入ー固定費)のテキストを表示
        let intIncomeSumText = Int(incomeSumText) ?? 0
        let intFixedCostSumText = Int(fixedCostSumText) ?? 0
        print("intIncomeSumText: \(intIncomeSumText)")
        print("intFixedCostSumText: \(intFixedCostSumText)")
        livingExpensesTextLabel.text = String(intIncomeSumText - intFixedCostSumText)
        print("livingExpensesTextLabel.text: \(livingExpensesTextLabel.text)")
    }
}
