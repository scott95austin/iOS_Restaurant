//
//  RestaurantTableTableViewController.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/24/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import UIKit

protocol ListActions: class {
    func didTouchAllow(_ viewController: UIViewController, viewModel: RestaurantListViewModel)
}

class RestaurantTableTableViewController: UITableViewController {
    
    var viewModels = [RestaurantListViewModel]()
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: ListActions?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell

        let vm = viewModels[indexPath.row]
        cell.configure(with: vm)

        return cell
    }
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let foodInfoViewController = storyboard?.instantiateViewController(withIdentifier: "FoodInfoViewController") else { return }
        navigationController?.pushViewController(foodInfoViewController, animated: true)
        let vm = viewModels[indexPath.row]
        delegate?.didTouchAllow(foodInfoViewController, viewModel: vm)
    }
}
