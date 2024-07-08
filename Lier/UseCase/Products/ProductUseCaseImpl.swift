//
//  ProductUseCaseImpl.swift
//  Lier
//
//  Created by Pedro on 07-07-24.
//

import Foundation
import Combine

class ProductUseCaseImpl: ProductUseCase {
    let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    func getProducts() -> AnyPublisher<[Product], any Error> {
        return productRepository.getProducts()
    }
}
