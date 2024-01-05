//
//  BasketVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit

class BasketVC: UIViewController {

    var basketItems: [Car] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }

    func addToBasket(car: Car) {
        self.basketItems.append(car)
        updateUI()
    }

    func updateUI() {
        // Implement your code to update the UI (e.g., reload a table view)
    }
}
