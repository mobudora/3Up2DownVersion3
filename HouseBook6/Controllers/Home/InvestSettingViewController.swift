//
//  InvestSettingViewController.swift
//  HouseBook6
//
//  Created by ドラ on 2023/02/02.
//

import UIKit

class InvestSettingViewController: UIViewController {

    @IBOutlet weak var speciesOfInvestTextField: UITextField!
    @IBAction func speciesOfInvestTextFieldAction(_ sender: Any) {
        print("入力された値: \(speciesOfInvestTextField.text)")
    }
    
    @IBOutlet weak var capitalInvestMoneyTextField: UITextField!
    @IBAction func capitalInvestMoneyTextFieldAction(_ sender: Any) {
        print("入力された値: \(capitalInvestMoneyTextField.text)")
    }
    @IBOutlet weak var paymentInvestTextField: UITextField!
    @IBAction func paymentInvestTextFieldAction(_ sender: Any) {
        print("入力された値: \(paymentInvestTextField.text)")
    }
    
    @IBOutlet weak var addInvestContentsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addInvestContentButtonSetUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addInvestContentButtonSetUp() {
        addInvestContentsButton.layer.cornerRadius = 10
        addInvestContentsButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        addInvestContentsButton.layer.shadowColor = UIColor.gray.cgColor
        addInvestContentsButton.layer.shadowOpacity = 0.2
    }

}
