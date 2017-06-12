//
//  MapViewController.swift
//  Memorable Places
//
//  Created by Matthew J. Perkins on 6/8/17.
//  Copyright © 2017 Matthew J. Perkins. All rights reserved.
//

import UIKit

import MapKit

import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    @IBOutlet var map: MKMapView!
    
    var manager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
        print(activePlace)
        
        if activePlace == -1 {
            
            manager.delegate = self
            
            manager.desiredAccuracy = kCLLocationAccuracyBest
            
            manager.requestWhenInUseAuthorization()
            
            manager.startUpdatingLocation()
       
        } else {
        
            if places.count > activePlace {
            
                if let name = places[activePlace]["name"] {
                
                    if let lat = places[activePlace]["lat"] {
                    
                        if let lon = places[activePlace]["lon"] {
                        
                            if let latitude = Double(lat) {
                            
                                if let longitude = Double(lon) {
                                
                                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    
                                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                        
                                        let region = MKCoordinateRegion(center: coordinate, span: span)
                                    
                                        self.map.setRegion(region, animated: true)
                                    
                                        let annotation = MKPointAnnotation()
                                    
                                        annotation.coordinate = coordinate
                                    
                                        annotation.title = name
                                    
                                        self.map.addAnnotation(annotation)
                                }
                                
                                        }
                                    }
                                    
                                }
                            }
                        
                        }
                    
                    }
        
    


      
        
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
        
            let touchPoint = gestureRecognizer.location(in: self.map)
        
            let newCoordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    
                    print(error as Any)
                    
                } else {
                
                    if let placemark = placemarks?[0] {
                    
                        if placemark.subThoroughfare != nil {
                        
                        title += placemark.subThoroughfare! + " "
                            
                        }
                        
                        if placemark.thoroughfare != nil {
                        
                        title += placemark.thoroughfare!
                            
                        }
                        
                    }
                
                }
                
                if title == "" {
                
                    title = "Added \(NSDate())"
                }
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = title
                
                self.map.addAnnotation(annotation)
                
                places.append(["name":title,"lat":String(newCoordinate.latitude),"lon":String(newCoordinate.longitude)])
                
                UserDefaults.standard.set(places, forKey: "places")
                
            })
        
            
        
        }
        
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
