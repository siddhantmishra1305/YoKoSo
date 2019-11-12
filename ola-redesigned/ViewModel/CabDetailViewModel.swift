//
//  CabDetailViewModel.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 10/11/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import Foundation

class CabDetailViewModel{
    
    typealias cabCallback = (Bool?, CabDetail?) -> Void

    func getNearbyCab(source:String,destination:String,completion:@escaping cabCallback){
    
        ServerManager.sharedInstance.getCab(destination: destination, source: source) {(cabDetail, error) in
            if let error = error{
                print(error.details )
                completion(false,nil)
            }else{
                completion(true,cabDetail)
            }
        }
    }
}
