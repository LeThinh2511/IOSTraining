//
//  MyUITextField.swift
//  Homepwner
//
//  Created by ThinhLe on 4/9/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class MyUITextField: UITextField
{
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 0.5
        return true
    }
    @discardableResult
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.1
        return true
    }
}
