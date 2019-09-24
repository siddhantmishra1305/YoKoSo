//
//  BookingViewController.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 22/09/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps


class BookingViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var destinationBtn: UIButton!
    @IBOutlet weak var cabSelectionView: UICollectionView!
    @IBOutlet weak var rideLaterBtn: UIButton!
    @IBOutlet weak var rideNowBtn: UIButton!
    
    var cabTypes = [Cab]()
    var currentLocation = CLLocationCoordinate2D()
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCabTypes()
        setupMapView()
        cabSelectionView.register(UINib(nibName: "CabView", bundle: nil), forCellWithReuseIdentifier: "Cab")
        rideLaterBtn.layer.borderColor = #colorLiteral(red: 0.262745098, green: 0.2588235294, blue: 0.3294117647, alpha: 1)
        rideLaterBtn.layer.borderWidth = 1.0
    }

    
    func setupMapView()  {
        self.mapView?.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.mapView.mapStyle(withFilename: "MapStyle", andType: "json")
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
   
    @IBAction func rideLaterAction(_ sender: Any) {
    }
    
    
    @IBAction func rideNowAction(_ sender: Any) {
    }
    
    
    @IBAction func destinationBtnAction(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
}


extension BookingViewController : GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.destinationBtn.setTitle(place.name, for: .normal)
//        let loc = CLLocationCoordinate2D(latitude: 13.1986, longitude: 77.7066)
        mapView.clear()
        draw(src: currentLocation, dst: place.coordinate)
        setupMarker(location: place.coordinate, title: place.name!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}

extension BookingViewController{
    
    func setUpCabTypes(){
        var cabMicro = Cab()
        cabMicro?.cabType = "Micro"
        cabMicro?.cabImage = #imageLiteral(resourceName: "Micro1")
//        cabMicro?.cabImage = #imageLiteral(resourceName: "Micro")
        cabMicro?.waitTime = "2 mins"
        
        var cabMini = Cab()
        cabMini?.cabType = "Mini"
        cabMini?.cabImage = #imageLiteral(resourceName: "Mini1")
//        cabMini?.cabImage = #imageLiteral(resourceName: "Mini")
        cabMini?.waitTime = "10 mins"
        
        var cabPrime = Cab()
        cabPrime?.cabType = "Prime"
        cabPrime?.cabImage = #imageLiteral(resourceName: "Prime1")
//        cabPrime?.cabImage = #imageLiteral(resourceName: "Prime")
        cabPrime?.waitTime = "15 mins"
        
        var cabLuxury = Cab()
        cabLuxury?.cabType = "Luxury"
        cabLuxury?.cabImage = #imageLiteral(resourceName: "Luxury1")
//        cabLuxury?.cabImage = #imageLiteral(resourceName: "Luxury")
        cabLuxury?.waitTime = "25 mins"
        
        var auto = Cab()
        auto?.cabType = "Auto"
        auto?.cabImage = #imageLiteral(resourceName: "Auto1")
//        auto?.cabImage = #imageLiteral(resourceName: "Auto")
        auto?.waitTime = "5 mins"
        
        cabTypes.append(cabMicro!)
        cabTypes.append(cabMini!)
        cabTypes.append(cabPrime!)
        cabTypes.append(cabLuxury!)
        cabTypes.append(auto!)
    }
}

extension BookingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        currentLocation = location!.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        
        self.mapView?.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&key=AIzaSyDBAsQ6kkBsTmMFg6S0Q17iITIrg_G-qPg")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
                        let preRoutes = json["routes"] as! NSArray
                        let routes = preRoutes[0] as! NSDictionary
                        let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                        let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                        
                        DispatchQueue.main.async(execute: {
                            let path = GMSPath(fromEncodedPath: polyString)
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeWidth = 2.0
                            polyline.strokeColor = UIColor.black
                            polyline.map = self.mapView
                        })
                    }
                    
                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
    }
    
    
    func setupMarker(location:CLLocationCoordinate2D,title:String){
        let marker = GMSMarker()
        
        let img = UIImage(named: "MapMarker")!.withRenderingMode(.alwaysTemplate)
        let markerImage = self.imageWithImage(image: img, scaledToSize: CGSize(width: 30.0, height: 30.0))
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        //changing the tint color of the image
        markerView.tintColor = #colorLiteral(red: 0.262745098, green: 0.2588235294, blue: 0.3294117647, alpha: 1)
        
        marker.position = location
        marker.iconView = markerView
//        marker.title = title
        marker.map = mapView
       
        
        //comment this line if you don't wish to put a callout bubble
        mapView.selectedMarker = marker
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}


extension BookingViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cabTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cab", for: indexPath) as! CabView
        cell.cabInfo = cabTypes[indexPath.row]

        return cell
    }
    
    
}


extension BookingViewController : UICollectionViewDelegate{
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cabSelectionView.cellForItem(at: indexPath) as! CabView
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.setShadow(applyShadow: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cabSelectionView.cellForItem(at: indexPath) as! CabView
        cell.setShadow(applyShadow: true)
        cell.layer.borderWidth = 0.0
        cell.layer.borderColor = UIColor.gray.cgColor
    }
    
}
