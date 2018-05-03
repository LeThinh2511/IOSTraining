//
//  PhotoStore.swift
//  Photorama
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import UIKit

enum ImageResult
{
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error
{
    case imageCreationError
}

enum PhotosResult
{
    case success([Photo])
    case failure(Error)
}

class PhotoStore
{
    let imageStore = ImageStore()
    
    private let session: URLSession =
    {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult
    {
        guard let jsonData = data
        else
        {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void)
    {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request)
        {
            (data, response, error) -> Void in
            let httpURLRespone = response as? HTTPURLResponse
            print("fetch interesting photos response: ")
            print(httpURLRespone?.statusCode ?? "")
            print(httpURLRespone?.allHeaderFields ?? "")
            let result = self.processPhotosRequest(data: data, error: error)
            DispatchQueue.main.sync {
                completion(result)
            }
        }
        task.resume()
    }
    
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void)
    {
        let url = FlickrAPI.recentPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let jsonData = data
            {
                let result = FlickrAPI.photos(fromJSON: jsonData)
                DispatchQueue.main.sync {
                    completion(result)
                }
            }
        })
        task.resume()
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void)
    {
        let photoKey = photo.photoID
        if let image = imageStore.image(forKey: photoKey)
        {
            OperationQueue.main.addOperation {
                completion(.success(image))
            } 
            return
        }
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request)
        {
            (data, response, error) -> Void in
            let httpURLRespone = response as? HTTPURLResponse
            print("fetch interesting photos response: ")
            print(httpURLRespone?.statusCode ?? "")
            print(httpURLRespone?.allHeaderFields ?? "")
            let result = self.processImageRequest(data: data, error: error)
            if case let .success(image) = result
            {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            DispatchQueue.main.sync {
                completion(result)
            }
        }
        task.resume()
    }
    
    func processImageRequest(data: Data?, error: Error?) -> ImageResult
    {
        guard let imageData = data, let image = UIImage(data: imageData)
        else
        {
            if data == nil
            {
                return .failure(error!)
            }
            else
            {
                return .failure(PhotoError.imageCreationError)
            }
        }
        return .success(image)
    }
}
