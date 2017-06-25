//
//  SwipeTableViewHelper.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit


enum ActionDescriptor {
    
    case buy,returnPurchase, trash
    
    
    func title() -> String? {
        
        
        switch self {
        case .buy:
            return "Buy"
        case .returnPurchase:
            return "Return Purchase"
        case .trash:
            return "Trash"
        }
    }
    
    func image() -> UIImage {
        
        let name:String
        
        
        switch self {
        case .buy:
            name = "BuyFilled"
        case .returnPurchase:
            name = "ReturnFilled"
        case .trash:
            name = "Trash"
        }
        return UIImage(named: name)!
    }
    
    
    var color:UIColor {
        
        switch self {
        case .buy,.returnPurchase:
            return .darkGray
        case .trash:
            return .red
        }
    }
}


func createSelectedBacgroundView() -> UIView {
    
    let view =  UIView()
    view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)
    return view
}


