//
//  PhotoInforViewController.swift
//  Photorama
//
//  Created by ThinhLe on 5/4/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class PhotoInforViewController: UIViewController
{
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo!
    {
        didSet
        {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImage(for: photo, completion: {(imageResult: ImageResult) -> Void in
            switch imageResult
            {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print(error)
            }
        })
    }
}
