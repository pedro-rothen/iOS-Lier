//
//  CategoryUseCaseImpl.swift
//  Lier
//
//  Created by Pedro on 04-07-24.
//

import Foundation
import Combine

class CategoryUseCaseImpl: CategoryUseCase {
    let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func getCategories() -> AnyPublisher<[Category], Error> {
        return categoryRepository.getCategories()
    }
}
