//
//  PhotosViewController.swift
//  Photorama
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate
{
    @IBOutlet var collectionView: UICollectionView!
    var store: PhotoStore!
    
    let photoDataSource = PhotoDataSource()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto":
            let photoInforViewController = segue.destination as! PhotoInforViewController
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first
            {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                photoInforViewController.photo = photo
                photoInforViewController.store = store
            }
        default:
            print("error segue")
        }
    }
    
//    func updateImageView(for photo: Photo)
//    {
//        store.fetchImage(for: photo, completion: {
//            (imageResult) -> Void in
//            switch imageResult
//            {
//            case let .success(image):
//                self.imageView.image = image
//            case let .failure(error):
//                print("Error downloading image: \(error)")
//            }
//        })
//    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        store.fetchRecentPhotos(completion: {(photoResult: PhotosResult) -> Void in
            switch photoResult
            {
            case let .success(photos):
                print("successfully found \(photos.count) photos")
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
            })
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        store.fetchImage(for: photo, completion: {(result) -> Void in
            guard let photoIndex = self.photoDataSource.photos.index(of: photo), case let .success(image) = result
            else
            {
                return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell
            {
                cell.update(with: image)
            }
        })
    }
    
}
