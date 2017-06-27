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
    
    
    init(dictionary:NSDictionary) {
        self.objectId = dictionary[kOBJECTID] as! String
        self.createdAt = dateFormatter().date(from: dictionary[kCREATEDAT] as! String)
        self.email = dictionary[kEMAIL] as! String
        self.firstName = dictionary[kFIRSTNAME] as! String
        self.lastName = dictionary[kLASTNAME] as! String
        self.fullName = dictionary[kFULLNAME] as! String
    }
    
    class func currentId() -> String{
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = userDefaults.object(forKey: kCURRENTUSER) {
                return FUser(dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    
    //MARK: Login
    
    class func logInUserWith(email:String,password:String,completion:@escaping(_ error:Error?)->Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user:User?, error:Error?) in
            if error != nil {
                completion(error!)
                return
            }else{
                if let user = user {
                    
                    fetchUser(userId: user.uid, completion: { (success) in
                        if success {
                            print("user loaded successfully")
                        }
                    })
                    
                    completion(error)
                }
            }
        }
        
    }
    
    class func registerUserWith(email:String,password:String,firstName:String,lastName:String,completion:@escaping (_ error:Error?)->Void) {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user:User?, error:Error?) in
            
            if error != nil {
                completion(error!)
                return
            }else{
                if let user = user {
                    
                    let fUser = FUser(objectId: user.uid, createdAt: Date(), email: user.email!, firstName: firstName, lastName: lastName)
                    
                    // saving to user defaults
                    
                    saveUserlocally(user: fUser)
                    // saving to firebase also
                    saveUserToFirebase(user: fUser)
                
                    completion(error)
                }
            }
            
            
        }
        
    }
    
    class func logOutUser(completion:@escaping (_ success:Bool)->Void) {
        
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        do {
            try Auth.auth().signOut()
            completion(true)
        }catch let err as NSError {
            completion(false)
            print(err.localizedDescription)
        }
        
        
    }

}


//Mark: save user funtions


func convertUserToDictionary(user:FUser) -> NSDictionary {
    
    let createdDate = dateFormatter().string(from: user.createdAt)
    
    return NSDictionary(objects: [user.objectId,createdDate,user.email,user.firstName,user.lastName,user.fullName], forKeys: [kOBJECTID as NSCopying,kCREATEDAT as NSCopying,kEMAIL as NSCopying,kFIRSTNAME as NSCopying,kLASTNAME as NSCopying,kFULLNAME as NSCopying])
    
    
}


func saveUserToFirebase(user:FUser) {
    
    let reference = FIRDatabaseRef.child(kUSER).child(user.objectId)
    reference.setValue(convertUserToDictionary(user: user))
}

func saveUserlocally(user:FUser) {
    userDefaults.set(convertUserToDictionary(user: user), forKey: kCURRENTUSER)
    userDefaults.synchronize()
}

func fetchUser(userId:String,completion:@escaping (_ success:Bool)->Void) {
    
    FIRDatabaseRef.child(kUSER).child(userId).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
        
        if snapshot.exists() {
            
            let user = FUser(dictionary: snapshot.value as! NSDictionary)
            
            saveUserlocally(user: user)
            
            completion(true)
            
        }else{
            completion(false)
        }
    }
    
}


func resetUserPassword(email:String) {
    
    Auth.auth().sendPasswordReset(withEmail: email) { (error:Error?) in
        if error != nil {
            KRProgressHUD.showError(withMessage: "Error reseting password")
        }else{
            KRProgressHUD.showSuccess(withMessage: "Password reset email sent")
        }
    }
}


func cleanUpFirebaseObservers(){
    
    FIRDatabaseRef.child(kUSER).removeAllObservers()
    FIRDatabaseRef.child(kSHOPPINGLIST).removeAllObservers()
    FIRDatabaseRef.child(kSHOPPINGITEM).removeAllObservers()
    FIRDatabaseRef.child(kGROCERYITEM).removeAllObservers()
}





