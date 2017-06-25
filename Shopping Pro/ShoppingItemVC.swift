//
//  ShoppingItemVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase

class ShoppingItemVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var shoppingList:ShoppingList!
    
    var unboughtItem = [ShoppingItem]()
    var boughtItem = [ShoppingItem]()
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var itemsLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return unboughtItem.count
        } else {
            return boughtItem.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? myItemCell {
            
            var item:ShoppingItem!
            
            if indexPath.section == 0 {
                item = unboughtItem[indexPath.row]
            }else{
                item = boughtItem[indexPath.row]
            }
            cell.configureCell(item: item)
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    
    func loadItems() {

        FIRDatabaseRef.child(kSHOPPINGITEM).child(shoppingList.id).observe(.value) { (snapshot:DataSnapshot) in
            
            if snapshot.exists() {
                self.unboughtItem.removeAll()
                self.boughtItem.removeAll()
                
                let items = (snapshot.value as! NSDictionary).allValues as Array
                
                for item in items {
                    let shoppingItem = ShoppingItem(dictionary: item as! NSDictionary)
                    if shoppingItem.isBought {
                        self.boughtItem.append(shoppingItem)
                    }else{
                        self.unboughtItem.append(shoppingItem)
                    }
                }
                
                
            }
            self.myTableView.reloadData()
        }
    }
    
    //MARK: IBActions
    
    @IBAction func addBarBtnPrssd(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
        vc.shoppingList = self.shoppingList
        present(vc, animated: true, completion: nil)
    }
}
