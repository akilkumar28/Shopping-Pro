//
//  LogInVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/27/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit

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
    }
    
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
    }


}
