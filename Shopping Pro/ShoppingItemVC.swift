//
//  ShoppingItemVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase
import SwipeCellKit
import KRProgressHUD

class ShoppingItemVC: UIViewController,UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate,SearchVCDelegate {
    
    
    var shoppingList:ShoppingList!
    var unboughtItem = [ShoppingItem]()
    var boughtItem = [ShoppingItem]()
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = true
    var totaPrice:Float = 0
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
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
            
            
            cell.delegate = self
            cell.selectedBackgroundView = createSelectedBacgroundView()
            
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
        vc.shoppingList = self.shoppingList
        
        if indexPath.section == 0 {
            vc.shoppingItem = unboughtItem[indexPath.row]
        }else{
            vc.shoppingItem = boughtItem[indexPath.row]
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title1:String!
        
        if section == 0 {
            title1 = "Unbought Items"
        }else{
            title1 = "Bought Items"
        }
        return headerForView(title1: title1)
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    func headerForView(title1:String)->UIView {
        
        
        let view = UIView()
        
        view.backgroundColor = UIColor.darkGray
        
        let titleLbl = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 20))
        
        titleLbl.text = title1
        
        titleLbl.textColor = UIColor.white
        
        view.addSubview(titleLbl)
        
        return view
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
            self.calculateTotal()
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        
        let currency = userDefaults.value(forKey: kCURRENCY) as! String
        self.itemsLabel.text = "Items Left: \(self.unboughtItem.count)"
        totalPriceLabel.text = "Total Price: \(currency)\(String(format: "%.2f", totaPrice))"
        
        self.myTableView.reloadData()
        
        
    }
    
    
    
    
    func calculateTotal() {
        totaPrice = 0
        for item in unboughtItem {
            totaPrice += item.price
        }
        for item in boughtItem {
            totaPrice += item.price
        }
        shoppingList.totalPrice = self.totaPrice
        shoppingList.totalItems = unboughtItem.count + boughtItem.count
        
        shoppingList.updateItemInBackground(shoppingList: shoppingList) { (error:Error?) in
            if error != nil {
                KRProgressHUD.showError(withMessage: "Error occured while saving")
                return
            }
        }
    }
    
    
    
    
    
    
    //MARK: IBActions
    
    @IBAction func addBarBtnPrssd(_ sender: Any) {
        
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addItem = UIAlertAction(title: "Add a new Item", style: .default) { (alert:UIAlertAction) in
            //show camera
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
            vc.shoppingList = self.shoppingList
            vc.addItemToList = false
            self.present(vc, animated: true, completion: nil)
            
        }
        let searchItem = UIAlertAction(title: "Search an Item", style: .default) { (alert:UIAlertAction) in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            vc.delegate = self
            vc.clickToEdit = false
            self.present(vc, animated: true, completion: nil)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert:UIAlertAction) in
        }
        
        optionMenu.addAction(addItem)
        optionMenu.addAction(searchItem)
        optionMenu.addAction(cancel)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    
    
    //MARK: SwipeCelldelegateFunctions
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var item:ShoppingItem!
        
        if indexPath.section == 0 {
            item = unboughtItem[indexPath.row]
        }else{
            item = boughtItem[indexPath.row]
        }
        
        if orientation == .left {
            guard isSwipeRightEnabled else {
                return nil
            }
            
             let buyItem = SwipeAction(style: .default, title: nil) { action, indexPath in
            
            item.isBought = !item.isBought
            item.updateItemInBackground(shoppingItem: item, completion: { (error) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error occured while saving")
                }
            })
            
            if indexPath.section == 0 {
                self.unboughtItem.remove(at: indexPath.row)
                self.boughtItem.append(item)
            }else{
                self.unboughtItem.append(item)
                self.boughtItem.remove(at: indexPath.row)
            }
         self.myTableView.reloadData()
        }
            
            buyItem.accessibilityLabel = item.isBought ? "Buy" : "Return"
            let descriptor: ActionDescriptor = item.isBought ?.returnPurchase : .buy
            
            configure(action: buyItem, with: descriptor)
            
            return [buyItem]
        } else {
            
            let delete = SwipeAction(style: .destructive, title: nil, handler: { (action, indexPath) in
                
                
                if indexPath.section == 0 {
                    self.unboughtItem.remove(at: indexPath.row)
                }else{
                    self.boughtItem.remove(at: indexPath.row)
                }
                
                item.deleteItemInBackgroud(shoppingItem: item)
                
                self.myTableView.beginUpdates()
                action.fulfill(with: .delete)
                self.myTableView.endUpdates()
            })
            
            
            configure(action: delete, with: .trash)
            
            
            return [delete]
        }
    }
    
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color
    }

    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 11
        return options
        
    }
    
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation) {
        
    }
    
    func didChooseItem(item: GroceryItem) {
        
        let shoppingItem = ShoppingItem(groceryItem: item)
        shoppingItem.shoppingListId = self.shoppingList.id
        shoppingItem.saveItemsInBackground(shoppingItem: shoppingItem) { (error:Error?) in
            if error != nil {
                KRProgressHUD.showError(withMessage: "Error occured while loading your item")
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
}
