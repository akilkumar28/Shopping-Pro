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
    
    
    @IBOutlet weak var viewHoldingRegisterOutlet: FancyView!
    @IBOutlet weak var emailTxtFld: FancyTextField!
    @IBOutlet weak var passwordTxtFld: FancyTextField!
    @IBOutlet weak var firstNameTxtFld: FancyTextField!
    @IBOutlet weak var lastNameTxtFld: FancyTextField!
    @IBOutlet weak var registerBtnOutlet: FancyButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtnOutlet.generalButn()
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
                    DispatchQueue.main.async {
                        KRProgressHUD.showMessage(error!.localizedDescription)
                        self.reset()
                    }
                    return
                }
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error:Error?) in
                    var message:String!
                    if error != nil {
                        message = error!.localizedDescription
                        
                    }else{
                        message = "Please verify your email"
                    }
                    DispatchQueue.main.async {
                        KRProgressHUD.showWarning(withMessage: message)
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
