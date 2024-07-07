//
//  ProductRepository.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

protocol ProductRepository {
    func getProducts() -> AnyPublisher<[Product], Error>
}
