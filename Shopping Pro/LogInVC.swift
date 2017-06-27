//
//  LogInVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/27/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import KRProgressHUD

class LogInVC: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var viewHoldingSignIn: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    @IBOutlet weak var logInBtnOutlet: UIButton!
    
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtFld.delegate = self
        passwordTxtFld.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        viewHoldingSignIn.layer.cornerRadius = 8
    }
    override func viewDidAppear(_ animated: Bool) {
        KRProgressHUD.dismiss()
    }
    
    func reset() {
        self.emailTxtFld.text = nil
        self.passwordTxtFld.text = nil
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func logInClicked(_ sender: Any) {
        
        if !(emailTxtFld.text?.isEmpty)! && !(passwordTxtFld.text?.isEmpty)! {
            
            KRProgressHUD.show(withMessage: "Signing In...")
            
            FUser.logInUserWith(email: emailTxtFld.text!, password: passwordTxtFld.text!, completion: { (error:Error?) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error occured while logging In")
                    self.reset()
                    return
                }
                
                
                
                //TODO: go to app
                
                self.goToApp()
                self.reset()
            })
            
        } else {
            KRProgressHUD.showWarning(withMessage: "Empty Fields")
        }
    }
    
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        if !(emailTxtFld.text?.isEmpty)! {
            resetUserPassword(email: emailTxtFld.text!)
        }else{
            KRProgressHUD.showWarning(withMessage: "Email field is empty")
        }
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
