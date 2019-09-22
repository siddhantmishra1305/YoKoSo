//
//  CabTypes.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 22/09/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct Cab:Mappable{
    
    var cabType:String?
    var cabImage:UIImage?
    var waitTime:String?
    
    init?(map: Map) {
        
    }
    
    init?() {
        
    }
    
    mutating func mapping(map: Map) {
        cabType <- map["cabType"]
        cabImage <- map["image"]
        waitTime <- map["wait_time"]
    }
}
