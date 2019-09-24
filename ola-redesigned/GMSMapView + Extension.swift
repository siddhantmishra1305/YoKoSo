//
//  GMSMapView + Extension.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 24/09/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

extension GMSMapView {
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
}
