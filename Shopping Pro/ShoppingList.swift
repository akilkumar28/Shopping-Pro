//
//  ShoppingList.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import Foundation
import Firebase


class ShoppingList {
    
    
    private var _name:String!
    private var _totalPrice:Float!
    private var _totalItems:Int!
    private var _id:String!
    private var _date:Date!
    private var _ownerId:String!
    
    
    
    var name:String {
        get {
            return self._name
        }
        set {
            self._name = newValue
        }
    }
    var totalPrice:Float {
        get {
            return self._totalPrice
        }
        set {
            self._totalPrice = newValue
        }
    }
    var totalItems:Int {
        get {
            return self._totalItems
        }
        set {
            self._totalItems = newValue
        }
    }
    var id:String {
        get {
            return self._id
        }
        set {
            self._id = newValue
        }
    }
    var date:Date {
        get {
            return self._date
        }
        set {
            self._date = newValue
        }
    }
    var ownerId:String {
        get {
            return self._ownerId
        }
        set {
            self._ownerId = newValue
        }
    }
    
    
    
    
    init(name:String,totalPrice:Float = 0,id:String = "") {
        self.name = name
        self.totalPrice = totalPrice
        self.totalItems = 0
        self.id = id
        self.date = Date()
        self.ownerId = "1234"
    }
    
    
    
    init(dictionary:NSDictionary) {
        self.name = dictionary[kNAME] as! String
        self.totalPrice = dictionary[kTOTALPRICE] as! Float
        self.totalItems = dictionary[kTOTALITEMS] as! Int
        self.id = dictionary[kSHOPPINGLISTID] as! String
        self.date = dateFormatter().date(from: dictionary[kDATE] as! String)!
        self.ownerId = dictionary[kOWNERID] as! String
    }
    
    
    func convertDictionaryFromItems(shoppingList:ShoppingList) -> NSDictionary {
        
        return NSDictionary(objects: [shoppingList.name,shoppingList.totalPrice,shoppingList.totalItems,shoppingList.id,dateFormatter().string(from: shoppingList.date),shoppingList.ownerId], forKeys: [kNAME as NSCopying,kTOTALPRICE as NSCopying,kTOTALITEMS as NSCopying,kSHOPPINGLISTID as NSCopying,kDATE as NSCopying,kOWNERID as NSCopying])
    }
    
    func saveItemsInBackground(shoppingList:ShoppingList,completion: @escaping(_ error:Error?)->Void) {
        
        let ref = FIRDatabaseRef.child(kSHOPPINGLIST).child("1234").childByAutoId()
        
        shoppingList.id = ref.key
        
        ref.setValue(convertDictionaryFromItems(shoppingList: shoppingList)) {
            (error,ref)->Void in
            
            completion(error)
        }
    }
    
    
    func deleteItemInBackgroud(shoppingList:ShoppingList) {
        
        let reference = FIRDatabaseRef.child(kSHOPPINGLIST).child("1234").child(shoppingList.id)
        
        reference.removeValue()
    }
    
    
    func updateItemInBackground(shoppingList:ShoppingList,completion: @escaping(_ error:Error?)->Void) {
        
        let reference = FIRDatabaseRef.child(kSHOPPINGLIST).child("1234").child(shoppingList.id)
        reference.setValue(convertDictionaryFromItems(shoppingList: shoppingList)) {
            error,ref in
            completion(error)
        }
    }
    
}
