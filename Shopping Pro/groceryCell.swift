//
//  groceryCell.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/26/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import SwipeCellKit

class groceryCell: SwipeTableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureCell(item:GroceryItem){
        
        
        self.nameLabel.text = item.name
        self.detailLabel.text = item.info
        self.priceLabel.text = "$\(String(format: "%.2f", item.price))"
        
        if item.image != "" {
            
            imageFromData(imageData: item.image, withBlock: { (image:UIImage?) in
                //    print("######",Thread.isMainThread)
                
                if let newImage = image?.scaleImageToSize(newSize: itemImageView.frame.size) {
                    self.itemImageView.image = newImage.circleMasked
                }
            })
            
            
        }else {
            let newImage = UIImage(named: "ShoppingCartEmpty")!.scaleImageToSize(newSize: itemImageView.frame.size)
            self.itemImageView.image = newImage.circleMasked
        }
        
    }
        
    }

