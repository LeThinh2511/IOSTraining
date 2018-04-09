//
//  DetailViewController.swift
//  Homepwner
//
//  Created by ThinhLe on 4/2/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    // MARK: outlet
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var nameField: MyUITextField!
    @IBOutlet var serialNumberField: MyUITextField!
    @IBOutlet var valueField: MyUITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: property
    
    var item: Item! {
        didSet
        {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: action
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        // ???
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePicker.sourceType = .camera
        }
        else
        {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: view life cycle
    
    override func viewDidLoad() {
        let deleteButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteImage))
        toolbar.items?.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        toolbar.items?.append(deleteButtonItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let key = item.itemKey
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text ?? ""
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText)
        {
            item.valueInDollars = value.intValue
        }
        else
        {
            item.valueInDollars = 0
        }
    }
    
   
    // MARK: function
    @objc func deleteImage()
    {
        imageStore.deleteImage(forKey: item.itemKey)
        imageView.image = nil
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "changeDate"?:
            let dateChangeController = segue.destination as! DateChangeController
            dateChangeController.item = self.item
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        imageStore.setImage(image, forKey: item.itemKey)
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}
