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
    private var searchController: UISearchController!
    private var localSearchRequest: MKLocalSearchRequest!
    private var localSearch: MKLocalSearch!
    private var localSearchResponse: MKLocalSearchResponse!
    
    // MARK: - Map variables
    private var annotation: MKAnnotation!
    private var locationManager: CLLocationManager!
    private var isCurrentLocation: Bool = false
    
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
        let addImageButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addImageButtonClicked))
        navigationItem.rightBarButtonItem = addImageButton
        
        mapView.delegate = self
        search.delegate = self
    }

    @IBAction func currentPosition(_ sender: Any) {
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

// MARK: - UISearchBarDelegate
extension LocationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        activityIndicator.startAnimating()
        localSearch.start { [weak self] (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil {
                let alert = UIAlertController(title: nil, message: "Place not found", preferredStyle: .alert)
                self?.present(alert, animated: true, completion: nil)
                
                return
            }
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self!.mapView.centerCoordinate = pointAnnotation.coordinate
            self!.mapView.addAnnotation(pinAnnotationView.annotation!)
            
            self?.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - MKMapViewDelegate
extension LocationViewController: MKMapViewDelegate {
    
}

// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isCurrentLocation {
            return
        }
        
        isCurrentLocation = false
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location!.coordinate
        pointAnnotation.title = ""
        mapView.addAnnotation(pointAnnotation)
        
        manager.stopUpdatingLocation()
        activityIndicator.stopAnimating()
    }
}
