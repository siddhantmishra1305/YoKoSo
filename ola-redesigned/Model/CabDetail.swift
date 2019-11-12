//
//  CabDetail.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 10/11/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import Foundation
import ObjectMapper

struct CabDetail:Mappable {
    var cabName = String()
    var cabRegistrationId = String()
    var destination = String()
    var source = String()
    var price = Double()
    var driverName = String()
    var driverRating = Float()
    var driverProfilePic = String()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        cabName <- map["CabName"]
        cabRegistrationId <- map["CabRegistrationId"]
        destination <- map["Destination"]
        source <- map["Source"]
        price <- map["Price"]
        driverName <- map["DriverName"]
        driverRating <- map["DriverRating"]
        driverProfilePic <- map["DriverProfilePic"]
       
    }
    
    
    
    
    
    
}
