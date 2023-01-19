//
//  Income.swift
//  HouseBook6
//
//  Created by Ryu on 2022/05/13.
//

import Foundation
import Firebase

//受け取ったカテゴリー情報の整理
struct IncomeFromFirestore {

    //給料のお金を格納する
    let salaryMoneyFromFirestore: Int!
    let salaryIncomeSubCategoryArrayFromFirestore: [String]!
    //副業のお金を格納する
    let sideBusinessMoneyFromFirestore: Int!
    let sideBusinessIncomeSubCategoryArrayFromFirestore: [String]!
    //臨時収入のお金を格納する
    let extraordinaryMoneyFromFirestore: Int!
    let extraordinaryIncomeSubCategoryArrayFromFirestore: [String]!
    //投資のお金を格納する
    let investmentMoneyFromFirestore: Int!
    let investmentIncomeSubCategoryArrayFromFirestore: [String]!
    //賞のお金を格納する
    let prizeMoneyFromFirestore: Int!
    let prizeIncomeSubCategoryArrayFromFirestore: [String]!

    //ここで受け取った情報を上記の変数に代入する
    init(dic: [String: Any], month: Int){
        if month == 1 || month == 2 || month == 3 || month == 4 || month == 5 || month == 6 || month == 7 || month == 8 || month == 9 {
            self.salaryMoneyFromFirestore = dic["0\(month)給料SumMoney"] as! Int?
            self.salaryIncomeSubCategoryArrayFromFirestore = dic["0\(month)給料配列"] as! [String]?
            self.sideBusinessMoneyFromFirestore = dic["0\(month)副業SumMoney"] as! Int?
            self.sideBusinessIncomeSubCategoryArrayFromFirestore = dic["0\(month)副業配列"] as! [String]?
            self.extraordinaryMoneyFromFirestore = dic["0\(month)臨時収入SumMoney"] as! Int?
            self.extraordinaryIncomeSubCategoryArrayFromFirestore = dic["0\(month)臨時収入配列"] as! [String]?
            self.investmentMoneyFromFirestore = dic["0\(month)投資SumMoney"] as! Int?
            self.investmentIncomeSubCategoryArrayFromFirestore = dic["0\(month)投資配列"] as! [String]?
            self.prizeMoneyFromFirestore = dic["0\(month)賞SumMoney"] as! Int?
            self.prizeIncomeSubCategoryArrayFromFirestore = dic["0\(month)賞配列"] as! [String]?
        } else {
            self.salaryMoneyFromFirestore = dic["0\(month)給料SumMoney"] as! Int?
            self.salaryIncomeSubCategoryArrayFromFirestore = dic["0\(month)給料配列"] as! [String]?
            self.sideBusinessMoneyFromFirestore = dic["0\(month)副業SumMoney"] as! Int?
            self.sideBusinessIncomeSubCategoryArrayFromFirestore = dic["0\(month)副業配列"] as! [String]?
            self.extraordinaryMoneyFromFirestore = dic["0\(month)臨時収入SumMoney"] as! Int?
            self.extraordinaryIncomeSubCategoryArrayFromFirestore = dic["0\(month)臨時収入配列"] as! [String]?
            self.investmentMoneyFromFirestore = dic["0\(month)投資SumMoney"] as! Int?
            self.investmentIncomeSubCategoryArrayFromFirestore = dic["0\(month)投資配列"] as! [String]?
            self.prizeMoneyFromFirestore = dic["0\(month)賞SumMoney"] as! Int?
            self.prizeIncomeSubCategoryArrayFromFirestore = dic["0\(month)賞配列"] as! [String]?
        }
    }
}
