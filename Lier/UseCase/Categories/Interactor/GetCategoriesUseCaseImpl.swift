//
//  GetCategoriesUseCaseImpl.swift
//  Lier
//
//  Created by Pedro on 04-07-24.
//

import Foundation
import Combine

class GetCategoriesUseCaseImpl: GetCategoriesUseCase {
    let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute() -> AnyPublisher<[Category], Error> {
        return categoryRepository.getCategories()
    }
}
