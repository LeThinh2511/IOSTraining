//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by ThinhLe on 3/22/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController
{
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(_ sender: UIButton)
    {
        let newItem = Item()
        itemStore.allItems.insert(newItem, at: 0)
        if let index = itemStore.allItems.index(of: newItem)
        {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton)
    {
        if isEditing
        {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        }
        else
        {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = itemStore.allItems[indexPath.row]
        
        if item.name != "No more item!"
        {
            if item.valueInDollars < 50
            {
                cell.valueLabel.textColor = .green
            }
            else
            {
                cell.valueLabel.textColor = .red
            }
            cell.valueLabel.text = "$\(item.valueInDollars)"
            cell.serialNumberLabel.text = "\(item.serialNumber!)"
        }
        else
        {
            cell.serialNumberLabel.text = ""
            cell.valueLabel.text = ""
        }
        cell.nameLabel.text = item.name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
                self.itemStore.removeItem(item)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            present(ac, animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if destinationIndexPath.row == itemStore.allItems.count - 1
        {
            return
        }
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == itemStore.allItems.count - 1
        {
            return false
        }
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == itemStore.allItems.count - 1
        {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showItem"?:
            if let row = tableView.indexPathForSelectedRow?.row
            {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
