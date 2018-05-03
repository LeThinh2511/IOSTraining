//
//  FlickrAPI.swift
//  Photorama
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation

enum flickrError: Error
{
    case invalidJSONData
}

enum Method: String
{
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.photos.getRecent"
}

struct FlickrAPI
{
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    private static let dateFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static var interestingPhotosURL: URL
    {
        return flickrURL(method: .interestingPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    static var recentPhotosURL: URL
    {
        return flickrURL(method: .recentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    
    
    private static func flickrURL(method: Method, parameters: [String: String]?) -> URL
    {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams
        {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters
        {
            for (key, value) in additionalParams
            {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static func photos(fromJSON data: Data) -> PhotosResult
    {
        do
        {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [AnyHashable:Any], let photos = jsonDictionary["photos"] as? [String:Any], let photosArray = photos["photo"] as? [[String:Any]]
            else
            {
                return .failure(flickrError.invalidJSONData)
            }
            var finalPhotos = [Photo]()
            for photoJSON in photosArray
            {
                //print(photoJSON)
                if let photo = photo(fromJSON: photoJSON)
                {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty
            {
                return .failure(flickrError.invalidJSONData)
            }
            return .success(finalPhotos)
            
        }
        catch let error
        {
            return .failure(error)
        }
    }
    
    private static func photo(fromJSON json: [String:Any]) -> Photo?
    {
//        print("id:\(json["id"])")
//        print("title: \(json["title"])")
//        print("dateTaken: \(json["datetaken"])")
//        print("url: \(json["url_h"])")
//        if let photoID = json["id"] as? String
//        {
//            if let title = json["title"] as? String
//            {
//                if let dateString = json["datetaken"] as? String
//                {
//                    if let photoURLString = json["url_h"] as? String
//                    {
//                        if let url = URL(string: photoURLString)
//                        {
//                            if let dateTaken = dateFormatter.date(from: dateString)
//                            {
//                                return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
//                            }
//                        }
//                    }
//                }
//            }
//        }
        guard let photoID = json["id"] as? String, let title = json["title"] as? String, let dateString = json["datetaken"] as? String, let photoURLString = json["url_h"] as? String, let url = URL(string: photoURLString), let dateTaken = dateFormatter.date(from: dateString)
        else
        {
            return nil
        }
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
}
