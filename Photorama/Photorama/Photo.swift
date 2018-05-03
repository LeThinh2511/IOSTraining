//
//  Photo.swift
//  Photorama
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

class Photo
{
    var photoID: String
    var title: String
    var dateTaken: Date
    var remoteURL: URL
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date)
    {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
