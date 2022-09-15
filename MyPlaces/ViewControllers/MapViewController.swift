//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 11.09.2022.
//

import UIKit
import MapKit
import CoreLocation


@objc protocol MapViewControllerDelegate {
    
    @objc optional func getAddress(_ address: String?) // Not required method - its for example
}

class MapViewController: UIViewController {
    
    let mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place = Place()
    
    let annotationIdentifier = "annotationIdentifier"
    var incomeSegueIdentifier = ""
    
    var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(mapView: mapView, and: previousLocation) { (currentLocation) in
                self.previousLocation = currentLocation
                
 
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.mapManager.showUserLocation(mapView: self.mapView)
                }
            }
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapMarker: UIImageView!
    @IBOutlet var currentAddressLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var goButton: UIButton!
    
    @IBOutlet var distanceToPlace: UILabel!
    @IBOutlet var timeToPlace: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        currentAddressLabel.text = ""
        setUpMapView()
        
        doneButton.layer.cornerRadius = 10
    }
    
    @IBAction func centerViewUserLocation() {
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @IBAction func cancelMap() {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress?(currentAddressLabel.text)
        dismiss(animated: true)
    }
    
    @IBAction func goButtonPressed() {
        mapManager.getDirections(for: mapView) { (location) in
            self.previousLocation = location
        }
        
        //    TODO: set value for label on map
           distanceToPlace.isHidden = false
            timeToPlace.isHidden = false
            distanceToPlace.text = mapManager.distance
            timeToPlace.text = mapManager.timeInterval
                                    
    }
    
    
    private func setUpMapView() {
        
        goButton.isHidden = true
        
        distanceToPlace.isHidden = true
        timeToPlace.isHidden = true
        
        mapManager.checkLocationServices(mapView: mapView, segueIdentifier: incomeSegueIdentifier) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeSegueIdentifier == "showPlace" {
            mapManager.setUpPlacemark(place: place, mapView: mapView)
            mapMarker.isHidden = true
            currentAddressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        //Banner for map annotation
        guard let imageData = place.imageData else { return nil }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.image = UIImage(data: imageData)
        
        annotationView?.rightCalloutAccessoryView = imageView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == "showPlace" && previousLocation != nil {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: self.mapView)
            }
        }
        
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(center) { (placeMarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placeMarks = placeMarks else { return }
            
            let placeMark = placeMarks.first
            let streetName = placeMark?.thoroughfare
            let buildNumber = placeMark?.subThoroughfare
            
            DispatchQueue.main.async {
                
                if streetName != nil && buildNumber != nil {
                    self.currentAddressLabel.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil {
                    self.currentAddressLabel.text = "\(streetName!)"
                } else {
                    self.currentAddressLabel.text = ""
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .systemBlue
        
        return renderer
    }
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapManager.checkLocationAuthorization(mapView: mapView, segueIdentifier: incomeSegueIdentifier)
    }
}
