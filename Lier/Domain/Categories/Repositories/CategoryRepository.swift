//
//  CategoryRepository.swift
//  Lier
//
//  Created by Pedro on 04-07-24.
//

import Foundation
import Combine

protocol CategoryRepository {
    func getCategories() -> AnyPublisher<[Category], Error>
}
