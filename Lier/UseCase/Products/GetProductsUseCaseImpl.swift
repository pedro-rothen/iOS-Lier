//
//  GetProductsUseCaseImpl.swift
//  Lier
//
//  Created by Pedro on 07-07-24.
//

import Foundation
import Combine

class GetProductsUseCaseImpl: GetProductsUseCase {
    let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    func execute() -> AnyPublisher<[Product], any Error> {
        return productRepository.getProducts()
    }
}
