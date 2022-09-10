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

class mapViewController: UIViewController {
    
    @IBOutlet weak var gMap: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placepopulationLabel: UILabel!
    @IBOutlet weak var placeAreaLabel: UILabel!
    @IBOutlet weak var nextButtton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    var pickedLocation: locationModel?
    let tourimeplaces = touristPlacesAPI()
    var arr: [GroupItem]!
    static var index = 0
    let googlemap = GoogleMapController()
    var message: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.isHidden = true
        loadData()
    }
    
    func loadData() {
        guard let pickedLocation = pickedLocation else {
            if message == "المتاحف" {
                ShowAllMuesums()
            }
            else {
                ShowLine()
            }
            
            return
        }

        if pickedLocation.markerStatus {
            // change map
            googlemap.CreateAnnotation(view: gMap, long: pickedLocation.long, latit: pickedLocation.lati, Title: pickedLocation.placeName!, Des: "", zoom: Float(pickedLocation.zoom))
        }
        else {
            // change map
            containerView.isHidden = false
            googlemap.SetGoogleMapsOperation(lati: pickedLocation.lati, long: pickedLocation.long, view: gMap, zoom: Float(pickedLocation.zoom))
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
            
            googlemap.mapView?.animate(toLocation: googlemap.markers[mapViewController.index].position)
            googlemap.mapView?.animate(toZoom: 15)
            
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
            
            googlemap.mapView?.animate(toLocation: googlemap.markers[mapViewController.index].position)
            googlemap.mapView?.animate(toZoom: 15)
            
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
                
                self.googlemap.CreateAnnotations(view: self.gMap, long: long, latit: lati, zoom: 5, Arr: self.arr,viewController: self)
                

            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
    
    func ShowLine() {
        googlemap.DrawLine(lati: 27.0, long: 30.0, zoom: 6.5, view: gMap, location: DomiatLine, routName: "Domiate", viewController: self)
    }
    
}

extension mapViewController: GMSMapViewDelegate {
    
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
    
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        nextButtton.isHidden = true
        prevButton.isHidden = true
        if overlay.title == "Domiate" {
            containerView.isHidden = false
            placeImageView.image = UIImage(named: "domiate")
            placeNameLabel.text = "اسم المكان: فرع دمياط"
            placeAreaLabel.text = "مساحه المكان: ٢٤٠ كم٢"
            placepopulationLabel.text = "سمي بفرع دمياط لأن آخر المدن المصرية التي كان يمر بها قديمًا هي دمياط"
        }
    }
    
}
