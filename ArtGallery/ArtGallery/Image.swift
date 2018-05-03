//
//  Image.swift
//  ArtGallery
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

class Image
{
    var dateTaken: Date?
    var title: String?
    var url: URL?
    var owner: String?
    
    init()
    {
    }
    
    init(title: String, owner: String, dateTaken: Date, url: URL)
    {
        self.title = title
        self.owner = owner
        self.dateTaken = dateTaken
        self.url = url
    }
}
