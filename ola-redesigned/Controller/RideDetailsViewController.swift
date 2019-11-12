//
//  RideDetailsViewController.swift
//  ola-redesigned
//
//  Created by Siddhant Mishra on 09/11/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit

class RideDetailsViewController: UIViewController {

    @IBOutlet weak var tripTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    var cabDetail : CabDetail?
    var polyString : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripTableView.register(UINib(nibName: "DriverDetailCell", bundle: nil), forCellReuseIdentifier: "DriverDetailCell")
        tripTableView.register(UINib(nibName: "TripCell", bundle: nil), forCellReuseIdentifier: "TripCell")
        tripTableView.register(UINib(nibName: "CabDetailCell", bundle: nil), forCellReuseIdentifier: "CabDetailCell")
    }
    

    @IBAction func cancelBtnAction(_ sender: Any) {
    }
}

extension RideDetailsViewController: UITableViewDelegate,UITableViewDataSource{
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 250
        } else if indexPath.section == 1 {
            return 78
        } else {
            return 42
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        } else{
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          
            let view = UIView()
            view.backgroundColor = .clear
            return view
           
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CabDetailCell", for: indexPath) as! CabDetailCell
            cell.cabDetails = cabDetail
//            cell.setShadow(applyShadow: true)
            cell.path = polyString
            
            return cell
            
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
            cell.tripDetail = cabDetail

            return cell

        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DriverDetailCell", for: indexPath) as! DriverDetailCell
            
            cell.driverDetails = cabDetail

            return cell
        }
    }
}
