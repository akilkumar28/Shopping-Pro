//
//  SearchVC.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/26/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase
import SwipeCellKit


protocol SearchVCDelegate {
    func didChooseItem(item:GroceryItem)
}

class SearchVC: UIViewController,UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate,UISearchResultsUpdating {
    
    
    var delegate:SearchVCDelegate?
    var groceryItemsArray = [GroceryItem]()
    var filteredGroceryItems = [GroceryItem]()
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = false
    var searchController = UISearchController(searchResultsController: nil)
    var clickToEdit = true
    
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var addBtnOutlet: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBtnOutlet.isHidden = !clickToEdit
        cancelBtn.isHidden = clickToEdit
        
        //search bar delegate properties
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        
        //adding search bar to tableview
        
        myTableView.tableHeaderView = searchController.searchBar

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadGroceryItems()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredGroceryItems.count
        }
        return groceryItemsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? groceryCell {
            cell.delegate = self
            cell.selectedBackgroundView = createSelectedBacgroundView()
            var item:GroceryItem!
            if searchController.isActive && searchController.searchBar.text != "" {
                item = filteredGroceryItems[indexPath.row]
            }else{
                item = groceryItemsArray[indexPath.row]
            }
            cell.configureCell(item: item)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        var item:GroceryItem!
        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredGroceryItems[indexPath.row]
        }else{
            item = groceryItemsArray[indexPath.row]
        }
        
        if !clickToEdit {
            // add to current shopping list
            
            delegate?.didChooseItem(item: item)
            
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
            vc.groceryItem = item
            self.present(vc, animated: true, completion: nil)
        }
        
        

    }
    
    func loadGroceryItems() {
        
        FIRDatabaseRef.child(kGROCERYITEM).child(FUser.currentId()).observe(.value) { (snapshot:DataSnapshot) in
            
            if snapshot.exists() {
                self.groceryItemsArray.removeAll()
                self.filteredGroceryItems.removeAll()
                
                let items = (snapshot.value as! NSDictionary).allValues as Array
                
                for item in items {
                    
                    let groceryItem = GroceryItem(dictionary: item as!NSDictionary)
                    self.groceryItemsArray.append(groceryItem)
                }
            }else{
                print("No Snapshot")
            }
         self.myTableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var item:GroceryItem!
        
        if orientation == .left {
            guard isSwipeRightEnabled else {
                return nil
            }}
            
            let delete = SwipeAction(style: .destructive, title: nil, handler: { (action, indexPath) in
                
                if self.searchController.isActive && self.searchController.searchBar.text != "" {
                    item = self.filteredGroceryItems[indexPath.row]
                    self.filteredGroceryItems.remove(at: indexPath.row)
                }else{
                    item = self.groceryItemsArray[indexPath.row]
                    self.groceryItemsArray.remove(at: indexPath.row)
                }
                item.deleteItemInBackgroud(groceryItem: item)
                self.myTableView.beginUpdates()
                action.fulfill(with: .delete)
                self.myTableView.endUpdates()
            })
            configure(action: delete, with: .trash)
            return [delete]
        }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 11
        return options
        
    }
    
    //MARK: SearchController delefate methods
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
        myTableView.reloadData()
    }
    
    func filteredContentForSearchText(searchText: String,scope:String = "All"){
        
        filteredGroceryItems = groceryItemsArray.filter({ (item:GroceryItem) -> Bool in
            return  item.name.lowercased().contains(searchText.lowercased())
        })
        
    }
 
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addBtnPrssd(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemVC
        vc.addItemToList = true
        self.present(vc, animated: true, completion: nil)
    }
   
}
