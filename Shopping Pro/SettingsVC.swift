//
//  SettingsVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/27/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import KRProgressHUD

class SettingsVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    
    
    let currencyArray = ["€", "$", "£", "¥", "₽", "HKD", "CHF", "Kč", "kr", "﷼", "₪", "₩", "Ls", "₹", "﷼"]
    let currencyStringArray = ["EUR, €", "USD, $", "GBP, £", "CNY, ¥", "RUB, ₽", "HKD", "CHF", "CZK, Kč", "DKK, kr", "IRR, ﷼", "ILS, ₪", "KRW, ₩", "Lat, Ls", "Rupee, ₹", "QAR, ﷼"]
    var currencyPicker:UIPickerView!
    var currencyString = ""
    
    
    
    @IBOutlet weak var currencyTxtFLd: UITextField!
    @IBOutlet weak var logOutBtnOutlet: FancyButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutBtnOutlet.layer.cornerRadius = 8
        logOutBtnOutlet.layer.borderWidth = 1
        logOutBtnOutlet.layer.borderColor = UIColor.black.cgColor
        currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyTxtFLd.inputView = currencyPicker
        currencyTxtFLd.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    //MARK: PickerViewFunctions
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyStringArray.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        currencyTxtFLd.text = currencyArray[row]
        saveSetting()
        updateUI()
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyStringArray[row]
    }
    
    
    
    func saveSetting() {
        
        userDefaults.set(currencyTxtFLd.text!, forKey: kCURRENCY)
        userDefaults.synchronize()
    }
    
    func updateUI() {
        
        currencyTxtFLd.text = userDefaults.object(forKey: kCURRENCY) as? String
        currencyString = currencyTxtFLd.text!
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if currencyString == "" {
            currencyString = currencyArray[0]
        }
        currencyTxtFLd.text = currencyString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func logOutBtnPrssd(_ sender: Any) {
        
        
        FUser.logOutUser { (success:Bool) in
            if success {
                cleanUpFirebaseObservers()
                DispatchQueue.main.async {
                    KRProgressHUD.show(withMessage: "Signing Out...")
                }
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeView") as! LogInVC
                userDefaults.set(false, forKey: "google")
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
