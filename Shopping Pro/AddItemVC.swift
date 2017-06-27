//
//  AddItemVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import KRProgressHUD

class AddItemVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    
    
    var shoppingList:ShoppingList!
    var shoppingItem:ShoppingItem?
    var itemImage:UIImage?
    var addItemToList: Bool?
    var groceryItem:GroceryItem?
    
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var extranInfoTxtFld: UITextField!
    @IBOutlet weak var quantityTxtFld: UITextField!
    @IBOutlet weak var priceTxtFld: UITextField!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "ShoppingCartEmpty")!.scaleImageToSize(newSize: itemImageView.frame.size)
        itemImageView.image = image.circleMasked
        
        if shoppingItem != nil || groceryItem != nil {
            
            updateUI()
            
        }

    }
    
    func updateUI() {
        
        if shoppingItem != nil {
            
            self.nameTxtFld.text = shoppingItem!.name
            self.extranInfoTxtFld.text = shoppingItem!.info
            self.quantityTxtFld.text = shoppingItem!.quantity
            self.priceTxtFld.text = "\(shoppingItem!.price)"
            
            if shoppingItem!.image != "" {
                
                imageFromData(imageData: shoppingItem!.image, withBlock: { (image:UIImage?) in
                    self.itemImage = image!
                    let newImage = image!.scaleImageToSize(newSize: self.itemImageView.frame.size)
                    self.itemImageView.image = newImage.circleMasked
                    
                })
            }
        }else if groceryItem != nil {
            // grocery item
            
            self.nameTxtFld.text = groceryItem!.name
            self.extranInfoTxtFld.text = groceryItem!.info
            self.priceTxtFld.text = "\(groceryItem!.price)"
            
            if groceryItem!.image != "" {
                
                imageFromData(imageData: groceryItem!.image, withBlock: { (image:UIImage?) in
                    self.itemImage = image!
                    let newImage = image!.scaleImageToSize(newSize: self.itemImageView.frame.size)
                    self.itemImageView.image = newImage.circleMasked
                    
                })
            }
            
        }
        
    }
    
    func updateItem() {
        
        var imageData:String!
        
        if itemImage != nil {
            
            let image = UIImageJPEGRepresentation(itemImage!, 0.5)
            imageData = image?.base64EncodedString(options: .init(rawValue: 0))
            
            
        }else{
            imageData = ""
        }
        
        if shoppingItem != nil {
            
            shoppingItem!.name = nameTxtFld.text!
            shoppingItem!.price = Float(priceTxtFld.text!)!
            shoppingItem!.quantity = quantityTxtFld.text!
            shoppingItem!.info = extranInfoTxtFld.text!
            shoppingItem!.image = imageData
            
            shoppingItem!.updateItemInBackground(shoppingItem: shoppingItem!, completion: { (error:Error?) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error while updating the item")
                    return
                }
            })
        }else if groceryItem != nil{
            //grocery item
            groceryItem!.name = nameTxtFld.text!
            groceryItem!.price = Float(priceTxtFld.text!)!
            groceryItem!.info = extranInfoTxtFld.text!
            groceryItem!.image = imageData
            
            groceryItem!.updateItemInBackground(groceryItem: groceryItem!, completion: { (error) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error while updating the item")
                    return
                }
            })

        }
        
       self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        if !(nameTxtFld.text?.isEmpty)! && !(priceTxtFld.text?.isEmpty)! {
            
            if shoppingItem != nil || groceryItem != nil {
                //edit item
                self.updateItem()
            }else{
                saveItem()
            }
        }else{
            KRProgressHUD.showWarning(withMessage: "Empty Fields!")
        }
    }

    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveItem() {
        
        
        var imageData:String!
        
        if itemImage != nil {
            
            let image = UIImageJPEGRepresentation(itemImage!, 0.5)
            imageData = image?.base64EncodedString(options: .init(rawValue: 0))
            
            
        }else{
            imageData = ""
        }
        
        if addItemToList! {
            // grocery item
            
            let groceryItem = GroceryItem(name: nameTxtFld.text!, info: extranInfoTxtFld.text!, price: Float(priceTxtFld.text!)!, image: imageData)
            groceryItem.saveItemsInBackground(groceryItem: groceryItem, completion: { (error) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error while creating the item")
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
            
        }else{
            
            // shopping item
            let shoppingItem = ShoppingItem(name: nameTxtFld.text!, info: extranInfoTxtFld.text!, quantity: quantityTxtFld.text!, price:Float(priceTxtFld.text!)!, shoppingListId: shoppingList.id)
            shoppingItem.image = imageData
            
            shoppingItem.saveItemsInBackground(shoppingItem: shoppingItem) { (error) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error while saving the item")
                    return
                }
            }
            showListNotification(shoppingItem:shoppingItem)
        }
    }
    
    
    func showListNotification(shoppingItem:ShoppingItem) {
        
        let alertController = UIAlertController(title: "Add Items to list?", message: "Do you want to add this item to your most commonly used items?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            
            let groceryItem = GroceryItem(shoppingItem: shoppingItem)
            
            groceryItem.saveItemsInBackground(groceryItem: groceryItem, completion: { (error:Error?) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error occured while saving to your list")
                }
            })
            
            self.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    @IBAction func addImageBtnPrssd(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = Camera(delegate_: self)
        
        let takePhoto = UIAlertAction(title: "Take a picture", style: .default) { (alert:UIAlertAction) in
            //show camera
            camera.PresentPhotoCamera(target: self, canEdit: true)
        }
        let photoLibrary = UIAlertAction(title: "Select from photo library", style: .default) { (alert:UIAlertAction) in
            // show photo library
            camera.PresentPhotoLibrary(target: self, canEdit: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert:UIAlertAction) in
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(photoLibrary)
        optionMenu.addAction(cancel)
        
        present(optionMenu, animated: true, completion: nil)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        itemImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if let newImage = itemImage?.scaleImageToSize(newSize: itemImageView.frame.size) {
            self.itemImageView.image = newImage.circleMasked
        }
        
        picker.dismiss(animated: true, completion: nil)
        
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
