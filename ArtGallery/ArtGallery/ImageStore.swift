//
//  ImageStore.swift
//  ArtGallery
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

class ImageStore
{    
    var store = [Image]()
    
    func getData(callback: @escaping ([Image]) -> Void)
    {
        let dataController = DataController()
        dataController.getData(callback: callback)
    }
}
