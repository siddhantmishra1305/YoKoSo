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
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&key=AIzaSyDBAsQ6kkBsTmMFg6S0Q17iITIrg_G-qPg")!
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
           
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        let preRoutes = json["routes"] as! NSArray
                        if preRoutes.count > 0 {
                            let routes = preRoutes[0] as! NSDictionary
                            let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                            let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                                completion(true,polyString)
                        } else {
                                completion(false,nil)
                        }
                    }
                    
                } catch {
                    print("Parsing error")
                }
            }
        })
        task.resume()
    }
    
    
    func setUpCabTypes() -> [Cab] {
            var cabMicro = Cab()
            var cabs = [Cab]()
        
            cabMicro?.cabType = "Micro"
            cabMicro?.cabImage = #imageLiteral(resourceName: "Micro1")
            cabMicro?.waitTime = "2 mins"
            
            var cabMini = Cab()
            cabMini?.cabType = "Mini"
            cabMini?.cabImage = #imageLiteral(resourceName: "Mini1")
            cabMini?.waitTime = "10 mins"
            
            var cabPrime = Cab()
            cabPrime?.cabType = "Prime"
            cabPrime?.cabImage = #imageLiteral(resourceName: "Prime1")
            cabPrime?.waitTime = "15 mins"
            
            var cabLuxury = Cab()
            cabLuxury?.cabType = "Luxury"
            cabLuxury?.cabImage = #imageLiteral(resourceName: "Luxury1")
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
    
    func setupMarker(location:CLLocationCoordinate2D,title:String) -> GMSMarker{
           let marker = GMSMarker()
           
           let img = UIImage(named: "MapMarker")!.withRenderingMode(.alwaysTemplate)
           let markerImage = self.imageWithImage(image: img, scaledToSize: CGSize(width: 30.0, height: 30.0))
           
           //creating a marker view
           let markerView = UIImageView(image: markerImage)
           
           //changing the tint color of the image
           markerView.tintColor = #colorLiteral(red: 0.262745098, green: 0.2588235294, blue: 0.3294117647, alpha: 1)
           
           marker.position = location
           marker.iconView = markerView
           return marker
       }
       
       func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
           image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
           let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
           return newImage
       }
    
}
