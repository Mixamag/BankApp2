//
//  Model.swift
//  BankApp
//
//  Created by Mikhail Gorbunov on 25.06.2024.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var BalanceLabel: UILabel!
    
    var transactions: Results<Model>!
    var realm: Realm!
    var balance: Balance!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func reloadTransaction(_ sender: Any) {
        reload()
        updateBalanceLabel()
    }
    @IBAction func openMoneyActions(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let moneyActionsVC = storyboard.instantiateViewController(withIdentifier: "MoneyActionsViewController") as? MoneyActionsViewController {
                    self.present(moneyActionsVC, animated: true, completion: nil)
                    reload()
                    updateBalanceLabel()
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        realm = try! Realm()
        transactions = realm.objects(Model.self)
        
        
        if let existingBalance = realm.objects(Balance.self).first {
                    balance = existingBalance
        } else {
            balance = Balance()
            try! realm.write {
                realm.add(balance)
            }
        }
                    updateBalanceLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
        updateBalanceLabel()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let transaction = transactions[indexPath.row]
        
        cell.operationName.text = transaction.operation
        cell.targetLabel.text = transaction.target
        cell.sumLabel.text = "\(transaction.sum)"
        cell.dateLabel.text = transaction.timeAndDate
        switch transaction.operation {
        case "Пополнение счета":
            cell.backgroundColor = UIColor.green
        case "Снятие наличных":
            cell.backgroundColor = UIColor.red
        case "Пополнение баланса телефона":
            cell.backgroundColor = UIColor.blue
        default:
            break
        }
        
        return cell
    }
    
    func reload() {
        transactions = realm.objects(Model.self)
        tableView.reloadData()
    }
        func updateBalanceLabel() {
            BalanceLabel.text = "Баланс: \(balance.amount)"
            }
}

