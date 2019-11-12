//
//  BookingViewModel.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 08/10/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces
import GoogleMaps

class BookingViewModel{

    typealias routeCallback = (Bool?, String?) -> Void

    func drawPath(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D ,completion:@escaping routeCallback) {
        ServerManager.sharedInstance.getPath(origin: "\(src.latitude),\(src.longitude)", destination: "\(dst.latitude),\(dst.longitude)", sensor: false) { (response, error) in
            if error != nil{
                completion(false,error?.details.message)
            }else{
                completion(true,response)
            }
        }
    }
    
    
    func setUpCabTypes() -> [Cab] {
            var cabMicro = Cab()
            var cabs = [Cab]()
        
            cabMicro?.cabType = "Micro"
            cabMicro?.cabImage = #imageLiteral(resourceName: "Mini1")
            cabMicro?.waitTime = "2 mins"
            
            var cabMini = Cab()
            cabMini?.cabType = "Mini"
            cabMini?.cabImage = #imageLiteral(resourceName: "Micro1")
            cabMini?.waitTime = "10 mins"
            
            var cabPrime = Cab()
            cabPrime?.cabType = "Prime"
            cabPrime?.cabImage = #imageLiteral(resourceName: "Prime1")
            cabPrime?.waitTime = "15 mins"
            
            var cabLuxury = Cab()
            cabLuxury?.cabType = "Luxury"
            cabLuxury?.cabImage = #imageLiteral(resourceName: "Luxury")
            cabLuxury?.waitTime = "25 mins"
            
            var auto = Cab()
            auto?.cabType = "Auto"
            auto?.cabImage = #imageLiteral(resourceName: "Auto1")
            auto?.waitTime = "5 mins"
            
            cabs.append(cabMicro!)
            cabs.append(cabMini!)
            cabs.append(cabPrime!)
            cabs.append(cabLuxury!)
            cabs.append(auto!)
     
            return cabs
        }
    
    func setupMarker(location:CLLocationCoordinate2D,title:String,type:String) -> GMSMarker{
           let marker = GMSMarker()
            var img = UIImage()
            if type == "Source"{
                img = UIImage(named: "SourceMarker")!.withRenderingMode(.alwaysTemplate)
            }else if type == "Destination"{
                img = UIImage(named: "DestinationMarker")!.withRenderingMode(.alwaysTemplate)
            } else{
                img = UIImage(named: "DefaultMarker")!.withRenderingMode(.alwaysTemplate)
        }
           
           let markerImage = self.imageWithImage(image: img, scaledToSize: CGSize(width: 25.0, height: 25.0))
           
           //creating a marker view
           let markerView = UIImageView(image: markerImage)
           
           //changing the tint color of the image
           markerView.tintColor = #colorLiteral(red: 0.262745098, green: 0.2588235294, blue: 0.3294117647, alpha: 1)
           
           marker.position = location
           marker.iconView = markerView
           return marker
       }
    
    func drawPolylineAndAdjustCamera(mapView:GMSMapView?,polyString:String?){
        DispatchQueue.main.async(execute: {
            if let mapString = polyString{
                let path = GMSPath(fromEncodedPath: mapString)
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 2.0
                polyline.strokeColor = UIColor.black
                polyline.map = mapView
                    if mapView != nil
                    {
                        let bounds = GMSCoordinateBounds(path: path!)
                        mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                    }
              }
        })
    }
       
       func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
           image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
           let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
           return newImage
       }
    
}
