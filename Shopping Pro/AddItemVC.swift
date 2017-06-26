//
//  AddItemVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import KRProgressHUD

class AddItemVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    var shoppingList:ShoppingList!
    var shoppingItem:ShoppingItem?
    var itemImage:UIImage?
    
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var extranInfoTxtFld: UITextField!
    @IBOutlet weak var quantityTxtFld: UITextField!
    @IBOutlet weak var priceTxtFld: UITextField!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "ShoppingCartEmpty")!.scaleImageToSize(newSize: itemImageView.frame.size)
        itemImageView.image = image.circleMasked
        
        if shoppingItem != nil {
            
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
        }else{
            // grocery item
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
        }else{
            //grocery item
        }
        
        
    }
    
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        if !(nameTxtFld.text?.isEmpty)! && !(priceTxtFld.text?.isEmpty)! {
            
            if shoppingItem != nil {
                //edit item
                self.updateItem()
            }else{
                saveItem()
            }
        }else{
            KRProgressHUD.showWarning(withMessage: "Empty Fields!")
        }
        self.dismiss(animated: true, completion: nil)
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
        
        let shoppingItem = ShoppingItem(name: nameTxtFld.text!, info: extranInfoTxtFld.text!, quantity: quantityTxtFld.text!, price:Float(priceTxtFld.text!)!, shoppingListId: shoppingList.id)
        shoppingItem.image = imageData
        
        shoppingItem.saveItemsInBackground(shoppingItem: shoppingItem) { (error) in
            if error != nil {
                KRProgressHUD.showError(withMessage: "Error while saving the item")
                return
            }
        }
        
        
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
   

}
