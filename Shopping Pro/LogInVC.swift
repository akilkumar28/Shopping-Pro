//
//  LogInVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/27/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import KRProgressHUD

class LogInVC: UIViewController {

    
    @IBOutlet weak var viewHoldingSignIn: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    @IBOutlet weak var logInBtnOutlet: UIButton!
    
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewHoldingSignIn.layer.cornerRadius = 5
    }
    
    
    @IBAction func logInClicked(_ sender: Any) {
        
        if !(emailTxtFld.text?.isEmpty)! && !(passwordTxtFld.text?.isEmpty)! {
            
            KRProgressHUD.show(withMessage: "Signing In...")
            
            FUser.logInUserWith(email: emailTxtFld.text!, password: passwordTxtFld.text!, completion: { (error:Error?) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error occured while logging In")
                }
                self.emailTxtFld.text = nil
                self.passwordTxtFld.text = nil
                self.view.endEditing(true)
                
                
                //TODO: go to app
                
                self.goToApp()
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


}
