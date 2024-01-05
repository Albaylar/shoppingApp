//
//  NetworkUtilitiy.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import Foundation
import Alamofire

enum ApiConfig: String {
    case baseUrl = "https://5fc9346b2af77700165ae514.mockapi.io/products"
}
struct Header {
    static let shared = Header()
    func header() -> HTTPHeaders { return ["Content-Type": "application/json"] }
}

enum NetworkResponse<T> {
    case success(T)
    case messageFailure(ErrorMessage)
}
extension Data {
    func decode<T: Decodable>() throws -> T {
        return (try! JSONDecoder().decode(T.self, from: self))
    }
}
