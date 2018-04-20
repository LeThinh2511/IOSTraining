//
//  ItemStore.swift
//  Homepwner
//
//  Created by ThinhLe on 3/22/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemStore
{
    var allItems = [Item]()
    
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    init()
    {
        if let achiverdItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item]
        {
            allItems = achiverdItems
        }
    }
    
    func removeItem(_ item: Item)
    {
        if let index = self.allItems.index(of: item)
        {
            self.allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int)
    {
        if fromIndex == toIndex
        {
            return
        }
        
        let movedItem = self.allItems[fromIndex]
        
        self.allItems.remove(at: fromIndex)
        self.allItems.insert(movedItem, at: toIndex)
    }
    
    @discardableResult func createItem() -> Item
    {
        let newItem = Item()
        allItems.append(newItem)
        return newItem
    }
    
    func saveChanges() -> Bool
    {
        print("Saving item to:\(itemArchiveURL)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
}
