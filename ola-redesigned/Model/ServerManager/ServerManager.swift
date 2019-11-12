//
//  ServerManager.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 10/11/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

public enum ServerErrorCodes: Int{
    case notFound = 404
    case validationError = 422
    case internalServerError = 500
    
}


public enum ServerErrorMessages: String{
    case notFound = "Not Found"
    case validationError = "Validation Error"
    case internalServerError = "Internal Server Error"
}


public enum ServerError: Error{
    case systemError(Error)
    case customError(String)
    
    public var details:(code:Int ,message:String){
        switch self {
            
        case .customError(let errorMsg):
            switch errorMsg {
            case "Not Found":
                return (ServerErrorCodes.notFound.rawValue,ServerErrorMessages.notFound.rawValue)
            case "Validation Error":
                return (ServerErrorCodes.validationError.rawValue,ServerErrorMessages.validationError.rawValue)
            case "Internal Server Error":
                 return (ServerErrorCodes.internalServerError.rawValue,ServerErrorMessages.internalServerError.rawValue)
            default:
                return (ServerErrorCodes.internalServerError.rawValue,ServerErrorMessages.internalServerError.rawValue)
            }
            
        case .systemError(let errorCode):
            return (errorCode._code,errorCode.localizedDescription)
        }
    }
}

public struct ServerManager{
    
    static let sharedInstance = ServerManager()
    
    func getCab(destination:String,source:String,_ handler:@escaping (CabDetail?,ServerError?) -> Void){
        
        Alamofire.request(ServerRequestRouter.getCabs(source, destination)).validate().responseJSON
            {(response) in
            
            switch response.result {
        
            case .success:
                    let json = response.result.value as? [String: Any]
                    let data = CabDetail(JSON: json!)
                    handler(data,nil)
                
            case .failure(let error):

                print(error)
                if error.localizedDescription .contains("404"){
                    handler(nil,ServerError.customError("Not Found"))
                } else if error.localizedDescription.contains("422") {
                    handler(nil,ServerError.customError("Validation Error"))
                } else if error.localizedDescription.contains("500"){
                    handler(nil,ServerError.customError("Internal Server Error"))
                }
                else{
                    handler(nil,ServerError.systemError(error))
                }
            }
        }
    }
    
    
    func getPath(origin:String,destination:String,sensor:Bool,_ handler: @escaping (String?,ServerError?) -> Void){
        
        Alamofire.request(ServerRequestRouter.getPath(origin, destination, sensor)).validate().responseJSON
                {(response) in
                
                switch response.result {
            
                case .success:
                    if let json = response.result.value as? [String: Any]{
                        let preRoutes = json["routes"] as! NSArray
                        if preRoutes.count > 0 {
                            let routes = preRoutes[0] as! NSDictionary
                            let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                            let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                            handler(polyString,nil)
                        }else{
                            handler(nil,ServerError.customError("404"))
                        }
                       
                    }else{
                        handler(nil,ServerError.customError("404"))
                    }
                        
                    
                case .failure(let error):

                    print(error)
                    if error.localizedDescription .contains("404"){
                        handler(nil,ServerError.customError("Not Found"))
                    } else if error.localizedDescription.contains("422") {
                        handler(nil,ServerError.customError("Validation Error"))
                    } else if error.localizedDescription.contains("500"){
                        handler(nil,ServerError.customError("Internal Server Error"))
                    }
                    else{
                        handler(nil,ServerError.systemError(error))
                    }
                }
            }
    }
    
    
    
    
}
