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
        
        let segmentedControl
        = UISegmentedControl(items: ["Standard", "Hybrid", "Sattellite"])
        
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingconstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingconstraint.isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
}
