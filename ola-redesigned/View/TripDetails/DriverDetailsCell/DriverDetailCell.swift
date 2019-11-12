//
//  DriverDetailCell.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 09/11/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import HCSStarRatingView

class DriverDetailCell: UITableViewCell {

    @IBOutlet weak var driverProfilePic: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverRating: HCSStarRatingView!
    
    var driverDetails:CabDetail?{
        didSet{
            driverName.text = driverDetails?.driverName
            driverRating.value = CGFloat(driverDetails!.driverRating)
        }
    }



}
