//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by ThinhLe on 1/29/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController
{
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    @IBAction func fahrenheitFieldEdittingChanged(textField: UITextField)
    {
        if let text = textField.text, !text.isEmpty
        {
            celsiusLabel.text = text
        }
        else
        {
            celsiusLabel.text = "???"
        }
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer)
    {
        textField.resignFirstResponder()
    }
}
