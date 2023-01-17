//
//  CalendarViewController.swift
//  HouseBook6
//
//  Created by Dora on 2022/03/29.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import Firebase

class CalendarViewController: UIViewController {
    
    static var calendarViewControllerInstance = CalendarViewController()
    
    private let calendarDataManager = CalendarDataManager()

    private let cellId = "cellId"

    let dateManager = DateManager()

    let currentDate = Date()
    let currentMonth = DateFormatter()
    let currentYear = DateFormatter()
    let currentDay = DateFormatter()

    var sabun: Int!
    
    //InputViewControllerに渡す変数
    var today = ""
    var year = ""
    var month = ""
    var day = ""
    //05月と0が入る形で渡す
    var passMonth = ""

    //スクロールビューの高さ
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    //カレンダーのインスタンス化
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    //コレクションビューのインスタンス化
    @IBOutlet weak var dateDiaryCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //今日の日付を保存
        today = dateFormatter(day: Date())
        setupCalendarLayout()
        //LibraryCalendarがタップされた時に読み取った月と年
//        let currentCellMonth = currentMonth.string(from: currentDate)
//        let currentCellYear = currentYear.string(from: currentDate)
        //calendarDataManager.getDayCategoryData(currentCellMonth: currentCellMonth, currentCellYear: currentCellYear)
    }

    private func setupCalendarLayout() {
        //Calendarの装飾
        calendar.appearance.headerTitleFont = UIFont(name: "XANO-mincho", size: 14)
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayFont = UIFont(name: "XANO-mincho", size: 14)
        calendar.appearance.weekdayTextColor = .black

        //CollectionViewの登録
        dateDiaryCollectionView.register(UINib(nibName: "dateDiaryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
    }
}
//MARK: LibraryCalendar
//Calendarのdelegate
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    //日付のマスの色
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    //日付の枠線の色
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        //dateは表示する月の日数分だけ呼ばれて日付ごとに渡されるデータを変えていく
        //var today==Date()でインスタンス化されると今日の日付が生成される
        if dateFormatter(day: date) == today {
            return .black
        }
        return .clear
    }
    //日付の枠線の丸具合
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 0.5
    }
    //日付の数字の色
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //日曜==1か土曜==7かの判定
        if judgeWeekday(date) == 1 {
            return UIColor(red: 150/255, green: 30/255, blue: 0/255, alpha: 0.9)
        } else if judgeWeekday(date) == 7 {
            return UIColor(red: 0/255, green: 30/255, blue: 150/255, alpha: 0.9)
        }
        //祝日の判定
        if judgeHoliday(date) {
            return UIColor(red: 150/255, green: 30/255, blue: 0/255, alpha: 0.9)
        }
        return .black
    }

    //選択された時
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //カレンダーの形を扱いやすく変換する
        calendarSetUp(date: date)
        //選択されたLibraryCalendarの値をカレンダーに反映させる
        newCalendarSetUp()
        print("選択した1日の情報を取りに行くよ")
