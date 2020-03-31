//
//  FoodInfoViewController.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/24/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import UIKit
import AlamofireImage
import MapKit
import CoreLocation

class FoodInfoViewController: UIViewController {
    
    @IBOutlet weak var foodInfoView: FoodInfoView?
    var viewModel: DetailsViewModel? {
        didSet{
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        foodInfoView?.collectionView?.register(FoodInfoCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        foodInfoView?.collectionView?.dataSource = self
        foodInfoView?.collectionView?.delegate = self
    }
    
    func updateView() {
        if let viewModel = viewModel {
            foodInfoView?.priceLabel?.text = viewModel.price
            foodInfoView?.timeLabel?.text = viewModel.isOpen
            foodInfoView?.locationLabel?.text = viewModel.phoneNumber
            foodInfoView?.ratingLabel?.text = viewModel.rating
            foodInfoView?.collectionView?.reloadData()
            centerMap(for: viewModel.coordinates)
            title = viewModel.name
        }
    }
    
    func centerMap(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        foodInfoView?.mapView?.addAnnotation(annotation)
        foodInfoView?.mapView?.setRegion(region, animated: true)
    }
}

extension FoodInfoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.imageURL.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! FoodInfoCollectionViewCell
        if let url = viewModel?.imageURL[indexPath.item] {
            cell.imageView.af_setImage(withURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        foodInfoView?.pageControl?.currentPage = indexPath.item
    }
}
