//
//  GetProductsUseCase.swift
//  Lier
//
//  Created by Pedro on 07-07-24.
//

import Foundation
import Combine

protocol GetProductsUseCase {
    func execute() -> AnyPublisher<[Product], Error>
}
