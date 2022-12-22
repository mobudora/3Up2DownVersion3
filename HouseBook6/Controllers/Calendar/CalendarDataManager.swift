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
    
    func getDayCategoryData(currentCellMonth: String, currentCellYear: String) {
        print("1日分のカテゴリーデータが読み込まれるよ~~~~~~~~~~~~~~~")
        print("タップされた月は？？\(currentCellMonth)")
        print("タップされた年は？？\(currentCellYear)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
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
                guard let dayArray = recieveDayArray.monthDayArray else { return }
                print("dayArray: \(dayArray)")

                //日付毎のデータを取得
                self.dayMoneyFromFirestore(month: currentCellMonth, dayArray: dayArray, data: data)

                print("使用金額の取得に成功して代入しました。")
                print("最終的にcostMonthSuperCategoryArray: \(self.costMonthSuperCategoryArray)")
                print("最終的にallDaySuperCategoryName: \(self.allDaySuperCategoryName)")
                print("最終的にallDayMoney: \(self.allDayMoney)")
                print("最終的にallDaySubCategoryName: \(self.allDaySubCategoryName)")

            }
        }
    }
    //日付毎のデータを取得
    //dayArrayは入力された日付が格納されている
    //(例：10月)の親のカテゴリーの名前の配列をallDaySuperCategoryNameに格納する
    func dayMoneyFromFirestore(month: String, dayArray: [String], data: [String : Any]) {
        guard let intMonth = Int(month) else { return }
        for day in dayArray {
            //支出の親カテゴリー配列の初期化？
            costMonthSuperCategoryArray = []

            switch day {
            case "1":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 1)
                //すでに入っているallDaySuperCategoryNameを取り除いて重複しないように追加する
                allDaySuperCategoryName[intMonth].remove(at: 0)
                //新しいallDaySuperCategoryNameを追加
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 0)
            case "2":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 2)
                allDaySuperCategoryName[intMonth].remove(at: 1)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 1)
            case "3":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 3)
                allDaySuperCategoryName[intMonth].remove(at: 2)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 2)
            case "4":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 4)
                allDaySuperCategoryName[intMonth].remove(at: 3)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 3)
            case "5":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 5)
                allDaySuperCategoryName[intMonth].remove(at: 4)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 4)
            case "6":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 6)
                allDaySuperCategoryName[intMonth].remove(at: 5)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 5)
            case "7":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 7)
                allDaySuperCategoryName[intMonth].remove(at: 6)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 6)
            case "8":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 8)
                allDaySuperCategoryName[intMonth].remove(at: 7)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 7)
            case "9":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 9)
                allDaySuperCategoryName[intMonth].remove(at: 8)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 8)
            case "10":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 10)
                allDaySuperCategoryName[intMonth].remove(at: 9)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 9)
            case "11":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 11)
                allDaySuperCategoryName[intMonth].remove(at: 10)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 10)
            case "12":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 12)
                allDaySuperCategoryName[intMonth].remove(at: 11)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 11)
            case "13":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 13)
                allDaySuperCategoryName[intMonth].remove(at: 12)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 12)
            case "14":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 14)
                allDaySuperCategoryName[intMonth].remove(at: 13)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 13)
            case "15":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 15)
                allDaySuperCategoryName[intMonth].remove(at: 14)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 14)
            case "16":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 16)
                allDaySuperCategoryName[intMonth].remove(at: 15)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 15)
            case "17":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 17)
                allDaySuperCategoryName[intMonth].remove(at: 16)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 16)
            case "18":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 18)
                allDaySuperCategoryName[intMonth].remove(at: 17)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 17)
            case "19":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 19)
                allDaySuperCategoryName[intMonth].remove(at: 18)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 18)
            case "20":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 20)
                allDaySuperCategoryName[intMonth].remove(at: 19)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 19)
            case "21":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 21)
                allDaySuperCategoryName[intMonth].remove(at: 20)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 20)
            case "22":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 22)
                allDaySuperCategoryName[intMonth].remove(at: 21)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 21)
            case "23":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 23)
                allDaySuperCategoryName[intMonth].remove(at: 22)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 22)
            case "24":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 24)
                allDaySuperCategoryName[intMonth].remove(at: 23)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 23)
            case "25":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 25)
                allDaySuperCategoryName[intMonth].remove(at: 24)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 24)
            case "26":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 26)
                allDaySuperCategoryName[intMonth].remove(at: 25)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 25)
            case "27":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 27)
                allDaySuperCategoryName[intMonth].remove(at: 26)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 26)
            case "28":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 28)
                allDaySuperCategoryName[intMonth].remove(at: 27)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 27)
            case "29":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 29)
                allDaySuperCategoryName[intMonth].remove(at: 28)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 28)
            case "30":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 30)
                allDaySuperCategoryName[intMonth].remove(at: 29)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 29)
            case "31":
                getSuperCategoryName(data: data, month: month, day: day, dayNum: 31)
                allDaySuperCategoryName[intMonth].remove(at: 30)
                allDaySuperCategoryName[intMonth].insert(costMonthSuperCategoryArray, at: 30)
            default:
                break
            }
        }
    }
    //親カテゴリーの名前をゲットする
    //tableviewのcellの数を決めるための関数
    func getSuperCategoryName(data: [String : Any], month: String, day: String, dayNum: Int) {
        //見ていたり、選択した月
        guard let intMonth = Int(month) else { return }
        //重複を避けるために初期化
        allDayMoney[intMonth][dayNum - 1] = []
        allDaySubCategoryName[intMonth][dayNum - 1] = []
        //(例：10月10日)に入っている親カテゴリー(服飾)名前配列を取得
        let recieveDaySuperCategoryNameArray = DaySuperCategoryArrayFromFireStore.init(dic: data, month: month, day: day)
        guard let daySuperCategoryNameArray = recieveDaySuperCategoryNameArray.daySuperCategoryNameArray else { return }
        print("(例：\(month)月\(day)日)に入っている親カテゴリー名前daySuperCategoryNameArray: \(daySuperCategoryNameArray)")
        for daySuperCaegoryName in daySuperCategoryNameArray {
            //親カテゴリー(服飾)名前を元に(例：10月10日)に入っているサブカテゴリー名前配列を取得
            let recieveDaySubCategoryArray = DaySubCategoryArrayFromFireStore.init(dic: data, month: month, superCategoryName: daySuperCaegoryName, day: day)
            guard let daySubCategoryNameArray = recieveDaySubCategoryArray.daySubCategoryNameArray else { return }
            print("(例：10月10日)に入っているサブカテゴリー名前配列daySubCategoryNameArray: \(daySubCategoryNameArray)")
            //サブカテゴリーの個数を格納する→tableviewの個数になる
            //allDaySubCategoryNameにFirestoreからとってきたサブカテゴリーの名前が入る(今回は10月10日の服飾のサブカテゴリー)
            allDaySubCategoryName[intMonth][dayNum - 1].append(daySubCategoryNameArray)
            print("重複を整える前のallDaySubCategoryName:\(allDaySubCategoryName)")
            //NSOrderedSetで重複した値を削除する
            let orderedSet:NSOrderedSet = NSOrderedSet(array: allDaySubCategoryName[intMonth][dayNum - 1])
            allDaySubCategoryName[intMonth][dayNum - 1] = orderedSet.array as! [[String]]

            print("綺麗に重複を整理したallDaySubCategoryName:\(allDaySubCategoryName)")
            //tableviewのcellの数を決めるために10月10日のサブカテゴリーをrecieveSubCategoryArrayに追加する
            recieveSubCategoryArray.append(contentsOf: daySubCategoryNameArray)
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
            for dayId in daySubCategoryIdArray {
                //dayId配列をもとに日にち毎のお金を取得
                let recieveDaySubCategoryMoney = DaySubCategoryMoneyFromFireStore.init(dic: data, month: month, day: day, subCategoryName: daySubCaegoryName, dayId: dayId)
                guard let dayMoney = recieveDaySubCategoryMoney.daySubCategoryMoney else { return }
                //サブカテゴリーをどんどん入れていい理由は表示するときに親カテゴリーで分けられているからそのまま配列の順番で表示する
                //サブカテゴリー
                print("daySubCaegoryName: \(daySubCaegoryName)")
                //日にち毎のお金を格納
                dayMoneyArray.append(dayMoney)
                //サブカテゴリーに対応するお金
                print("dayMoney:\(dayMoney)")
            }
        }
        print("\(month)月\(day)日のdayMoneyArray:\(dayMoneyArray)")
        //1~31日までのデータを格納していく　配列に対応するために-1
        //サブカテゴリーの名前配列と一緒の数にする
        if allDayMoney[intMonth][dayNum - 1].count < allDaySubCategoryName[intMonth][dayNum - 1].count {
            allDayMoney[intMonth][dayNum - 1].append(dayMoneyArray)
            
            print("allDaySubCategoryName[intMonth][dayNum - 1].count:\(allDaySubCategoryName[intMonth][dayNum - 1].count)")
            print("allDayMoney[intMonth][dayNum - 1].count:\(allDayMoney[intMonth][dayNum - 1].count)")
        }
        
        print("代入した後allDayMoney:\(allDayMoney)")
    }

}
