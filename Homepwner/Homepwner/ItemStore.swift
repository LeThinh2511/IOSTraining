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
    
    init()
    {
        for _ in 0..<5
        {
            createItem()
        }
    }
    
    @discardableResult func createItem() -> Item
    {
        let newItem = Item()
        allItems.append(newItem)
        return newItem
    }
}
