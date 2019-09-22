//
//  BookingViewController.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 22/09/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import MapKit

class BookingViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationBtn: UIButton!
    @IBOutlet weak var cabSelectionView: UICollectionView!
    @IBOutlet weak var rideLaterBtn: UIButton!
    @IBOutlet weak var rideNowBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

   
    @IBAction func rideLaterAction(_ sender: Any) {
    }
    
    
    @IBAction func rideNowAction(_ sender: Any) {
    }
}

