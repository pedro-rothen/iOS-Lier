//
//  ProductRemoteDataSource.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

protocol ProductRemoteDataSource {
    func getProducts() -> AnyPublisher<[Product], Error>
}
