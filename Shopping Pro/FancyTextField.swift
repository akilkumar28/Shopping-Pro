//
//  FancyTextField.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/28/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit

class FancyTextField: UITextField {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.7
        layer.cornerRadius = 2
        
    }

}
