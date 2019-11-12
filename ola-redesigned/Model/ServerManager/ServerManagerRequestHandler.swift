//
//  ServerManagerRequestHandler.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 10/11/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import Foundation
import Alamofire

internal enum ServerRequestRouter: URLRequestConvertible{
    
    static var baseURLString:String{
        return "https://yokoso2.free.beeceptor.com/"
    }
    
    case getCabs(String,String)
    case getPath(String,String,Bool)
   
    

    var httpMethod:Alamofire.HTTPMethod {
        switch self {
            case .getCabs:
                return .get
            
            case .getPath:
                return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .getCabs:
            return "\(ServerRequestRouter.baseURLString)"+"getCab"
            
        case .getPath:
            return "https://maps.googleapis.com/maps/api/directions/json"
        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        let URL = Foundation.URL(string: path)!
        var mutableURLRequest = URLRequest(url: URL)
        mutableURLRequest.httpMethod = httpMethod.rawValue
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch  self {
        
            case .getCabs(let source,let destination):
                 do{
                    var params = [String:Any]()
                    params["source"] = source
                    params["destination"] = destination
                
                    let encoding = URLEncoding(destination: URLEncoding.Destination.queryString)
                    return try encoding.encode(mutableURLRequest, with: params)
                } catch {
                    return mutableURLRequest
                }
            
        case .getPath(let origin,let destination,let sensor):
              do{
                    var params = [String:Any]()
                    params["origin"] = origin
                    params["destination"] = destination
                    params["sensor"] = sensor
                    params["key"] = "AIzaSyDBAsQ6kkBsTmMFg6S0Q17iITIrg_G-qPg"
                
                           
                    let encoding = URLEncoding(destination: URLEncoding.Destination.queryString)
                    return try encoding.encode(mutableURLRequest, with: params)
              } catch {
                    return mutableURLRequest
              }
        }
    }
}
