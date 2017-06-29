//
//  FancyButton.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/28/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit


class FancyButton: UIButton {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.7
    }
    
    func textFldBtn() {
        layer.cornerRadius = 2
        
    }
    func generalButn () {
        layer.masksToBounds = true
        layer.cornerRadius = 8
        
    }
    
}