//        calendarDataManager.getDayCategoryData(currentCellMonth: month, currentCellYear: year, cell: <#dateDiaryCollectionViewCell#>)
        performSegue(withIdentifier: "InputViewController", sender: nil)
    }
    
    private func calendarSetUp(date: Date) {
        let calendar = Calendar(identifier: .gregorian)

        year = String(calendar.component(.year, from: date))
        //比較のためのmonth
        month = String(calendar.component(.month, from: date))
        
        day = String(calendar.component(.day, from: date))

        print("選択した日付\(year)/\(month)/\(day)")

        currentMonth.dateFormat = "MM"
        currentYear.dateFormat = "yyyy"
    }
    
    //選択されたLibraryCalendarの値をカレンダーに反映させる
    private func newCalendarSetUp() {
        dateManager.resetMonthCalendar(resetMonthData: sabun ?? 0)
        if Int(year) == Int(currentYear.string(from: currentDate))! {
            sabun = Int(month)! - Int(currentMonth.string(from: currentDate))!
            //前に戻ったら
            if Int(month)! < Int(currentMonth.string(from: currentDate))! {
                //DateManagerクラスのselectDayを変える処理
                dateManager.preMonthCalendar(preMonthData: sabun)
            } else if Int(month)! > Int(currentMonth.string(from: currentDate))! { //先に進んだら
                dateManager.nextMonthCalendar(nextMonthData: sabun)
            } else if Int(month)! == Int(currentMonth.string(from: currentDate))! {
                //sabunは0だから、preMonthCalendarでも前に戻らないし、nextMonthCalendarでも先に進まない
                //わかりやすくするために場合分けと処理を書いている
                dateManager.preMonthCalendar(preMonthData: sabun)
            }
            dateDiaryCollectionView.reloadData()
        } else if Int(year)! < Int(currentYear.string(from: currentDate))! {
            let yearSabun = Int(year)! - Int(currentYear.string(from: currentDate))!
            sabun = Int(month)! - Int(currentMonth.string(from: currentDate))! - 12 * -yearSabun
            //選択されたyearがcurrentYearよりも小さい時だから全てpreMonthCalendar()でsabun戻らないといけない
            if Int(month)! < Int(currentMonth.string(from: currentDate))! {
                dateManager.preMonthCalendar(preMonthData: sabun)
            } else if Int(month)! > Int(currentMonth.string(from: currentDate))! {
                dateManager.preMonthCalendar(preMonthData: sabun)
            } else if Int(month)! == Int(currentMonth.string(from: currentDate))! {
                dateManager.preMonthCalendar(preMonthData: sabun)
            }
            dateDiaryCollectionView.reloadData()
        } else if Int(year)! > Int(currentYear.string(from: currentDate))! {
            let yearSabun = Int(year)! - Int(currentYear.string(from: currentDate))!
            sabun = Int(month)! - Int(currentMonth.string(from: currentDate))! + 12 * yearSabun
            //選択されたyearがcurrentYearよりも大きい時だから全てnextMonthCalendar()でsabun戻らないといけない
            if Int(month)! < Int(currentMonth.string(from: currentDate))! {
                dateManager.nextMonthCalendar(nextMonthData: sabun)
            } else if Int(month)! > Int(currentMonth.string(from: currentDate))! {
                dateManager.nextMonthCalendar(nextMonthData: sabun)
            } else if Int(month)! == Int(currentMonth.string(from: currentDate))! {
                dateManager.preMonthCalendar(preMonthData: sabun)
            }
            dateDiaryCollectionView.reloadData()
        }
    }
    //InputViewControllerへ値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputViewController" {
            let inputViewController = segue.destination as! InputViewController
            inputViewController.calendarYearReciver = year
            inputViewController.calendarMonthReciver = month
            inputViewController.calendarDayReciver = day
            //遷移先がpageshhetでもdismiss時にviewwillApeearが呼ばれるようにする
            inputViewController.presentationController?.delegate = self
        }
    }

    //今日の日付を取得
    func dateFormatter(day: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: day)
    }

    //曜日判定(日曜日:1/土曜日:7)
    func judgeWeekday(_ date: Date) -> Int
    {
        //Xcodeに元から用意されているCalendar()インスタンスの機能
        //.gregorianはグレゴリオ暦のことで西暦の日付指定
        let calendar = Calendar(identifier: .gregorian)
        //Calendarのcomponent()メソッドは第一引数に「.year」「.month」「.weekday」「.day」を指定して第二引数のfromにData型の値を入れることで日曜日1~土曜日7の値を返してくれる→これで曜日を判定
        return calendar.component(.weekday, from: date)
    }
    //祝日判定を行い結果を返すメソッド（true:祝日）
    func judgeHoliday(_ date: Date) -> Bool
    {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        //.judgeJapaneseHoliday(year: let year = calendar.component(.year, from: date), month: let month = calendar.component(.month, from: date), day: let day = calendar.component(.day, from: date))取ってきた値を代入している。結果はtrueかfalseなので最後に結果をreturnしている。
        let holiday = CalculateCalendarLogic()
        let judgeHoliday = holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
        return judgeHoliday
    }
    //date型　-> 年月日をIntで取得
    func getDay(_ date: Date) -> (Int,Int,Int) {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return (year,month,day)
    }
}

