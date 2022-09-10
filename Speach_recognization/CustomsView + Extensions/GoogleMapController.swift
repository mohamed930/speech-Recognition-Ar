//
//  GoogleMapController.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 09/09/2022.
//

import UIKit
import GoogleMaps

class GoogleMapController {
    
    let api_key = "AIzaSyC1TI05_3LrGQEeEsPo1FMbAttO8alOzPw"
    var mapView:GMSMapView?
    var camera:GMSCameraPosition?
    var markers = Array<GMSMarker>()
    
    // MARK:- TODO:- Set Map API Key
    private func setApiKEY() {
        GMSServices.provideAPIKey(api_key)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Methdo For Show Map when Load Page.
    public func SetGoogleMapsOperation(lati: Double,long: Double ,view: UIView,zoom: Float) {
        
        setApiKEY()
                
        camera = GMSCameraPosition.camera(withLatitude: lati, longitude: long , zoom: zoom)
        
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
//        mapView?.delegate = delegate
        
        mapView!.frame = view.bounds
        mapView!.mapType = .satellite
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
    }
    // ------------------------------------------------
    
    public func CreateAnnotation (view: UIView,long: Double, latit: Double,Title: String, Des: String,zoom: Float) {
                
        setApiKEY()
        
        // Creates a marker in the center of the map.
        camera = GMSCameraPosition.camera(withLatitude: latit, longitude: long, zoom: zoom)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latit, longitude: long)
        marker.title = Title
        marker.snippet = Des
        marker.map = mapView
        
        
        mapView?.frame = view.bounds
        mapView!.mapType = .satellite
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
        
    }
    // ------------------------------------------------
    
    
    // MARK: TODO: This Method For Create Anotations on Map.
    public func CreateAnnotations (view: UIView,long: Double, latit: Double,zoom: Float,Arr: [GroupItem], viewController: GMSMapViewDelegate) {
            
        setApiKEY()
        
        // Creates a marker in the center of the map.
        camera = GMSCameraPosition.camera(withLatitude: latit, longitude: long, zoom: zoom)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
        var bounds = GMSCoordinateBounds()
        
        for i in Arr {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: i.venue.location.lat , longitude: i.venue.location.lng)
            marker.title = i.venue.name
            marker.snippet = i.venue.id
            
            marker.map = mapView
            bounds = bounds.includingCoordinate(marker.position)
            markers.append(marker)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView!.animate(with: update)
        
        mapView?.frame = view.bounds
        mapView!.mapType = .satellite
        mapView?.delegate = viewController
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
        
    }
    // ------------------------------------------------
    
    // MARK: TODO: This method for draw line.
    func DrawLine(lati: Double,long: Double, zoom: Float ,view: UIView, location: [[String]], routName: [String] , rootColor: [UIColor] , viewController: GMSMapViewDelegate) {
        
        setApiKEY()
        
        // Creates a marker in the center of the map.
        camera = GMSCameraPosition.camera(withLatitude: lati, longitude: long, zoom: zoom)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
        
        var x = 0
        
        for i in location {
            let path = GMSMutablePath()
            for j in i {
                let location = j.split(separator: ",")
                let lati = location[0]
                let long = location[1]
                path.add(CLLocationCoordinate2D(latitude: Double(lati)!, longitude: Double(long)!))
            }
            let rectangle = GMSPolyline(path: path)
            rectangle.strokeWidth = 2
            rectangle.strokeColor = rootColor[x]
            rectangle.isTappable = true
            rectangle.title = routName[x]
            rectangle.map = mapView
            x += 1
        }
        
        mapView?.frame = view.bounds
        mapView!.mapType = .satellite
        mapView?.delegate = viewController
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
    }
}
