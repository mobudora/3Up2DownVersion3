//
//  dateDiaryCollectionViewCell.swift
//  HouseBook6
//
//  Created by Ryu on 2022/04/22.
//

import UIKit

class dateDiaryCollectionViewCell: UICollectionViewCell {

    //contentCellのSuperCategoryNameを受け取る変数
    var recieveSuperCategoryName: [String]?
    //1日毎のsubcategorynameを格納している"\(month)\(day)\(superCategoryName)配列"
    var recieveSubCategoryName: [[String]]?
    var recieveSubMoney: [[Int]]?
    var recieveSubCategoryArray: [String]?

    //delegateを受け取る変数
    var recieveDelegate: CalendarViewController?

    //コレクションの日にちを受け取る変数
    var currentCellDay: String!
    //コレクションの月を受け取る変数
    var currentCellMonth: String!

    var countUpForTableView = 0

    //カテゴリーの数
    var categoryCount: Int = 1
    
    //日付と曜日が書かれている一番上のLabel
    @IBOutlet weak var tableH1Label: UILabel!
    //内容・金額の横並びのStackView
    @IBOutlet weak var tableH2HorizontalStackView: UIStackView!
    //内容・金額の詳細が書かれているCollectionView
    @IBOutlet weak var dateCategoryCollectionView: UICollectionView!
    //その日の合計Button
    @IBOutlet weak var dateCostSumAmountButton: UIButton!
    @IBAction func dateCostSUmAmountButtonAction(_ sender: Any) {
        var sumSubCategoryMoney: [Int] = []
        //nill回避の[[0]]
        for subCategoryMoney in recieveSubMoney ?? [[0]] {
            //recieveSubMoneyはサブカテゴリーの合計金額を親カテゴリー毎に持っている？
            //例：親[食費]サブ[合計金額],親[服飾]サブ[合計金額]
            //合計金額を初期値0としてsumSubCategoryMoney配列に追加している
            sumSubCategoryMoney.append(subCategoryMoney.reduce(0, +))
        }
        //追加された合計金額の配列を全て足して、sumSubCategoryMoneyPerDayに代入
        let sumSubCategoryMoneyPerDay = sumSubCategoryMoney.reduce(0, +)
        dateCostSumAmountLabel.text = String(sumSubCategoryMoneyPerDay)
    }
    //その日の支出合計Label
    @IBOutlet weak var dateCostSumAmountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        dateCategoryCollectionView.delegate = self
        dateCategoryCollectionView.dataSource = self

        dateCategoryCollectionView.register(UINib(nibName: "DateContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DateContentCell")
        print("🔷categoryCollectionViewを通ったよ")
    }

}

extension dateDiaryCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //ここでカテゴリーの入力が増えたらコレクションを増やす(大元のコレクション)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //ここでカテゴリーの数が増えたら数値を増やす
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dateCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "DateContentCell", for: indexPath) as! DateContentCollectionViewCell
        //親カテゴリーの名前、サブカテゴリーの名前、サブカテゴリーのお金を表示するcellに渡す
        getPerDayCategoryNameAndMoney(cell: cell, indexPath: indexPath)
        //合計金額の計算
        sumCategoryMoneySetUp()
        //MARK: リロード
        print("🟥一番下の層をリロード")
        cell.dateContentTableView.reloadData()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellMaxHeight: CGFloat = 32 * 4
        let cellCount: CGFloat = 1
        let cellMargin: CGFloat = 10
        let cellMarginCount: CGFloat = cellCount

        return CGSize(width: dateCategoryCollectionView.bounds.width, height: cellMaxHeight * cellCount + cellMargin * cellMarginCount)
    }
    func getPerDayCategoryNameAndMoney(cell: DateContentCollectionViewCell, indexPath: IndexPath) {
        cell.recieveIndexPath = indexPath.row
        //日毎の親カテゴリーNameを渡す
        cell.recieveSuperCategoryNamePerDay = recieveSuperCategoryName
        cell.recieveSubCategoryNamePerDay = recieveSubCategoryName
        cell.recieveSubMoneyPerDay = recieveSubMoney
        //tablevoewの個数を渡す
        cell.recieveSubCategoryArray = recieveSubCategoryArray
        //月を渡す
        cell.currentCellMonth = currentCellMonth
    }
    func sumCategoryMoneySetUp() {
        var sumSubCategoryMoney: [Int] = []
        for subCategoryMoney in recieveSubMoney ?? [[0]] {
            sumSubCategoryMoney.append(subCategoryMoney.reduce(0, +))
        }
        let sumSubCategoryMoneyPerDay = sumSubCategoryMoney.reduce(0, +)
        dateCostSumAmountLabel.text = String(sumSubCategoryMoneyPerDay)
    }
}
