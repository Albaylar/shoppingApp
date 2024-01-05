//
//  Home.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import Foundation

struct Car: Codable {
    let createdAt, name: String?
    let image: String?
    let price, description, model, brand: String?
    let id: String?
    

}

typealias Cars = [Car]
