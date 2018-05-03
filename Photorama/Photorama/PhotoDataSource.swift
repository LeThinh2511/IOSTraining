//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by ThinhLe on 5/3/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource
{
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        return cell
    }
    
    
}
