//
//  ProductRepositoryImpl.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

class ProductRepositoryImpl: ProductRepository {
    let productRemoteDataSource: ProductRemoteDataSource
    
    init(productRemoteDataSource: ProductRemoteDataSource) {
        self.productRemoteDataSource = productRemoteDataSource
    }
    
    func getProducts() -> AnyPublisher<[Product], Error> {
        return productRemoteDataSource.getProducts()
    }
}
