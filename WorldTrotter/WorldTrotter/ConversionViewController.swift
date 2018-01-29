//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by ThinhLe on 1/29/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>?
    {
        didSet
        {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>?
    {
        if let fahrenheitValue = fahrenheitValue
        {
            return fahrenheitValue.converted(to: .celsius)
        }
        else
        {
            return nil
        }
    }
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    @IBAction func fahrenheitFieldEdittingChanged(textField: UITextField)
    {
        if let text = textField.text, let value = Double(text)
        {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        }
        else
        {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer)
    {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel()
    {
        if let celsiusValue = celsiusValue
        {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        }
        else
        {
            celsiusLabel.text = "???"
        }
    }
    
    override func viewDidLoad() {
        celsiusLabel.text = "???"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let existingTextHasDecimalSeprator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeprator = string.range(of: ".")
        let number: Int? = Int(string)
        let isBackspace = strcmp(string, "\\b")
        if number != nil || string == "." || isBackspace == -92
        {
            if existingTextHasDecimalSeprator != nil, replacementTextHasDecimalSeprator != nil
            {
                return false
            }
            else
            {
                return true
            }
        }
        else
        {
            return false
        }
    }
}
