//
//  LocationViewController.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 20/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - Delegate Protocol
protocol LocationViewControllerDelegate: class {
    func addImageLocation(image: UIImage)
}

class LocationViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var currentPosition: UIButton!
    
    // MARK: - Delegate
    weak var delegate: LocationViewControllerDelegate?
    
    // MARK: - Search
    var searchController: UISearchController!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    
    // MARK: - Map variables
    var annotation: MKAnnotation!
    var locationManager: CLLocationManager!
    var isCurrentLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        search.placeholder = NSLocalizedString("Search here", comment: "")
        
        // Shadow and Radius for Circle Button
        currentPosition.layer.shadowColor = UIColor.black.cgColor
        currentPosition.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        currentPosition.layer.masksToBounds = false
        currentPosition.layer.shadowRadius = 1.0
        currentPosition.layer.shadowOpacity = 0.5
        currentPosition.layer.cornerRadius = currentPosition.frame.width / 2
        
        // Bar Button
        let addImageButton = UIBarButtonItem(title: NSLocalizedString("Add", comment: ""), style: .plain, target: self, action: #selector(addImageButtonClicked))
        navigationItem.rightBarButtonItem = addImageButton
        
        mapView.delegate = self
        search.delegate = self
        
        // View Gesture - Swipe Down
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeKeyboard))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    @IBAction func currentPosition(_ sender: Any) {
        self.closeKeyboard()
        
        if (CLLocationManager.locationServicesEnabled()) {
            if locationManager == nil {
                locationManager = CLLocationManager()
                locationManager.delegate = self
            }
            locationManager?.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            isCurrentLocation = true
            activityIndicator.startAnimating()
        }
    }
    
    @objc func addImageButtonClicked(_ sender: Any) {
        
        let mapSnapshotOptions = MKMapSnapshotOptions()
        
        // Set the region of the map that is rendered
        mapSnapshotOptions.region = mapView.region
        
        // Set the scale of the image
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        let scaleFactor = 150 / mapView.frame.size.width
        mapSnapshotOptions.size.width = 150
        mapSnapshotOptions.size.height = mapView.frame.size.height * scaleFactor
        
        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.delegate?.addImageLocation(image: (snapshot?.image)!)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
