//
//  BaseView.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/24/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import UIKit

@IBDesignable class BaseView: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    func configure()
    {
        
    }
}
