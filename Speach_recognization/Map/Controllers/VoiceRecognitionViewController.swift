//
//  ViewController.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 16/08/2022.
//

import UIKit
import SpeechRecognizerButton

class VoiceRecognitionViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: SFButton!
    
    let annotationMarkerZoom = 10
    let placeMarkerZoom = 3
    var flage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        StartRecognize()
        
        // MARK: Remove these lines after finishing.
        self.ModeToNextPage(locationmodel: nil)
    }
    
    func StartRecognize() {
        button.speechRecognition = true
        button.locale = Locale(identifier: "Ara-Egpt")
        button.resultHandler = {
//            self.label.text =  $1?.bestTranscription.formattedString
            
            guard let placeName = $1?.bestTranscription.formattedString else { return }
            
            guard let location = self.DecidePlaceAr(text: placeName) else {
                if self.flage {
                    self.ModeToNextPage(locationmodel: nil)
                }
                return
            }
            
            if self.flage {
                self.ModeToNextPage(locationmodel: location)
            }
            
            
//            self.button.play()
        }
        
        button.errorHandler = {
            guard let error = $0 else {
                self.label.text = "Unknown error."
                return
            }
            switch error {
            case .authorization(let reason):
                switch reason {
                case .denied:
                    self.label.text = "Authorization denied."
                case .restricted:
                    self.label.text = "Authorization restricted."
                case .usageDescription(let key):
                    self.label.text = "Info.plist \"\(key)\" key is missing."
                }
            case .cancelled(let reason):
                switch reason {
                case .notFound:
                    self.label.text = "Cancelled, not found."
                case .user:
                    self.label.text = "Cancelled by user."
                }
            case .invalid(let locale):
                self.label.text = "Locale \"\(locale)\" not supported."
            case .unknown(let unknownError):
                self.label.text = unknownError?.localizedDescription
            default:
                self.label.text = error.localizedDescription
            }
        }
        
    }
    
    private func ModeToNextPage(locationmodel: locationModel?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let nextVc = story.instantiateViewController(withIdentifier: "mapViewControllerAr") as! mapViewController
            nextVc.modalPresentationStyle = .fullScreen
            nextVc.pickedLocation = locationmodel
            self.present(nextVc, animated: true)
        }
    }
    
    func DecidePlace(text: String) -> locationModel? {
        var locationmodel: locationModel?
        switch (text) {
            case "Cairo":
                locationmodel = locationModel(lati: 30.033333, long: 31.233334, placeName: "Cairo capital", placeArea: "3085", placeImage: "licensed-image", populationNumber: "10M", zoom: annotationMarkerZoom, markerStatus: true)
            break
            case "Alex", "Alexandria":
                locationmodel = locationModel(lati: 31.205753, long: 29.924526, placeName: "Alexandria", placeArea: "2679 KM", placeImage: "Alex Image", populationNumber: "5.2M", zoom: annotationMarkerZoom, markerStatus: true)
            break
            case "Luxour", "Luxor":
                locationmodel = locationModel(lati: 25.687243, long: 32.639637, placeName: "Luxor", placeArea: "416 KM", placeImage: "Louxur Image", populationNumber: "1.328M", zoom: annotationMarkerZoom, markerStatus: true)
            break
            case "Egypt":
                locationmodel = locationModel(lati: 26.8206, long: 30.8025, placeName: "Egypt", placeArea: "1M", placeImage: "Flag_of_Egypt", populationNumber: "102.3M", zoom: placeMarkerZoom, markerStatus: false)
            break
            case "Africa":
                locationmodel = locationModel(lati: 9.1021, long: 18.2812, placeName: "Africa", placeArea: "30.37M", placeImage: "caf", populationNumber: "102.3M", zoom: placeMarkerZoom, markerStatus: false)
            break
        default:
            self.label.text = "Error in recognize with " + text
            return nil
        }
        
        self.label.text = text
        
        return locationmodel
    }
    
    func DecidePlaceAr(text: String) -> locationModel? {
        var locationmodel: locationModel?
        
        if text.contains("القاهرة") {
            locationmodel = locationModel(lati: 30.033333, long: 31.233334, placeName: "القاهره الكبرى", placeArea: "٣٠٨٥ كم", placeImage: "licensed-image", populationNumber: "١٠م", zoom: annotationMarkerZoom, markerStatus: true)
            
            self.label.text = text
            
            return locationmodel
        }
        else if text.contains("الإسكندرية") || text.contains("الاسكندرية") {
            locationmodel = locationModel(lati: 31.205753, long: 29.924526, placeName: "الاسكندرية", placeArea: "٢٦٧٩ كم", placeImage: "Alex Image", populationNumber: "٥٫٢ م", zoom: annotationMarkerZoom, markerStatus: true)
            
            self.label.text = text
            
            return locationmodel
        }
        else if text.contains("الأقصر") {
            locationmodel = locationModel(lati: 25.687243, long: 32.639637, placeName: "الاقصر", placeArea: "٤١٦ كم", placeImage: "Louxur Image", populationNumber: "١٫٣٢م", zoom: annotationMarkerZoom, markerStatus: true)
            
            self.label.text = text
            
            return locationmodel
        }
        else if text.contains("مصر") {
            locationmodel = locationModel(lati: 26.8206, long: 30.8025, placeName: "مصر", placeArea: "١م كم", placeImage: "Flag_of_Egypt", populationNumber: "١٠٢٫٣م", zoom: placeMarkerZoom, markerStatus: false)
            
            self.label.text = text
            
            return locationmodel
        }
        else if text.contains("إفريقيا") {
            locationmodel = locationModel(lati: 9.1021, long: 18.2812, placeName: "إفريقيا", placeArea: "٣٠٫٣٧م كم", placeImage: "caf", populationNumber: "٢٠٢٫٣م", zoom: placeMarkerZoom, markerStatus: false)
            
            self.label.text = text
            
            return locationmodel
        }
        else if text.contains("المتاحف") {
            self.label.text = text
            flage = true
            return nil
        }
        else {
            self.label.text = "خطأ فى ادخال " + text
            flage = false
            return nil
        }
    }
}
