//
//  CategoryUseCase.swift
//  Lier
//
//  Created by Pedro on 04-07-24.
//

import Foundation
import Combine

protocol CategoryUseCase {
    func getCategories() -> AnyPublisher<[Category], Error>
}
