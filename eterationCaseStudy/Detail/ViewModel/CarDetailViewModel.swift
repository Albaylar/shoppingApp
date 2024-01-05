//
//  CarDetailViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import Foundation

class CarDetailViewModel {
    private var car: Detail?
    
    init(car: Car?) {
        self.car = Detail(id: car?.id, name: car?.name, price: car?.price, description: car?.description, image: car?.image, brand: car?.brand)
    }
    var name: String {
        return car?.name ?? "Unknown"
    }
    
    var formattedPrice: String {
        return "\(car?.price ?? "N/A") "
    }
    
    var description: String {
        return car?.description ?? "No description available."
    }
    
    var imageURL: URL? {
        return URL(string: car?.image ?? "")
    }
    var brand : String {
        return car?.brand ?? ""
    }
}
