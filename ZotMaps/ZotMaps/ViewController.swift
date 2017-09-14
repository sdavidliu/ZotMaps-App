//
//  ViewController.swift
//  ZotMaps
//
//  Created by DL on 8/21/17.
//  Copyright © 2017 DL. All rights reserved.
//
//  To Do:
//  - 

import UIKit
import CoreLocation
import MapKit
import CNPPopupController

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    var locManager = CLLocationManager()
    var currentLocation = CLLocation()
    var destinationMapItem = MKMapItem()
    var popupController:CNPPopupController?
    let emitter = CAEmitterLayer()
    var animating = false
    var animationTimer = Timer()
    var count = 0
    let lightBlue = UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 164.0/255.0, alpha: 1.0)
    let darkBlue = UIColor(red: 27.0/255.0, green: 61.0/255.0, blue: 109.0/255.0, alpha: 1.0)
    let yellow = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    var tenSecCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locManager.requestWhenInUseAuthorization()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if let currentLocation = locManager.location{
                locManager.delegate = self
                locManager.startUpdatingLocation()
                //currentLocation = CLLocation(latitude: 33.648477, longitude: -117.840464)
                let latitude = currentLocation.coordinate.latitude
                let longitude = currentLocation.coordinate.longitude
                let startCoord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let adjustedRegion = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(startCoord, 300, 300))
                mapView.setRegion(adjustedRegion, animated: true)
            }else{
                showPopupWithStyle(title: "ERROR", subtitle: "Location Services", description: "Sorry. The app is having trouble finding your location. Try again later...")
            }
            
        }else{
            let startCoord = CLLocationCoordinate2D(latitude: 33.645905, longitude: -117.842739)
            let adjustedRegion = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(startCoord, 1000, 1000))
            mapView.setRegion(adjustedRegion, animated: true)
        }
        
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3
        button.layer.borderColor = yellow.cgColor
        button.addTarget(self, action: #selector(ViewController.test), for: .touchUpInside)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = lightBlue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            print("authorized when in use")
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            print("authorized always")
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = manager.location!
        //currentLocation = CLLocation(latitude: 33.648477, longitude: -117.840464)
        
        let lat = UserDefaults.standard.double(forKey: "Lat")
        let long = UserDefaults.standard.double(forKey: "Long")
        
        if (lat != 0.0 && long != 0.0) {
            
            tenSecCount += 1
            if (tenSecCount >= 10) {
                tenSecCount = 0
            }
            
            if (tenSecCount == 0) {
                
                let loc = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                //let destinationLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let sourcePlacemark = MKPlacemark(coordinate: loc, addressDictionary: nil)
                //let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
                let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                //let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                //let destinationAnnotation = MKPointAnnotation()
                //destinationAnnotation.title = UserDefaults.standard.string(forKey: "Name")
                //if let location = destinationPlacemark.location {
                //destinationAnnotation.coordinate = location.coordinate
                //}
                //self.mapView.showAnnotations([destinationAnnotation], animated: true )
                let directionRequest = MKDirectionsRequest()
                directionRequest.source = sourceMapItem
                directionRequest.destination = destinationMapItem
                directionRequest.transportType = .walking
                let directions = MKDirections(request: directionRequest)
                directions.calculate {
                    (response, error) -> Void in
                    
                    guard let response = response else {
                        if let error = error {
                            print("Error: \(error)")
                        }
                        
                        return
                    }
                    
                    let route = response.routes[0]
                    self.mapView.removeOverlays(self.mapView.overlays)
                    self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                    
                    let distance = Int((response.routes.first?.distance)!)
                    let time = Int((response.routes.first?.expectedTravelTime)!/60)
                    self.button.setTitle("~\(String(describing: distance)) meters   ~\(String(describing: time)) minutes", for: .normal)
                    self.button.isHidden = false
                    self.clearButton.isHidden = false
                    
                    //let adjustedRegion = self.mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(loc, 300, 300))
                    //self.mapView.setRegion(adjustedRegion, animated: true)
                }
            }
        }else{
            button.isHidden = true
            clearButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lat = UserDefaults.standard.double(forKey: "Lat")
        let long = UserDefaults.standard.double(forKey: "Long")
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            if (lat != 0.0 && long != 0.0){
                
                //currentLocation = CLLocation(latitude: 33.648477, longitude: -117.840464)
                if let currentLocation = locManager.location{
                    let loc = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                    let destinationLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let sourcePlacemark = MKPlacemark(coordinate: loc, addressDictionary: nil)
                    let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
                    let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                    destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                    let destinationAnnotation = MKPointAnnotation()
                    destinationAnnotation.title = UserDefaults.standard.string(forKey: "Name")
                    if let location = destinationPlacemark.location {
                        destinationAnnotation.coordinate = location.coordinate
                    }
                    self.mapView.showAnnotations([destinationAnnotation], animated: true )
                    self.mapView.selectAnnotation(destinationAnnotation, animated: false)
                    let directionRequest = MKDirectionsRequest()
                    directionRequest.source = sourceMapItem
                    directionRequest.destination = destinationMapItem
                    directionRequest.transportType = .walking
                    let directions = MKDirections(request: directionRequest)
                    directions.calculate {
                        (response, error) -> Void in
                        
                        guard let response = response else {
                            if let error = error {
                                print("Error: \(error)")
                            }
                            
                            return
                        }
                        
                        let route = response.routes[0]
                        self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                        
                        let distance = Int((response.routes.first?.distance)!)
                        let time = Int((response.routes.first?.expectedTravelTime)!/60)
                        self.button.setTitle("~\(String(describing: distance)) meters   ~\(String(describing: time)) minutes", for: .normal)
                        self.button.isHidden = false
                        self.clearButton.isHidden = false
                        
                        let adjustedRegion = self.mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(loc, 300, 300))
                        self.mapView.setRegion(adjustedRegion, animated: true)
                    }
                }
            }else{
                button.isHidden = true
                clearButton.isHidden = true
            }
        }else if (UserDefaults.standard.value(forKey: "test") != nil){
            showPopupWithStyle(title: "ERROR", subtitle: "Location Services", description: "Please turn on Location Services for the app in Settings --> Privacy --> Location Services --> ZotMaps to \"While Using the App.\"")
        }else{
            UserDefaults.standard.setValue("downloaded", forKey: "test")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func goToLocation(_ sender: UIButton) {
        if let currentLocation = locManager.location{
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            let startCoord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let adjustedRegion = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(startCoord, 300, 300))
            mapView.setRegion(adjustedRegion, animated: true)
        }else{
            showPopupWithStyle(title: "ERROR", subtitle: "Location Services", description: "Sorry. The app is having trouble finding your location. Try again later...")
        }
    }
    
    
    @IBAction func clear(_ sender: UIButton) {
        UserDefaults.standard.set(0.0, forKey: "Lat")
        UserDefaults.standard.set(0.0, forKey: "Long")
        UserDefaults.standard.set("", forKey: "Name")
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        button.isHidden = true
        self.clearButton.isHidden = true
    }
    
    func showPopupWithStyle(title: String, subtitle: String, description: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.center
        
        let title = NSAttributedString(string: title, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20), NSParagraphStyleAttributeName: paragraphStyle])
        let lineOne = NSAttributedString(string: subtitle, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 25), NSForegroundColorAttributeName: lightBlue, NSParagraphStyleAttributeName: paragraphStyle])
        let lineTwo = NSAttributedString(string: description, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSParagraphStyleAttributeName: paragraphStyle])
        
        let button = CNPPopupButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("OK", for: UIControlState())
        
        button.backgroundColor = lightBlue
        
        button.layer.cornerRadius = 4;
        button.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
        }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        
        let lineOneLabel = UILabel()
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        
        let lineTwoLabel = UILabel()
        lineTwoLabel.numberOfLines = 0;
        lineTwoLabel.attributedText = lineTwo;
        
        let popupController = CNPPopupController(contents:[titleLabel, lineOneLabel, lineTwoLabel, button])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.centered
        popupController.delegate = self
        self.popupController = popupController
        popupController.present(animated: true)
        
    }
    
    func test(sender: UIButton!){
        if (animating == false){
            animating = true
            
            let rect = CGRect(x: 0.0, y: -70.0, width: self.view.bounds.width, height: 50)
            
            emitter.birthRate = 1
            emitter.frame = rect
            self.view.layer.addSublayer(emitter)
            emitter.emitterShape = kCAEmitterLayerRectangle
            emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
            emitter.emitterSize = rect.size
            
            let emitterCell = CAEmitterCell()
            let date = Date()
            let calendar = Calendar.current
            let month = calendar.component(.month, from: date)
            if (month == 12 || month == 1 || month == 2){
                emitterCell.contents = UIImage(named: "winter.png")!.cgImage
            }else if (month == 3 || month == 4 || month == 5){
                emitterCell.contents = UIImage(named: "spring.png")!.cgImage
            }else if (month == 6 || month == 7 || month == 8){
                emitterCell.contents = UIImage(named: "summer.png")!.cgImage
            }else{
                emitterCell.contents = UIImage(named: "fall.png")!.cgImage
            }
            emitterCell.birthRate = 8
            emitterCell.lifetime = 15
            emitterCell.yAcceleration = 20.0
            emitterCell.xAcceleration = 1.0
            //    emitterCell.velocity = 20.0
            //    emitterCell.velocityRange = 250.0
            //    emitterCell.emissionLongitude = CGFloat(-M_PI)
            //    emitterCell.emissionRange = CGFloat(M_PI_2)
            emitterCell.scale = 1.8
            emitterCell.scaleRange = 1.0
            emitterCell.scaleSpeed = -0.15
            emitterCell.alphaRange = 1.00
            emitterCell.spin = 0.5
            emitterCell.spinRange = 1.0
            emitterCell.alphaSpeed = -0.15
            emitterCell.lifetimeRange = 2.0
            
            emitter.emitterCells = [emitterCell]
            
            animationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runAnimation), userInfo: nil, repeats: true)
        }
    }
    
    func runAnimation(){
        count += 1
        if (count > 5){
            emitter.birthRate = 0
            animating = false
            count = 0
            animationTimer.invalidate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : CNPPopupControllerDelegate {
    
    func popupControllerWillDismiss(_ controller: CNPPopupController) {
        //print("Popup controller will be dismissed")
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        //print("Popup controller presented")
    }
    
}

