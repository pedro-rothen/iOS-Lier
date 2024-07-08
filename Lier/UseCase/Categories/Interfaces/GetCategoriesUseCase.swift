//
//  GetCategoriesUseCase.swift
//  Lier
//
//  Created by Pedro on 04-07-24.
//

import Foundation
import Combine

protocol GetCategoriesUseCase {
    func execute() -> AnyPublisher<[Category], Error>
}
