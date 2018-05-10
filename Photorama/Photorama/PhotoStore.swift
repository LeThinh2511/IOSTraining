//
//  PhotoStore.swift
//  Photorama
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores(completionHandler: {(description, error) in
            if let error = error
            {
                print("Error setting up core data \(error)")
            }
        })
        return container
    }()
    
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
        return FlickrAPI.photos(fromJSON: jsonData,into: persistentContainer.viewContext)
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
            if case .success = result
            {
                do
                {
                    try self.persistentContainer.viewContext.save()
                }
                catch let error
                {
                    print(error)
                }
            }
            DispatchQueue.main.sync {
                completion(result)
            }
        }
        task.resume()
    }
    
    func fetchAllPhotos(completion: @escaping (PhotosResult) -> Void)
    {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do
            {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            }
            catch let error
            {
                completion(.failure(error))
            }
        }
    }
    
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void)
    {
        let url = FlickrAPI.recentPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let jsonData = data
            {
                let result = FlickrAPI.photos(fromJSON: jsonData,into: self.persistentContainer.viewContext)
                DispatchQueue.main.sync {
                    completion(result)
                }
            }
        })
        task.resume()
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void)
    {
        guard let photoKey = photo.photoID
        else
        {
            preconditionFailure("error in fetchImage func")
        }
        if let image = imageStore.image(forKey: photoKey)
        {
            OperationQueue.main.addOperation {
                completion(.success(image))
            } 
            return
        }
        guard let photoURL = photo.remoteURL
        else
        {
            preconditionFailure("error in fetchImage func 2")
        }
        let request = URLRequest(url: photoURL as URL)
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
