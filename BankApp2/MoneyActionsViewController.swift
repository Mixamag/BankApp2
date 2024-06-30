//
//  Model.swift
//  BankApp
//
//  Created by Mikhail Gorbunov on 25.06.2024.
//

import UIKit
import RealmSwift

class MoneyActionsViewController: UIViewController {
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var sumTextField: UITextField!
    var realm: Realm!
    var balance: Balance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        balance = realm.objects(Balance.self).first
    }
    
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        guard let target = targetTextField.text,
              let sumText = sumTextField.text,
              let sum = Float(sumText) else { return }
        
        let transaction = Model()
        transaction.timeAndDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        transaction.sum = sum
        
        do {
                    try realm.write {
                        switch operationSegmentedControl.selectedSegmentIndex {
                        case 0:
                            transaction.operation = "Пополнение счета"
                            balance.amount += sum
                        case 1:
                            transaction.operation = "Снятие наличных"
                            if balance.amount >= sum {
                                            transaction.operation = "Снятие наличных"
                                            balance.amount -= sum
                                        } else {
                                            showAlert(message: "Недостаточно средств для снятия наличных.")
                                            return
                                        }
                        case 2:
                            transaction.operation = "Пополнение мобильного"
                            guard let target = targetTextField.text, !target.isEmpty else {
                                                    showAlert(message: "Пожалуйста, введите номер телефона для пополнения мобильного.")
                                                    return
                                                }
                            if balance.amount >= sum {
                                            transaction.operation = "Пополнение мобильного"
                                            balance.amount -= sum
                            if let target = targetTextField.text {
                                                   transaction.target = target
                                               }
                            } else {
                                            showAlert(message: "Недостаточно средств для пополнения мобильного.")
                                            return
                                        }
                        default:
                            break
                        }
                        realm.add(transaction)
                    }
                } catch let error {
                    print("Ошибка записи: \(error.localizedDescription)")
                }
                
                navigationController?.popViewController(animated: true)
            }
        
    func updateBalance(amount: Float) {
        try! realm.write {
            balance.amount += amount
        }
    }
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}
