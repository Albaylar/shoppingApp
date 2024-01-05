//
//  CarService.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import Foundation
import Alamofire

final class CarService {
    
    static let shared = CarService()

    func getCars(success: @escaping([Car])->(), failure: @escaping(ErrorMessage)->()) {
        // API'niz için doğru URL'yi kullanın.
        let url = "https://5fc9346b2af77700165ae514.mockapi.io/products" // Örnek URL

        NetworkManager.shared.request(type: [Car].self, url: url, headers: Header.shared.header(), params: nil, method: .get) { response in
            switch response {
            case .success(let cars):
                success(cars)
            case .messageFailure(let errorMessage):
                failure(errorMessage)
            }
        }
    }

    // Diğer fonksiyonlar...
}


