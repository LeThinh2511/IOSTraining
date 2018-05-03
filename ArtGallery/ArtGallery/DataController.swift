//
//  DataController.swift
//  ArtGallery
//
//  Created by ThinhLe on 4/23/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation





class DataController
{
    var manager: AFHTTPSessionManager
    
    init()
    {
        manager = AFHTTPSessionManager()
    }
    
    func getData(callback: @escaping ([Image]) -> Void)
    {
        let loadDataQueue = DispatchQueue(label: "loadDataQueue")
        
        //mutex
        self.manager.requestSerializer = AFJSONRequestSerializer(writingOptions: [])
        self.manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.manager.responseSerializer.acceptableContentTypes = ["application/json", "text/html"]
        
        loadDataQueue.async
        {
            self.manager.get("https://api.flickr.com/services/rest?method=flickr.interestingness.getList&api_key=a6d819499131071f158fd740860a5a88&extras=url_h,date_taken&format=json&nojsoncallback=1", parameters: nil, progress: nil, success: {(sdt, data) in
                let images = self.parse(data: data)
                callback(images)
                },
                failure:
                {
                    (sdt,error) in
                    print("error")
                    print(error.localizedDescription)
                })
        }
    }
    
    func parse(data: Any?) -> [Image]
    {
        var images = [Image]()
        let jsonData = data as? [String:Any]
        if let jsonData = jsonData
        {
            let photos = jsonData["photos"] as? [String:Any]
            if let photos = photos
            {
                let photo = photos["photo"] as? [[String:Any]]
                if let photo = photo
                {
                    var urlString: String?
                    var dateString = ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    for item in photo
                    {
                        let image = Image()
                        
                        dateString = (item["datetaken"] as? String)!
                        image.dateTaken = dateFormatter.date(from: dateString)
                        image.owner = item["owner"] as? String
                        image.title = item["title"] as? String
                        urlString = (item["url_h"] as? String)
                        if let urlString = urlString
                        {
                            image.url = URL(string: urlString)
                        }
                        
                        images.append(image)
                    }
                }
            }
        }
        return images
    }
}
