//
//  ProductUseCase.swift
//  Lier
//
//  Created by Pedro on 07-07-24.
//

import Foundation
import Combine

protocol ProductUseCase {
    func getProducts() -> AnyPublisher<[Product], Error>
}
