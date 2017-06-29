//
//  MapViewController.swift
//  GMapsNearbyMe
//
//  Created by snehal.kerkar on 28/06/17.
//  Copyright © 2017 Snehal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

let defaultLatitude  = 37.0
let defaultLongitude = -122.41
let zoomValue        = 5.0


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: UIView!
    
    var gmsMapView: GMSMapView?
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.renderMap()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receivedGeojsonData),
                                               name: NSNotification.Name(rawValue: Constants().kUINotificationGeojsonDataReceived),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func renderMap() {
        
        GMSServices.provideAPIKey(Constants().apiKeyGmap)
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLatitude,
                                              longitude: defaultLongitude,
                                              zoom: Float(zoomValue))
        gmsMapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
        self.view = gmsMapView
    }
    
    private func fetchNeighborhood(byLocation location: CLLocation) -> Place {
        let neighborhood = Place()
        
        // TODO: Optimize
        var neighborhoods = Array<(String, CLLocation)>()
        for place in places
        {
            let coordinates = place.coordinates.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }
            let locations = coordinates.map{ CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
            
            // fetch minimal distance of each place
            if let closestLocation = locations.min(by: { location.distance(from: $0) < location.distance(from: $1) })
            {
                neighborhoods.append((place.name, closestLocation))
            }
        }
        
        // fetch place nearest to given location
        let nearest = neighborhoods.min(by: { location.distance(from: $0.0.1) < location.distance(from: $0.1.1) })
        
        print("nearest: \(String(describing: nearest)) | Place: \(String(describing: nearest?.0))")
        self.putMarker(onLocation: (nearest?.1)!)
        
        neighborhood.name = nearest?.0 ?? ""
        neighborhood.coordinates = (places.filter { $0.name == neighborhood.name }.first?.coordinates)!
        
        return neighborhood
    }
    
    private func putMarker(onLocation location: CLLocation) {
        let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.map = gmsMapView
        
        self.view = gmsMapView
    }
    
    private func heighlightNeighborhood(polygon: [[Double]]) {
        // create path
        let path = GMSMutablePath()
        for coordinate in polygon {
            path.add(CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0]))
        }

        // draw polygone
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = .lightGray
        polygon.strokeColor = .red
        polygon.strokeWidth = 2
        polygon.map = gmsMapView
        
        self.view = gmsMapView
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Notifications
    
    @objc private func receivedGeojsonData(_ notification: NSNotification) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants().kUINotificationGeojsonDataReceived), object: nil)
        
        if notification.object is [Place] {
            
            places = notification.object as! [Place]
            
            // TODO: Store data in Persistant Storage (CoreData)
           
            // TODO: take the coordinates from user
            let neighborhood = self.fetchNeighborhood(byLocation: CLLocation(latitude: 37.7749, longitude: -122.4194))
            self.heighlightNeighborhood(polygon: neighborhood.coordinates)
            
            self.showAlert(message: "Neighborhood: " + neighborhood.name)
  
        } else {
            // TODO: Handle Error
        }
    }

}
