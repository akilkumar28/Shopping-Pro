//
//  ShoppingItemVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit

class ShoppingItemVC: UIViewController {
    
    
    var shoppingList:ShoppingList!
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var itemsLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: IBActions
    
    @IBAction func addBarBtnPrssd(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
        vc.shoppingList = self.shoppingList
        present(vc, animated: true, completion: nil)
        
        
    }
    
    
  

}
