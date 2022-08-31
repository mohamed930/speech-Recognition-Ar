//
//  mapViewController.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 16/08/2022.
//

import UIKit
import GoogleMaps
import Kingfisher
import CoreAudio

class mapViewController: UIViewController , GMSMapViewDelegate {
    
    @IBOutlet weak var gMap: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placepopulationLabel: UILabel!
    @IBOutlet weak var placeAreaLabel: UILabel!
    
    var pickedLocation: locationModel?
    let api_key = "AIzaSyC1TI05_3LrGQEeEsPo1FMbAttO8alOzPw"
    var mapView:GMSMapView?
    var camera:GMSCameraPosition?
    let tourimeplaces = touristPlacesAPI()
    var arr: [GroupItem]!
    static var index = 0
    var markers = Array<GMSMarker>()

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.isHidden = true
        loadData()
    }
    
    func loadData() {
        guard let pickedLocation = pickedLocation else {
            ShowAllMuesums()
            return
        }

        if pickedLocation.markerStatus {
            // change map
            CreateAnnotation(view: gMap, long: pickedLocation.long, latit: pickedLocation.lati, Title: pickedLocation.placeName!, Des: "", zoom: Float(pickedLocation.zoom))
        }
        else {
            // change map
            containerView.isHidden = false
            SetGoogleMapsOperation(lati: pickedLocation.lati, long: pickedLocation.long, view: gMap, zoom: Float(pickedLocation.zoom))
        }
        
        placeImageView.image = UIImage(named: pickedLocation.placeImage!)
//        print(pickedLocation.placeName ?? "Not found")
        placeNameLabel.text = "اسم المكان: " + (pickedLocation.placeName ?? "Not found")
        placepopulationLabel.text = "تعداد السكان: " + pickedLocation.populationNumber!
        placeAreaLabel.text = "مساحه المكان: " + pickedLocation.placeArea!
        
    }
    
    @IBAction func BackButtonAction (_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func NextPlaceButton(_ sender:Any) {
        if mapViewController.index < arr.count {
            let data = arr[mapViewController.index]
            
            mapView?.animate(toLocation: markers[mapViewController.index].position)
            mapView?.animate(toZoom: 15)
            
            ShowPlaceDetails(data: data)
            
            mapViewController.index += 1
        }
        else {
            mapViewController.index = 0
        }
    }
    
    @IBAction func PrevPlaceButton(_ sender:Any) {
        if mapViewController.index != 0 {
            let data = arr[mapViewController.index]
            
            mapView?.animate(toLocation: markers[mapViewController.index].position)
            mapView?.animate(toZoom: 15)
            
            ShowPlaceDetails(data: data)
            
            mapViewController.index -= 1
        }
        else {
            mapViewController.index = arr.count - 1
        }
    }
    
    func ShowAllMuesums() {
        tourimeplaces.GetAllMuseumsOperation { [weak self] response in
            guard let self = self else { return }
            
            switch response {
                
            case .success(let success):
                guard let success = success else { return }
                
                let lati = success.response.geocode.center.lat
                let long = success.response.geocode.center.lng
                
//                self.SetGoogleMapsOperation(lati: lati, long: long, view: self.gMap, zoom: 5)
                
                self.arr = success.response.groups[0].items
                
                self.CreateAnnotations(view: self.gMap, long: long, latit: lati, zoom: 5, Arr: self.arr)
                

            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
    
    // MARK:- TODO:- Set Map API Key
    private func setApiKEY() {
        GMSServices.provideAPIKey(api_key)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Methdo For Show Map when Load Page.
    private func SetGoogleMapsOperation(lati: Double,long: Double ,view: UIView,zoom: Float) {
        
        setApiKEY()
                
        camera = GMSCameraPosition.camera(withLatitude: lati, longitude: long , zoom: zoom)
        
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
//        mapView?.delegate = delegate
        
        mapView!.frame = view.bounds
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
    }
    // ------------------------------------------------
    
    private func CreateAnnotation (view: UIView,long: Double, latit: Double,Title: String, Des: String,zoom: Float) {
                
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
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
        
    }
    // ------------------------------------------------
    
    // MARK: TODO: This Method For Create Anotations on Map.
    func CreateAnnotations (view: UIView,long: Double, latit: Double,zoom: Float,Arr: [GroupItem]) {
            
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
        mapView?.delegate = self
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
        
    }
    // ------------------------------------------------
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        guard let data = arr.first(where: {$0.venue.id == marker.snippet}) else { return true }
        
        guard let pickedindex = arr.firstIndex(where: {$0.venue.id == marker.snippet}) else {return true}
        
        mapViewController.index = pickedindex
        
        containerView.isHidden = false
        
        mapView.animate(toLocation: marker.position)
        mapView.animate(toZoom: 15)
        
        ShowPlaceDetails(data: data)
        
        return true
     }
    
    private func ShowPlaceDetails(data: GroupItem) {
        let placeName = data.venue.name.split(separator: "(")
        let placeNameAr = placeName[placeName.count - 1].split(separator: ")")
        
        placeNameLabel.text = "اسم المكان: " + String(placeNameAr[0])
        placeAreaLabel.text = "عنوان المكان: " + (data.venue.location.address ?? "لم يتم التحديد")
        placepopulationLabel.isHidden = true
        
        let url = data.venue.photos.groups[0].items[0].itemPrefix! + imageKey + data.venue.photos.groups[0].items[0].suffix!
        
        let resource = ImageResource(downloadURL: URL(string: url)!)
        
        DispatchQueue.main.async {
            KingfisherManager.shared.retrieveImage(with: resource) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.placeImageView.image = value.image.imageWithSize(scaledToSize: CGSize(width: 151, height: 151))
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
