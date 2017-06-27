//
//  RegisterVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/27/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    
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
        viewHoldingRegisterOutlet.layer.cornerRadius = 5
    }

    @IBAction func registerTapped(_ sender: Any) {
    }
  
    @IBAction func alreadyHaveAnAccountBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
