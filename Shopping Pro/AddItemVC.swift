//
//  AddItemVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import KRProgressHUD

class AddItemVC: UIViewController {
    
    
    
    var shoppingList:ShoppingList!
    
    
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var extranInfoTxtFld: UITextField!
    @IBOutlet weak var quantityTxtFld: UITextField!
    @IBOutlet weak var priceTxtFld: UITextField!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        if nameTxtFld.text != nil && priceTxtFld.text != nil {
            saveItem()
        }else{
            KRProgressHUD.showWarning(withMessage: "Empty Fields!")
        }
    }

    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveItem() {
        
        let shoppingItem = ShoppingItem(name: nameTxtFld.text!, info: extranInfoTxtFld.text!, quantity: quantityTxtFld.text!, price:Float(priceTxtFld.text!)!, shoppingListId: shoppingList.id)
        
        shoppingItem.saveItemsInBackground(shoppingItem: shoppingItem) { (error) in
            if error != nil {
                KRProgressHUD.showError(withMessage: "Error while saving the item")
                return
            }
        }
        
        
    }
   

}
