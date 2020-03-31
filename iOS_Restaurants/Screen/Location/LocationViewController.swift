//
//  LocationViewController.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/25/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import UIKit

protocol LocationActions: class {
    func didTouchAllow()
}

class LocationViewController: UIViewController {
    
    @IBOutlet weak var locationView: LocationView!
    weak var delegate: LocationActions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationView.didTouchAllow = {
            self.delegate?.didTouchAllow()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //dispose of any resources that can be recreated.
    }
}
