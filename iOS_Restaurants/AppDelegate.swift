//
//  AppDelegate.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/23/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window = UIWindow()
    let locationServices = LocationServices()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpServices.BusinessProvider>()
    let jsonDecoder = JSONDecoder()
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        //needed for the Yelp API json
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        locationServices.didChangeStatus = { [weak self] success in
            if success
            {
                self?.locationServices.getLocation()
            }
        }
        
        locationServices.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                self?.loadBusinesses(with: location.coordinate)
            case .failure(let error):
                assertionFailure("Error obtaining user's current location \(error)")
            }
        }
        
        switch locationServices.status {
        case .denied, .restricted, .notDetermined:
            let locationViewController = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
            locationViewController?.delegate = self
            window.rootViewController = locationViewController
        default:
            let nav = storyboard.instantiateViewController(withIdentifier: "RestaurantNavigationController") as? UINavigationController
            self.navigationController = nav
            window.rootViewController = nav
            locationServices.getLocation()
            (nav?.topViewController as? RestaurantTableTableViewController)?.delegate = self
        }
        window.makeKeyAndVisible()
        return true
    }
    
    private func loadDetails(for viewController: UIViewController, withID id: String){
        service.request(.details(id: id)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else {return}
                if let details = try? strongSelf.jsonDecoder.decode(Details.self, from: response.data)
                {
                    let detailsViewModel = DetailsViewModel(details: details)
                    (viewController as? FoodInfoViewController)?.viewModel = detailsViewModel
                }
            case .failure(let error):
                print("Failed to retreive details \(error)")
            }
        }
    }
    
    private func loadBusinesses(with coordinate: CLLocationCoordinate2D) {
        service.request(.search(lat: coordinate.latitude, long: coordinate.longitude)) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                let root = try? strongSelf.jsonDecoder.decode(Root.self, from: response.data)
                let viewModels = root?.businesses
                    .compactMap(RestaurantListViewModel.init)
                    .sorted(by: {$0.distance < $1.distance})
                if let nav = strongSelf.window.rootViewController as? UINavigationController,
                    let restaurantListViewController = nav.topViewController as? RestaurantTableTableViewController {
                    restaurantListViewController.viewModels = viewModels ?? []
                } else if let nav = strongSelf.storyboard
                    .instantiateViewController(withIdentifier: "RestaurantNavigationController") as? UINavigationController {
                    strongSelf.navigationController = nav
                    strongSelf.window.rootViewController?.present(nav, animated: true) {
                        (nav.topViewController as? RestaurantTableTableViewController)?.delegate = self
                        (nav.topViewController as? RestaurantTableTableViewController)?.viewModels = viewModels ?? []
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

extension AppDelegate: LocationActions, ListActions {
    func didTouchAllow() {
        locationServices.requestLocationAuthorization()
    }
    
    func didTouchAllow(_ viewController: UIViewController, viewModel: RestaurantListViewModel) {
        loadDetails(for: viewController, withID: viewModel.id)
    }
}
