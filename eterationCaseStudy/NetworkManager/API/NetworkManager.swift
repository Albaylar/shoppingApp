//
//  NetworkManager.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func request<T: Decodable>(type: T.Type, url: String, headers: HTTPHeaders?, params: [String: Any]?, method: HTTPMethod, completion: @escaping (NetworkResponse<T>) -> Void) {
        AF.request(url,
                   method: method,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: headers).responseData { response in
            if let code = response.response?.statusCode {
                switch code {
                case 200...299:
                    guard let data = response.data, let model = try? JSONDecoder().decode(T.self, from: data) else { return }
                    completion(.success(model))
                default:
                    completion(.messageFailure(ErrorMessage(error: "Server Error")))
                }
            }
        }
    }
}

