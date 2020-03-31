//
//  FoodInfoView.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/24/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class FoodInfoView: BaseView
{
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var pageControl: UIPageControl?
    @IBOutlet weak var priceLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var locationLabel: UILabel?
    @IBOutlet weak var mapView: MKMapView?
    
    @IBAction func handleControl(_ sender: UIPageControl)
    {
        
    }
}
