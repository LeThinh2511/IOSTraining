//
//  PhotosViewController.swift
//  Photorama
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController
{
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    func updateImageView(for photo: Photo)
    {
        store.fetchImage(for: photo, completion: {
            (imageResult) -> Void in
            switch imageResult
            {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        store.fetchRecentPhotos(completion: {(photoResult: PhotosResult) -> Void in
            switch photoResult
            {
            case let .success(photos):
                print("successfully found \(photos.count) photos")
                if let firstPhoto = photos.first
                {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
            })
    }
    
    
}
