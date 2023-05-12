//
//  RequestHandler.swift
//  OnTopPoke
//
//  Created by Lucas Farah on 12/05/23.
//

import Foundation
import Alamofire

class RequestHandler: RequestHandling {
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func request<T: Codable>(route: APIRoute, completion: @escaping (Result<T, Error>) -> Void) throws {
        AF.request(route.asRequest()).responseDecodable(of: T.self, decoder: decoder) { result in
            switch result.result {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
