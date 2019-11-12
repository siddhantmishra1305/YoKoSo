//
//  CabDetails.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 09/11/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class CabDetailCell: UITableViewCell {

    @IBOutlet weak var tripMapView: GMSMapView!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carRegistrationNumber: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var cabDetailView: UIView!
    
    func setupMapView()  {
//        self.tripMapView?.isMyLocationEnabled = true
//        self.tripMapView.mapStyle(withFilename: "MapStyle", andType: "json")
        tripMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
        
    var cabDetails: CabDetail?{
        didSet{
            carName.text = cabDetails?.cabName
            carRegistrationNumber.text = cabDetails?.cabRegistrationId
        }
    }
    
    var path:String?{
        didSet{
            self.setupMapView()
            tripMapView.layer.cornerRadius = 10.0
            tripMapView.layer.masksToBounds = true
            self.setShadow(applyShadow: true)
            let bookingViewModel = BookingViewModel()
            bookingViewModel.drawPolylineAndAdjustCamera(mapView: tripMapView, polyString: path!)
        }
    }
    
    func setShadow(applyShadow : Bool) {
        cabDetailView.layer.cornerRadius = 6

        // border
//        cabDetailView.layer.borderWidth = 0.01
//        cabDetailView.layer.borderColor = UIColor.black.cgColor

        // shadow
//        cabDetailView.layer.shadowColor = UIColor.black.cgColor
//        cabDetailView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        cabDetailView.layer.shadowOpacity = 0.7
//        cabDetailView.layer.shadowRadius = 4.0
        
        cabDetailView.layer.shadowOffset = CGSize.zero
                   cabDetailView.layer.shadowColor = UIColor.darkGray.cgColor
                   cabDetailView.layer.shadowOpacity = 0.5
                   cabDetailView.layer.shadowRadius = 2
    }
    
}

           
           
