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
    var selectedIndexPath: IndexPath?

    
    var cabTypes = [Cab]()
    var currentLocation = CLLocationCoordinate2D()
    var destination : GMSPlace?
    var source : String?
    var polyStringPath : String?
    var locationManager = CLLocationManager()
    let bookingViewModel = BookingViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cabTypes = bookingViewModel.setUpCabTypes()
        setupMapView()
        cabSelectionView.register(UINib(nibName: "CabView", bundle: nil), forCellWithReuseIdentifier: "Cab")
        rideLaterBtn.layer.borderColor = #colorLiteral(red: 0.262745098, green: 0.2588235294, blue: 0.3294117647, alpha: 1)
        rideLaterBtn.layer.borderWidth = 1.0
        cabSelectionView.allowsMultipleSelection = false
        self.setupNavigationBar()
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
        
        let rideViewModel = CabDetailViewModel()
        if let dest = destination?.coordinate{
            self.showSpinner(title: "Searching for cabs")
            rideViewModel.getNearbyCab(source: "\(currentLocation.latitude)|\(currentLocation.longitude)", destination: "\(dest.latitude)|\(dest.longitude)") { (status, cabDetail) in
                if status!{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RideDetailsViewController") as? RideDetailsViewController
                    vc?.cabDetail = cabDetail
                    vc?.polyString = self.polyStringPath
                    if let destName = self.destination?.name {
                        vc?.cabDetail?.destination = destName
                    }
                    if let originName = self.source{
                        vc?.cabDetail?.source = originName
                    }
                    self.removeSpinner()
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    
                }
            }
        }else{
            self.showAlert(Title: "Alert", Message: "Please select a valid Destination")
            //Invalid destination
        }
       

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
        
        destination = place
        
        bookingViewModel.drawPath(src: currentLocation, dst: place.coordinate) { (isSuccess, polyString) in
            self.bookingViewModel.drawPolylineAndAdjustCamera(mapView: self.mapView, polyString: polyString)
            self.polyStringPath = polyString
        }
        
        let destinationMarker = bookingViewModel.setupMarker(location: place.coordinate, title: place.name!, type: "Defaults")
        destinationMarker.map = mapView
        mapView.selectedMarker = destinationMarker
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

extension BookingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        currentLocation = location!.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        
        self.mapView?.animate(to: camera)
        location?.fetchCityAndCountry(completion: { (name, locality, error) in
            if let placeName = name{
                self.source = placeName
            }
        })
        self.locationManager.stopUpdatingLocation()
        
    }
}


extension BookingViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cabTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cab", for: indexPath) as! CabView
        cell.cabInfo = cabTypes[indexPath.row]
      
        if indexPath == selectedIndexPath {
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.setShadow(applyShadow: false)
        }else{
            cell.setShadow(applyShadow: true)
            cell.layer.borderWidth = 0.0
            cell.layer.borderColor = UIColor.gray.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cabSelectionView.cellForItem(at: indexPath) as? CabView
        if let collectionCell =  cell{
            collectionCell.layer.borderWidth = 1.0
            collectionCell.layer.borderColor = UIColor.gray.cgColor
            collectionCell.setShadow(applyShadow: false)
        }
        self.selectedIndexPath = indexPath
        cabSelectionView.reloadData()
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ name: String?, _ locality:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.name, $0?.first?.subLocality, $1) }
    }
}
