//
//  ShoppingItem.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import Foundation
import Firebase



class ShoppingItem {
    
    
    private var _name:String!
    private var _info:String!
    private var _quantity:String!
    private var _price:Float!
    private var _shoppingItemId:String!
    private var _shoppingListId:String!
    private var _isBought:Bool!
    private var _image:String!
    
    var name:String {
        get{
            return self._name
        }
        set{
            self._name = newValue
        }
    }
    var info:String {
        get{
            return self._info
        }
        set{
            self._info = newValue
        }
    }
    var quantity:String {
        get{
            return self._quantity
        }
        set{
            self._quantity = newValue
        }
    }
    var price:Float {
        get{
            return self._price
        }
        set{
            self._price = newValue
        }
    }
    var shoppingItemId:String {
        get{
            return self._shoppingItemId
        }
        set{
            self._shoppingItemId = newValue
        }
    }
    var shoppingListId:String {
        get{
            return self._shoppingListId
        }
        set{
            self._shoppingListId = newValue
        }
    }
    var isBought:Bool {
        get{
            return self._isBought
        }
        set{
            self._isBought = newValue
        }
    }
    
    var image:String {
        get{
            return self._image
        }
        set{
            self._image = newValue
        }
    }
    
    
    init(name:String,info:String = "",quantity:String = "1",price:Float,shoppingListId:String) {
        self.name = name
        self.info = info
        self.quantity = quantity
        self.price = price
        self.shoppingItemId = ""
        self.shoppingListId = shoppingListId
        self.isBought = false
        self.image = ""
    }
    
    
    
    init(dictionary:NSDictionary) {
        self.name = dictionary[kNAME] as! String
        self.info = dictionary[kINFO] as! String
        self.quantity = dictionary[kQUANTITY] as! String
        self.price = dictionary[kPRICE] as! Float
        self.shoppingItemId = dictionary[kSHOPPINGITEMID] as! String
        self.shoppingListId = dictionary[kSHOPPINGLISTID] as! String
        self.isBought = dictionary[kISBOUGHT] as! Bool
        self.image = dictionary[kIMAGE] as! String
    }
    
    
    func convertDictionaryFromItems(shoppingitem:ShoppingItem) -> NSDictionary {
        
        return NSDictionary(objects: [shoppingitem.name,shoppingitem.info,shoppingitem.quantity,shoppingitem.price,shoppingitem.shoppingItemId,shoppingitem.shoppingListId,shoppingitem.isBought,shoppingitem.image], forKeys: [kNAME as NSCopying,kINFO as NSCopying,kQUANTITY as NSCopying,kPRICE as NSCopying,kSHOPPINGITEMID as NSCopying,kSHOPPINGLISTID as NSCopying,kISBOUGHT as NSCopying,kIMAGE as NSCopying])
    }
    
    func saveItemsInBackground(shoppingItem:ShoppingItem,completion: @escaping(_ error:Error?)->Void) {
        
        let ref = FIRDatabaseRef.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).childByAutoId()
        
        shoppingItem.shoppingItemId = ref.key
        
        ref.setValue(convertDictionaryFromItems(shoppingitem: shoppingItem)) {
            (error,ref)->Void in
            
            completion(error)
        }
    }
    
    
    func deleteItemInBackgroud(shoppingItem:ShoppingItem) {
        
        let reference = FIRDatabaseRef.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).child(shoppingItem.shoppingItemId)
        
        reference.removeValue()
    }

    
    func updateItemInBackground(shoppingItem:ShoppingItem,completion: @escaping(_ error:Error?)->Void) {
        
        let ref = FIRDatabaseRef.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).child(shoppingItem.shoppingItemId)
        
        ref.setValue(convertDictionaryFromItems(shoppingitem: shoppingItem)) {
            error,ref in
            
            completion(error)
        }
    
    
    }

}
