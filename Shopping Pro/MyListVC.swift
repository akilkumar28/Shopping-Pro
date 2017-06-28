//
//  MyListVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import KRProgressHUD
import Firebase
import SwipeCellKit

class MyListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate {
    
    
    
    var myListArray = [ShoppingList]()
    var nametextField:UITextField!
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = false
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KRProgressHUD.dismiss()
        loadList()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "back", style: .done, target: nil, action: nil)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myListArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? myListCell {
            cell.delegate = self
            cell.selectedBackgroundView = createSelectedBacgroundView()
            let currentList = myListArray[indexPath.row]
            cell.configureCell(shoppingList: currentList)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "myListToShoppingItemSegue", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "myListToShoppingItemSegue" {
            
            let index = sender as! IndexPath
            
            let currentList = myListArray[index.row]
            
            if let destination = segue.destination as? ShoppingItemVC {
                destination.shoppingList = currentList
            }
        }
    }
    
    
    
    @IBAction func addBarBtnPrssd(_ sender: Any) {
        
        let alerController = UIAlertController(title: "Create a new shopping list", message: "Enter the name of your shopping list", preferredStyle: .alert)
        alerController.addTextField { (textField) in
            self.nametextField = textField
            textField.placeholder = "Name"
        }
        alerController.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action) in
            
            self.createShoppingList()
            
        }))
        
        alerController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
        }))
        
        self.present(alerController, animated: true, completion: nil)
        
    }
    
    
    func createShoppingList() {
        
        if nametextField.text != "" {
            let shoppingList = ShoppingList(name: nametextField.text!)
            
            shoppingList.saveItemsInBackground(shoppingList: shoppingList, completion: { (error:Error?) in
                if error != nil {
                    DispatchQueue.main.async {
                        KRProgressHUD.showError(withMessage: "Error in creating your list")
                    }
                    return
                }
            })
        } else {
            KRProgressHUD.showWarning(withMessage: "Name is empty")
        }
    }
    
    
    
    func loadList(){
        
        FIRDatabaseRef.child(kSHOPPINGLIST).child(FUser.currentId()).observe(.value) {(snapshot:DataSnapshot) in
            
            
            if snapshot.exists() {
                
                self.myListArray.removeAll()
                
                let sorted = ((snapshot.value as! NSDictionary).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key:kDATE,ascending:false)])
                
                for list in sorted {
                    
                    let shoppingList = ShoppingList(dictionary: list as! NSDictionary)
                    self.myListArray.append(shoppingList)
                }
            } else {
                print("no snapshot")
            }
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    
    //MARK: Swipe Cell delegate functions
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
        }
        
        let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            
            
            let item = self.myListArray[indexPath.row]
            self.myListArray.remove(at: indexPath.row)
            
            ShoppingItem.deleteAllShoppingItemsOfTheList(shoppingList: item, completion: { (success) in
                
                if success {
                    
                    item.deleteItemInBackgroud(shoppingList: item)
                    
                }
            })
            DispatchQueue.main.async {
                self.myTableView.beginUpdates()
                action.fulfill(with: .delete)
                self.myTableView.endUpdates()
            }
        }
        configure(action: delete, with: .trash)
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 11
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color
        
    }
    
}
