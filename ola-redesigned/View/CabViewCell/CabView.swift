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
    
    func setShadow(applyShadow : Bool) {
        if applyShadow {
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 2
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        } else {
            self.layer.shadowRadius = 0
            self.layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    
    
    public var cabInfo = Cab(){
        didSet{
        
            self.layer.cornerRadius = 10.0
            self.layer.masksToBounds = true
            
            self.setShadow(applyShadow: true)

            
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
