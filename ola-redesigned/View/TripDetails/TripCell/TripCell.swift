//
//  TripCell.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 09/11/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit

class TripCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var srcIcon: UIImageView!
    @IBOutlet weak var destinationIcon: UIImageView!
 
    
    var tripDetail:CabDetail?{
        didSet{
            source.text = tripDetail?.source
            destination.text = tripDetail?.destination
            let symbol = getSymbol(forCurrencyCode: "INR")
            if let prc = tripDetail?.price{
                 price.text = "\(symbol!)\(prc)"
            }
            time.text = getTime()
        }
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    func getTime()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy,hh:mm T"
        let currentDate = dateFormatter.string(from: Date())
        return currentDate
    }
}
