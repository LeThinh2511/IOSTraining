//
//  TableViewController.swift
//  ArtGallery
//
//  Created by ThinhLe on 4/21/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var imageStore: ImageStore!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = 95
        
        let imageStore = ImageStore()
        imageStore.getData(callback: {(images: [Image]) -> Void in
            imageStore.store = images
            self.tableView.reloadData()
        })
        self.imageStore = imageStore
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageStore.store.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        
        let image = imageStore.store[indexPath.row]
        if let url = image.url
        {
            cell.photo.setImageWith(url)
            cell.spinner.stopAnimating()
        }
        cell.titleLabel.text = image.title
        if let date = image.dateTaken
        {
            var dateString = date.description
            dateString = String(dateString.split(separator: " ").first!)
            cell.dateTakenLabel.text = dateString
        }
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "tableViewToDetail":
            let detailViewController = segue.destination as! DetailViewController
            if let row = tableView.indexPathForSelectedRow?.row
            {
                detailViewController.image = imageStore.store[row]
            }
        default:
            print("error")
        }
    }
}


