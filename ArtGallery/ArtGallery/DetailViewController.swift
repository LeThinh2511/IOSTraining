//
//  DetailViewController.swift
//  ArtGallery
//
//  Created by ThinhLe on 4/24/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ownerLabel: UILabel!
    @IBOutlet var dateTakenLabel: UILabel!
    
    var image: Image!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = image.title
        ownerLabel.text = image.owner
        if let url = image.url
        {
            imageView.setImageWith(url)
        }
        if let date = image.dateTaken
        {
            var dateString = date.description
            dateString = String(dateString.split(separator: " ").first!)
            dateTakenLabel.text = dateString
        }
    }
    
    @IBAction func onBackTap(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)        
    }
}
