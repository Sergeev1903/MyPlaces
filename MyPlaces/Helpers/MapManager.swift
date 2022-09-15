//
//  MapManager.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 15.09.2022.
//

import UIKit
import MapKit

class MapManager {
    
    let locationManager = CLLocationManager()
    
    var distance = ""
    var timeInterval = ""
    
   private let regionInMeters = 1_000.00
   private var directionsArray: [MKDirections] = []
   private var placeCoordinate: CLLocationCoordinate2D?
    
    // Map marker display
     func setUpPlacemark(place: Place, mapView: MKMapView) {
        
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            // Object used for describe point on the map
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            // Show all annotation on the map area
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    // Проверка доступности сервисов геолокации
     func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> () ) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
            closure()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Your location is not available",
                    message: "To give permission: Setting -> MyPlaces -> Location"
                )
            }
        }
    }
    
    // Проверка авторизации приложения для использования сервисов геолокации
     func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            
            if segueIdentifier == "getAddress" {
                showUserLocation(mapView: mapView)
            }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Your location is not available",
                    message: "To give permission: Setting -> MyPlaces -> Location"
                )
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // Add to info.plist Privacy - Location When In Use Usage Description
            break
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Your location is not available",
                    message: "To give permission: Setting -> MyPlaces -> Location"
                )
            }
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is available")
        }
    }
    
    // фокус карты на местоположении пользователя
     func showUserLocation(mapView: MKMapView) {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Строим маршрут от местоположения пользователя до place
     func getDirections(for mapView: MKMapView, previousLocation: (CLLocation) -> () ) {

        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
         previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        let directions = MKDirections(request: request)
        resetMapView(with: directions, mapView: mapView)
        
        directions.calculate { response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else {
                self.showAlert(title: "Error", message: "Direction is not available")
                return
            }
            
            for route in response.routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime // Can translate to hour or minute
               
                print("Distance to \(distance) km.")
                print("Travel time will be \(Int(timeInterval / 60)) minute.")
                
                self.distance = "\(distance) km."
                self.timeInterval = "\(Int(timeInterval / 60)) min."
            }
        }
    }
    
    // Настройка запроса для настройки маршрута
     func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    // Меняем отображаемую зону области карты в соответствии с перемещением пользователя
    func startTrackingUserLocation(mapView: MKMapView,
                                           and location: CLLocation?,
                                           closure: (_ currentLocation: CLLocation) -> () ) {
        
        guard let location = location else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: location) > 50 else { return } // value update user location after all 50 m.
        
        closure(center)
    }
    
    // Сброс всех ранее построенных маршрутов перед построением нового
     func resetMapView(with newDirections: MKDirections, mapView: MKMapView) {
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(newDirections)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    // Определение центра отображаемой области карты
     func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
     func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1 // Define over windows
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true)
    }
}
