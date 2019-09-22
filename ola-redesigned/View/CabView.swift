//
//  CabView.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 22/09/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit

class CabView: UICollectionViewCell {

    @IBOutlet weak var cabType: UILabel!
    @IBOutlet weak var cabImage: UIImageView!
    @IBOutlet weak var waitingTime: UILabel!
    
 
    var cabInfo = Cab(){
        didSet{
            if let cabTypeValue = cabInfo?.cabType{
                cabType.text = cabTypeValue
            }
            
            if let waitingTimeValue = cabInfo?.waitTime{
                waitingTime.text = waitingTimeValue
            }
            
            if let cabImageUrl = cabInfo?.cabImage{
                cabImage.image = cabImageUrl
            }
            
            
            
        }
    }
}
