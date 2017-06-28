//
//  myItemCell.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import SwipeCellKit

class myItemCell: SwipeTableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTxtFld: UILabel!
    @IBOutlet weak var descTxtFld: UILabel!
    @IBOutlet weak var quantityTxtFld: UILabel!
    @IBOutlet weak var priceTxtFld: UILabel!
    @IBOutlet weak var quantityView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.quantityView.layer.cornerRadius = self.quantityView.frame.width / 2
        self.quantityView.layer.borderWidth = 3
        self.quantityView.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    func configureCell(item:ShoppingItem){
        let currency = userDefaults.value(forKey: kCURRENCY) as! String
        self.nameTxtFld.text = item.name
        self.descTxtFld.text = item.info
        self.quantityTxtFld.text = item.quantity
        self.priceTxtFld.text = "\(currency)\(String(format: "%.2f",item.price))"
        self.nameTxtFld.sizeToFit()
        self.descTxtFld.sizeToFit()
        self.priceTxtFld.sizeToFit()
        
        if item.image != "" {
            imageFromData(imageData: item.image, withBlock: { (image:UIImage?) in
                if let newImage = image?.scaleImageToSize(newSize: itemImageView.frame.size) {
                    DispatchQueue.main.async {
                        self.itemImageView.image = newImage.circleMasked
                    }
                }
            })
        }else {
            let newImage = UIImage(named: "placeholder imageView")!.scaleImageToSize(newSize: itemImageView.frame.size)
            self.itemImageView.image = newImage.circleMasked
        }
        
    }
    
}
