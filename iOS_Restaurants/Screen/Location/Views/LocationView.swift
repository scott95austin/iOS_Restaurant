//
//  LocationView.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/25/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import UIKit

@IBDesignable class LocationView: BaseView {
    
    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var ignoreButton: UIButton!
    
    var didTouchAllow: (()->Void)?
    
    @IBAction func allowAction(_ sender: UIButton)
    {
        didTouchAllow?()
    }
    
    @IBAction func ignoreAction(_ sender: UIButton)
    {
        
    }

}
