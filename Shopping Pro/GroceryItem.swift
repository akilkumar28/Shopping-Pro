//
//  GroceryItem.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/26/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import Foundation


class GroceryItem {
    
    private var _name:String!
    private var _info:String!
    private var _price:Float!
    private var _ownderId:String!
    private var _image:String!
    private var _groceryItemId:String!
    
    
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
    var price:Float {
        get{
            return self._price
        }
        set{
            self._price = newValue
        }
    }
    var ownerId:String {
        get{
            return self._ownderId
        }
        set{
            self._ownderId = newValue
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
    var groceryItemId:String {
        get{
            return self._groceryItemId
        }
        set{
            self._groceryItemId = newValue
        }
    }
    
    
    
    init(name:String,info:String = "",price:Float,image:String = "") {
        self.name = name
        self.info = info
        self.price = price
        self.image = image
        self.ownerId = "1234"
        self.groceryItemId = ""
    }
    
    init(shoppingItem: ShoppingItem) {
        
        self.name = shoppingItem.name
        self.info = shoppingItem.info
        self.price = shoppingItem.price
        self.ownerId = "1234"
        self.image = shoppingItem.image
        self.groceryItemId = ""
        
    }
    
    init(dictionary:NSDictionary) {
        self.name = dictionary[kNAME] as! String
        self.info = dictionary[kINFO] as! String
        self.price = dictionary[kPRICE] as! Float
        self.image = dictionary[kIMAGE] as! String
        self.ownerId = dictionary[kOWNERID] as! String
        self.groceryItemId = dictionary[kGROCERYITEMID] as! String
    }
    
    func convertDictionaryFromItems(groceryItem:GroceryItem) -> NSDictionary {
        
        return NSDictionary(objects: [groceryItem.name,groceryItem.info,groceryItem.price,groceryItem.image,groceryItem.ownerId,groceryItem.groceryItemId], forKeys: [kNAME as NSCopying,kINFO as NSCopying,kPRICE as NSCopying,kIMAGE as NSCopying,kOWNERID as NSCopying,kGROCERYITEMID as NSCopying])
    }
    
    
    func saveItemsInBackground(groceryItem:GroceryItem,completion: @escaping(_ error:Error?)->Void) {
        
        let ref = FIRDatabaseRef.child(kGROCERYITEM).child("1234").childByAutoId()
        
        groceryItem.groceryItemId = ref.key
        
        ref.setValue(convertDictionaryFromItems(groceryItem: groceryItem)) {
            (error,ref)->Void in
            
            completion(error)
        }
    }
    
    
    func deleteItemInBackgroud(groceryItem:GroceryItem) {
        
        let reference = FIRDatabaseRef.child(kGROCERYITEM).child("1234").child(groceryItem.groceryItemId)
        
        reference.removeValue()
    }
    
    
    func updateItemInBackground(groceryItem:GroceryItem,completion: @escaping(_ error:Error?)->Void) {
        
        let ref = FIRDatabaseRef.child(kGROCERYITEM).child("1234").child(groceryItem.groceryItemId)
        
        ref.setValue(convertDictionaryFromItems(groceryItem:groceryItem)) {
            error,ref in
            
            completion(error)
        }
        
        
    }
    
}