//MARK: SelfMadeCalendar
//Calendarの下にあるCollectionCellのdelegate
extension CalendarViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //月毎のcellの数を返す→横にコレクションをその数だけ表示させる
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateManager.daysAcquisition()
    }
    //FirestoreのDataの読み取りと反映
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dateDiaryCollectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! dateDiaryCollectionViewCell
        //cell毎の日にち、月を取得してcurrentCellDay,currentCellMonthに代入する
        let currentCellDay = dateManager.getCurrentCellDay(index: indexPath.row)
        let currentCellMonth = dateManager.getCurrentCellMonth(index: indexPath.row)
        let currentCellYear = dateManager.getCurrentCellYear(index: indexPath.row)
        //dateDiaryCollectionViewCellに値を渡す
        cell.currentCellDay = currentCellDay
        cell.currentCellMonth = currentCellMonth
        cell.tableH1Label.text = dateManager.conversionDateFormat(index: indexPath.row)
        //FirestoreのDataの読み取り
        calendarDataManager.getDayCategoryData(currentCellMonth: cell.currentCellMonth, currentCellYear: currentCellYear, cell: cell)
        //その日のcellの数、親カテゴリーの名前、サブカテゴリーの名前、サブカテゴリーのお金、日にちを下の階層のdateDiaryCollectionViewCellに渡す
        print("🔷Firestoreからの情報の読み取り後待ってるよ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            print("🔶下の階層に渡す")
            self.perDayCategoryNameAndMoney(month: Int(currentCellMonth) ?? 0, day: Int(currentCellDay) ?? 0, cell: cell)
            //MARK: リロード
            cell.dateCategoryCollectionView.reloadData()
            //MARK: 合計が0にならないのを0にする
            cell.sumCategoryMoneySetUp()
        }
        return cell
    }
    func perDayCategoryNameAndMoney(month: Int, day: Int, cell: dateDiaryCollectionViewCell) {
        cell.categoryCount = calendarDataManager.allDaySuperCategoryName[month - 1][day - 1].count
        print("day\(day)")
        print("cell.categoryCount\(cell.categoryCount)")
        cell.recieveSuperCategoryName = calendarDataManager.allDaySuperCategoryName[month - 1][day - 1]
        cell.recieveSubCategoryName = calendarDataManager.allDaySubCategoryName[month - 1][day - 1]
        cell.recieveSubMoney = calendarDataManager.allDayMoney[month - 1][day - 1]
        //tableviewの個数を渡す
        cell.recieveSubCategoryArray = calendarDataManager.recieveSubCategoryArray
    }
                                                            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 2, left: 2, bottom: 2, right: 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // ここの値を一番大きいセルの値にする
        let cellMaxHeight: CGFloat = 32 * 4
        let cellCount: CGFloat = 3
        let cellLabelHeight: CGFloat = 44 * 3
        let cellMargin: CGFloat = 10
        let cellMarginCount: CGFloat = cellCount
        
        // 一番大きいセルの値+カレンダー+余白でスクロールビューの高さを取得する
        viewHeightConstraint.constant = (calendarViewHeightConstraint.constant + cellMargin * cellMarginCount + cellMaxHeight * cellCount + cellLabelHeight)
        
        return CGSize(width: dateDiaryCollectionView.bounds.width / 3, height: cellMargin * cellMarginCount + cellMaxHeight * cellCount + cellLabelHeight - 10)
    }
}
//戻ったときに通知される処理
extension CalendarViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Modal画面から戻った際の画面の更新処理を行う。
        print("calendarViewを戻ってリロードするよ")
        self.dateDiaryCollectionView.reloadData()
    }
}
