//
//  LibraryCalendarModel.swift
//  HouseBook6
//
//  Created by ドラ on 2022/12/18.
//

import Foundation
import Firebase

class CalendarDataManager {
    //データベースのインスタンス化
    let db = Firestore.firestore()
    
    var costMonthSuperCategoryArray: [String] = []
    //親カテゴリーアイコンImageを月と日付毎に持っておく
    var allDaySuperCategoryName: [[[String]]] = [[[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    ]
    //日付毎に要素番号と関連してデータを持っておく
    var allDayMoney: [[[[Int]]]] = [[[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    ]
    var allDaySubCategoryName: [[[[String]]]] = [                   [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
                                                                    [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    ]
    
    //cellのtableviewのcell数を決める配列(10月10日のサブカテゴリーの数が入る)
    var recieveSubCategoryArray: [String] = []
    
    //サブカテゴリーの重複を避ける
    var superCategoryNameArray: [String] = []
    
    //お金の重複を避ける
    var daySubCategoryNameArray: [String] = []
    
    func getDayCategoryData(currentCellMonth: String, currentCellYear: String, cell: dateDiaryCollectionViewCell) {
        print("🔶1日分のカテゴリーデータが読み込まれるよ")
        print("タップされた月は？？\(currentCellMonth)")
        print("タップされた年は？？\(currentCellYear)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("uid\(uid)")
        //タップしたところの年の情報
        let year = currentCellYear
        //引数はletだからvarに変換
        var currentCellMonth = currentCellMonth
        //やること：12月16日(完了していない)
        //1.Firestoreから読み取るyearが年を跨ぐときに読み取れない
        //2.yearをタップしたカレンダーの情報にする
        db.collection("\(year)subCategoryIncomeAndExpenditure").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("使用金額の取得に失敗しました。\(err)")
                return
            } else {
                //データの受け取り
                guard let data = snapshot?.data() else { return }
                print("受け取ったdata: \(data)")
                //Firestoreを読み取る際に0をつけないと読み取れない
                switch currentCellMonth {
                case "1":
                    currentCellMonth = "0\(currentCellMonth)"
                case "2":
                    currentCellMonth = "0\(currentCellMonth)"
                case "3":
                    currentCellMonth = "0\(currentCellMonth)"
                case "4":
                    currentCellMonth = "0\(currentCellMonth)"
                case "5":
                    currentCellMonth = "0\(currentCellMonth)"
                case "6":
                    currentCellMonth = "0\(currentCellMonth)"
                case "7":
                    currentCellMonth = "0\(currentCellMonth)"
                case "8":
                    currentCellMonth = "0\(currentCellMonth)"
                case "9":
                    currentCellMonth = "0\(currentCellMonth)"
                default:
                    break
                }
                print("読み取った月currentCellMonth: \(currentCellMonth)")
                //入力されている日付を取得
                //dic["\(month)Day配列"]をとってきている→入力されている日付
                let recieveDayArray = DayArrayFromFireStore.init(dic: data, month: currentCellMonth)
                print("受け取った月の日付の配列recieveDayArray: \(recieveDayArray)")
                //nilをチェック早期リターン
                //その月のday配列
                guard let dayArray = recieveDayArray.monthDayArray else { return }
                print("dayArray: \(dayArray)")
                
                //日付毎のデータを取得
                self.dayMoneyFromFirestore(month: currentCellMonth, dayArray: dayArray, data: data)
            }
        }
    }
    //日付毎のデータを取得
    //dayArrayは入力された日付が格納されている
    //(例：10月)の親のカテゴリーの名前の配列をallDaySuperCategoryNameに格納する
    func dayMoneyFromFirestore(month: String, dayArray: [String], data: [String : Any]) {
        for day in dayArray {
            //支出の親カテゴリー配列の初期化？
            costMonthSuperCategoryArray = []
            perDayAndMonthGetSuperCategoryName(data: data, month: month, day: day, dayNum: Int(day) ?? 0)
        }
    }
    func perDayAndMonthGetSuperCategoryName(data: [String: Any], month: String, day: String, dayNum: Int) {
        //配列で使うために01のStringを1に変換
        //Stringをintに変換したら01の0が消える
        guard let intMonth = Int(month) else { return }
        //親カテゴリーの名前をゲットする
        //tableviewのcellの数を決めるための関数
        getSuperCategoryName(data: data, month: month, day: day, dayNum: dayNum)
        //すでに入っているallDaySuperCategoryNameを取り除いて重複しないように追加する
        allDaySuperCategoryName[intMonth - 1].remove(at: dayNum-1)
        //新しいallDaySuperCategoryNameを追加
        allDaySuperCategoryName[intMonth - 1].insert(costMonthSuperCategoryArray, at: dayNum-1)
    }
    //MARK: 親カテゴリーから1日分のサブカテゴリーを読み取る
    func getSuperCategoryName(data: [String : Any], month: String, day: String, dayNum: Int) {
        guard let intMonth = Int(month) else { return }
        //一日毎に初期化しないと、superCategoryNameArrayに10日、11日...とどんどん溜まっていく
        superCategoryNameArray = []
        //重複を避けるために初期化
        allDayMoney[intMonth][dayNum - 1] = []
        allDaySubCategoryName[intMonth][dayNum - 1] = []
        //(例：10月10日)に入っている親カテゴリー(服飾)名前配列を取得
        let recieveDaySuperCategoryNameArray = DaySuperCategoryArrayFromFireStore.init(dic: data, month: month, day: day)
        print("🔷recieveDaySuperCategoryNameArray\(recieveDaySuperCategoryNameArray)")
        guard let daySuperCategoryNameArray = recieveDaySuperCategoryNameArray.daySuperCategoryNameArray else { return }
        print("(例：\(month)月\(day)日)に入っている親カテゴリー名前daySuperCategoryNameArray: \(daySuperCategoryNameArray)")
        for daySuperCaegoryName in daySuperCategoryNameArray {
            //親カテゴリー(服飾)名前を元に(例：10月10日)に入っているサブカテゴリー名前配列を取得
            let recieveDaySubCategoryArray = DaySubCategoryArrayFromFireStore.init(dic: data, month: month, superCategoryName: daySuperCaegoryName, day: day)
            guard let daySubCategoryNameArray = recieveDaySubCategoryArray.daySubCategoryNameArray else { return }
            print("(例：\(month)月\(day)日))に入っているサブカテゴリー名前配列daySubCategoryNameArray: \(daySubCategoryNameArray)")
            //サブカテゴリーの個数を格納する→tableviewの個数になる
            //allDaySubCategoryNameにFirestoreからとってきたサブカテゴリーの名前が入る(今回は10月10日の服飾のサブカテゴリー)
            print("追加する前のallDaySubCategoryName:\(self.allDaySubCategoryName)")
            
            //サブカテゴリーの重複を避けるために追加
            superCategoryNameArray.append(daySuperCaegoryName)
            var countUp = 0
            if allDaySubCategoryName[intMonth - 1][dayNum - 1] != [] {
                print("🔷superCategoryNameArray\(superCategoryNameArray)")
                superCategoryNameArray.forEach {
                    superCategoryName in
                    if superCategoryName == daySuperCaegoryName {
                        print("🟩削除する前\(allDaySubCategoryName[intMonth - 1][dayNum - 1])")
                        self.allDaySubCategoryName[intMonth - 1][dayNum - 1].remove(at: countUp)
                        print("🟩削除した後\(allDaySubCategoryName[intMonth - 1][dayNum - 1])")
                        self.allDaySubCategoryName[intMonth - 1][dayNum - 1].insert(daySubCategoryNameArray, at: countUp)
                    } else {
                        self.allDaySubCategoryName[intMonth - 1][dayNum - 1].append(daySubCategoryNameArray)
                    }
                    countUp += 1
                }
            } else {
                self.allDaySubCategoryName[intMonth - 1][dayNum - 1].append(daySubCategoryNameArray)
            }
            print("重複を整える前のallDaySubCategoryName:\(self.allDaySubCategoryName)")
            //NSOrderedSetで重複した値を削除する
            let orderedSet:NSOrderedSet = NSOrderedSet(array: self.allDaySubCategoryName[intMonth - 1][dayNum - 1])
            allDaySubCategoryName[intMonth - 1][dayNum - 1] = orderedSet.array as! [[String]]
            print("綺麗に重複を整理したallDaySubCategoryName:\(allDaySubCategoryName)")
            //tableviewのcellの数を決めるために10月10日のサブカテゴリーをrecieveSubCategoryArrayに追加する
            recieveSubCategoryArray.append(contentsOf: daySubCategoryNameArray)
            //お金をFirestoreにとりにいく
            getDayMoney(daySubCategoryNameArray: daySubCategoryNameArray, data: data, month: month, day: day, dayNum: dayNum)
            switch daySuperCaegoryName {
            case "食費":
                // ???: daySubCategoryArrayは何のためにある？
                costMonthSuperCategoryArray.append("食費")
            case "日用品":
                costMonthSuperCategoryArray.append("日用品")
            case "服飾":
                costMonthSuperCategoryArray.append("服飾")
            case "健康":
                costMonthSuperCategoryArray.append("健康")
            case "交際":
                costMonthSuperCategoryArray.append("交際")
            case "趣味":
                costMonthSuperCategoryArray.append("趣味")
            case "教養":
                costMonthSuperCategoryArray.append("教養")
            case "交通":
                costMonthSuperCategoryArray.append("交通")
            case "美容":
                costMonthSuperCategoryArray.append("美容")
            case "観光":
                costMonthSuperCategoryArray.append("観光")
            case "車":
                costMonthSuperCategoryArray.append("車")
            case "バイク":
                costMonthSuperCategoryArray.append("バイク")
            case "通信":
                costMonthSuperCategoryArray.append("通信")
            case "水道代":
                costMonthSuperCategoryArray.append("水道代")
            case "ガス代":
                costMonthSuperCategoryArray.append("ガス代")
            case "電気代":
                costMonthSuperCategoryArray.append("電気代")
            case "保険":
                costMonthSuperCategoryArray.append("保険")
            case "税金":
                costMonthSuperCategoryArray.append("税金")
            case "住宅":
                costMonthSuperCategoryArray.append("住宅")
            case "医療":
                costMonthSuperCategoryArray.append("医療")
            case "ペット":
                costMonthSuperCategoryArray.append("ペット")
            default:
                break
                
            }
        }
    }
    //親カテゴリーによって格納する配列を変えていく
    //10月10日のお金の配列をとりに行く
    func getDayMoney(daySubCategoryNameArray: [String], data: [String : Any], month: String, day: String, dayNum: Int) {
        guard let intMonth = Int(month) else { return }
        print("\(month)月\(day)日のサブカテゴリー名前配列daySubCategoryNameArray:\(daySubCategoryNameArray)")
        var dayMoneyArray: [Int] = []
        for daySubCaegoryName in daySubCategoryNameArray {
            //サブカテゴリー名前をもとにdayId配列を取得
            let recieveDaySubCategoryId = DayIdArrayFromFireStore.init(dic: data, month: month, day: day, subCategoryName: daySubCaegoryName)
            guard let daySubCategoryIdArray = recieveDaySubCategoryId.daySubCategoryIdArray else { return }
            print("\(month)月\(day)日のdaySubCategoryIdArray: \(daySubCategoryIdArray)")
            //重複したサブカテゴリーの料金を足して1つにする
            if daySubCategoryIdArray.count >= 2 {
                var dayMoneyStock: Int = 0
                for dayId in daySubCategoryIdArray {
                    //dayId配列をもとに日にち毎のお金を取得
                    let recieveDaySubCategoryMoney = DaySubCategoryMoneyFromFireStore.init(dic: data, month: month, day: day, subCategoryName: daySubCaegoryName, dayId: dayId)
                    guard let dayMoney = recieveDaySubCategoryMoney.daySubCategoryMoney else { return }
                    //サブカテゴリーをどんどん入れていい理由は表示するときに親カテゴリーで分けられているからそのまま配列の順番で表示する
                    //サブカテゴリー
                    print("daySubCaegoryName: \(daySubCaegoryName)")
                    dayMoneyStock += dayMoney
                    //サブカテゴリーに対応するお金
                    print("dayMoney:\(dayMoney)")
                    print("dayMoneyStock:\(dayMoneyStock)")
                }
                print("🟩dayMoneyArray\(dayMoneyArray)")
                dayMoneyArray.append(dayMoneyStock)
                self.daySubCategoryNameArray.append(daySubCaegoryName)
            } else {
                for dayId in daySubCategoryIdArray {
                    //dayId配列をもとに日にち毎のお金を取得
                    let recieveDaySubCategoryMoney = DaySubCategoryMoneyFromFireStore.init(dic: data, month: month, day: day, subCategoryName: daySubCaegoryName, dayId: dayId)
                    guard let dayMoney = recieveDaySubCategoryMoney.daySubCategoryMoney else { return }
                    //サブカテゴリーをどんどん入れていい理由は表示するときに親カテゴリーで分けられているからそのまま配列の順番で表示する
                    //サブカテゴリー
                    print("daySubCaegoryName: \(daySubCaegoryName)")
                    //サブカテゴリーに対応するお金
                    print("dayMoney:\(dayMoney)")
                    //日にち毎のお金を格納
                    dayMoneyArray.append(dayMoney)
                    self.daySubCategoryNameArray.append(daySubCaegoryName)
                }
            }
        }
        //MARK: 1日のお金を追加する
        //とりあえず追加
        if allDayMoney[intMonth - 1][dayNum - 1].count < allDaySubCategoryName[intMonth - 1][dayNum - 1].count {
            allDayMoney[intMonth - 1][dayNum - 1].append(dayMoneyArray)
        }
        
        print("\(month)月\(day)日のdayMoneyArray:\(dayMoneyArray)")
        print("🟥allDaySubCategoryName[intMonth][dayNum - 1]:\(allDaySubCategoryName[intMonth - 1][dayNum - 1])")
        print("🟥allDayMoney[intMonth][dayNum - 1]:\(allDayMoney[intMonth - 1][dayNum - 1])")
        print("🟥allDaySubCategoryName[intMonth][dayNum - 1].count:\(allDaySubCategoryName[intMonth - 1][dayNum - 1].count)")
        print("🟥allDayMoney[intMonth][dayNum - 1].count:\(allDayMoney[intMonth - 1][dayNum - 1].count)")
        
        //同じサブカテゴリーを追加した時のためにこのコードが必要
        //重なった部分を削除して追加する
        if allDaySubCategoryName[intMonth - 1][dayNum - 1] != [] && allDayMoney[intMonth - 1][dayNum - 1] != [] {
            var countUp = 0
            allDaySubCategoryName[intMonth - 1][dayNum - 1].forEach { subCategoryNameArray in
                print("🔷\(subCategoryNameArray)")
                //名前で削除するアイデア！
                if daySubCategoryNameArray == subCategoryNameArray {
                    print("🟩削除する前\(allDayMoney[intMonth - 1][dayNum - 1])")
                    allDayMoney[intMonth - 1][dayNum - 1].remove(at: countUp)
                    allDayMoney[intMonth - 1][dayNum - 1].insert(dayMoneyArray, at: countUp)
                    print("🟩追加した後\(allDayMoney[intMonth - 1][dayNum - 1])")
                }
                countUp += 1
            }
        }
        //NSOrderedSetで重複した値を削除する
        let orderedSet:NSOrderedSet = NSOrderedSet(array: self.allDayMoney[intMonth - 1][dayNum - 1])
        allDayMoney[intMonth - 1][dayNum - 1] = orderedSet.array as! [[Int]]
        //1~31日までのデータを格納していく　配列に対応するために-1
        //サブカテゴリーの名前配列と一緒の数にする
        print("代入した後allDayMoney:\(allDayMoney)")
    }
    
}
