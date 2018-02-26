//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by ThinhLe on 1/29/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController
{
    var mapView: MKMapView!
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
}
