//
//  PhotosViewController.swift
//  Photorama
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet var collectionView: UICollectionView!
    var store: PhotoStore!
    
    let photoDataSource = PhotoDataSource()
    
    var widthCell:CGFloat = 0.0
    var heightCell:CGFloat = 0.0
    let numOfCellInLine:CGFloat = 3.0
    var minSpace:CGFloat = 5.0
    
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
    
    private func updateDataSource()
    {
        store.fetchAllPhotos(completion: {(photosResult: PhotosResult) -> Void in
            switch photosResult
            {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
            })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCell, height: heightCell)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return minSpace
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return minSpace
//    }
    
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
        updateDataSource()
        store.fetchRecentPhotos(completion: {(photoResult: PhotosResult) -> Void in
            self.updateDataSource()
            })
    }
    
    override func viewDidLayoutSubviews() {
        let widthFrame = CGFloat(view.frame.width)
        minSpace = 5
        
        self.widthCell = (widthFrame - (numOfCellInLine - 1) * minSpace)  / numOfCellInLine
        minSpace = widthFrame - numOfCellInLine * widthCell
        heightCell = widthCell
        print(widthCell)
        print(minSpace)
        print(widthFrame)
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
