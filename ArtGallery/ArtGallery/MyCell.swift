//
//  MyCell.swift
//  ArtGallery
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

class MyCell: UITableViewCell
{
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateTakenLabel: UILabel!
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        photo.image = nil
        spinner.startAnimating()
    }
    
}
