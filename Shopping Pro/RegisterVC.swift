//
//  RegisterVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/27/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import KRProgressHUD
import Firebase

class RegisterVC: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var viewHoldingRegisterOutlet: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    
    @IBOutlet weak var passwordTxtFld: UITextField!

    @IBOutlet weak var firstNameTxtFld: UITextField!
    
    @IBOutlet weak var lastNameTxtFld: UITextField!
    
    @IBOutlet weak var registerBtnOutlet: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewHoldingRegisterOutlet.layer.cornerRadius = 8
    }
    
    func reset() {
        self.emailTxtFld.text = nil
        self.passwordTxtFld.text = nil
        self.firstNameTxtFld.text = nil
        self.lastNameTxtFld.text = nil
        self.view.endEditing(true)
    }

    @IBAction func registerTapped(_ sender: Any) {
        if !(emailTxtFld.text?.isEmpty)! && !(passwordTxtFld.text?.isEmpty)! && !(firstNameTxtFld.text?.isEmpty)! && !(lastNameTxtFld.text?.isEmpty)! {
            
            KRProgressHUD.show(withMessage: "Signing up...")
            
            FUser.registerUserWith(email: emailTxtFld.text!, password: passwordTxtFld.text!, firstName: firstNameTxtFld.text!, lastName: lastNameTxtFld.text!, completion: { (error:Error?) in
                
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error occured while registering")
                    self.reset()
                    return
                }
//                self.goToApp()
//                self.reset()
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error:Error?) in
                    if error != nil {
                        KRProgressHUD.showError(withMessage: "Error in sending email verification link")
                    }else{
                        
                        KRProgressHUD.show(withMessage: "Please verify your email")
                    }
                })
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "reveal")))
                self.dismiss(animated: true, completion: nil)
            })
            
        }else{
            KRProgressHUD.showError(withMessage: "Empty Fields")
        }
    }
  
    @IBAction func alreadyHaveAnAccountBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func goToApp() {
        
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        vc.selectedIndex = 0
        present(vc, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

}
