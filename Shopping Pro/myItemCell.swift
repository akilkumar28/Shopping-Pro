//
//  myItemCell.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit

class myItemCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTxtFld: UILabel!
    @IBOutlet weak var descTxtFld: UILabel!
    @IBOutlet weak var quantityTxtFld: UILabel!
    @IBOutlet weak var priceTxtFld: UILabel!
    
    
    
    
    
    func configureCell(item:ShoppingItem){
        
        self.nameTxtFld.text = item.name
        self.descTxtFld.text = item.info
        self.quantityTxtFld.text = item.quantity
        self.priceTxtFld.text = "$\(item.price)"
        
        
        self.nameTxtFld.sizeToFit()
        self.descTxtFld.sizeToFit()
        self.priceTxtFld.sizeToFit()
        
        
        
        //TODO : later add for image
    }
    
    
    
}
