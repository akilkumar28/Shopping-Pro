//
//  User.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/27/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import Foundation
import Firebase
import KRProgressHUD




class FUser {
    
    let objectId:String!
    let createdAt:Date!
    
    private var _email:String!
    private var _firstName:String!
    private var _lastName:String!
    private var _fullName:String!
    
    var email:String {
        get {
            return self._email
        }
        set{
            self._email = newValue
        }
    }
    var firstName:String {
        get {
            return self._firstName
        }
        set{
            self._firstName = newValue
        }
    }
    var lastName:String {
        get {
            return self._lastName
        }
        set{
            self._lastName = newValue
        }
    }
    var fullName:String {
        get {
            return self._fullName
        }
        set{
            self._fullName = newValue
        }
    }
    
    init(objectId:String,createdAt:Date,email:String,firstName:String,lastName:String) {
        self.objectId = objectId
        self.createdAt = createdAt
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
    }
    
    
    
}
