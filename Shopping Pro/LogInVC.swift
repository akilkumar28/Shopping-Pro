//
//  LogInVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/27/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import KRProgressHUD
import Firebase
import GoogleSignIn


class LogInVC: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var verifyStackView: UIStackView!
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var viewHoldingSignIn: FancyView!
    @IBOutlet weak var emailTxtFld: FancyTextField!
    @IBOutlet weak var passwordTxtFld: FancyTextField!
    @IBOutlet weak var logInBtnOutlet: FancyButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtFld.delegate = self
        passwordTxtFld.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        logInBtnOutlet.generalButn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reveal), name: NSNotification.Name(rawValue: "reveal"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        verifyStackView.isHidden = true
        viewHoldingSignIn.layer.cornerRadius = 8
    }
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            KRProgressHUD.dismiss()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func reveal(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.verifyStackView.isHidden = false
        }
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
                    DispatchQueue.main.async {
                        KRProgressHUD.showMessage(error!.localizedDescription)
                        self.reset()
                    }
                    return
                }
                if (Auth.auth().currentUser?.isEmailVerified)! {
                    self.goToApp()
                    self.reset()
                    
                } else {
                    KRProgressHUD.showWarning(withMessage: "Please verify your email")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        KRProgressHUD.dismiss()
                        self.verifyStackView.isHidden = false
                    })
                }
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
    
    @IBAction func verifyEmailBtn(_ sender: Any) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error:Error?) in
            var message:String = ""
            var success:Bool!
            if error != nil {
                message = "Error In Sending the Verification Link"
                success = false
                
            } else {
                message = "Email Verification Link Sent"
                success = true
                
            }
            DispatchQueue.main.async {
                if success {
                    KRProgressHUD.showSuccess(withMessage: message)
                }else{
                    KRProgressHUD.showError(withMessage: message)
                }
            }
        })
    }
}
