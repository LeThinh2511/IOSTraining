//
//  DateChangeController.swift
//  Homepwner
//
//  Created by ThinhLe on 4/9/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DateChangeController: UIViewController
{
    @IBOutlet var datePicker: UIDatePicker!
    
    var item: Item!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Change date"
        datePicker.setDate(item.dateCreated, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        item.dateCreated = datePicker.date
    }
}
