//
//  myListCell.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import SwipeCellKit

class myListCell: SwipeTableViewCell {

    @IBOutlet weak var nameTxtField: UILabel!
    @IBOutlet weak var itemsTxtField: UILabel!
    @IBOutlet weak var dateTxtField: UILabel!
    @IBOutlet weak var totalTxtField: UILabel!
    
    
    func configureCell(shoppingList:ShoppingList) {
        
        var name = ""
        
        self.nameTxtField.text = shoppingList.name
        
        if shoppingList.totalItems > 1 {
            name = "items"
        }else{
            name = "item"
        }
        let currency = userDefaults.value(forKey: kCURRENCY) as! String
        self.itemsTxtField.text = "\(shoppingList.totalItems)"+" "+name
        self.totalTxtField.text = "Totoal is \(currency)\(String(format: "%.2f", shoppingList.totalPrice))"
        
        let newDateFormatter = dateFormatter()
        newDateFormatter.dateFormat = "dd-MM-YYYY"
        let date = newDateFormatter.string(from: shoppingList.date)
        
        self.dateTxtField.text = date
        
        
        self.nameTxtField.sizeToFit()
        self.totalTxtField.sizeToFit()
    }
}
