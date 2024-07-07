//
//  MockCategoryRemoteDataSource.swift
//  Lier
//
//  Created by Pedro on 04-07-24.
//

import Foundation
import Combine

class MockCategoryRemoteDataSource: CategoryRemoteDataSource {
    func getCategories() -> AnyPublisher<[Category], Error> {
        return Just([
            Category(name: "Pan molde", color: .randomPastelColor),
            Category(name: "Pan blanco", color: .randomPastelColor),
            Category(name: "Pan integral", color: .randomPastelColor),
            Category(name: "Pan envasado", color: .randomPastelColor),
            Category(name: "Pan congelado", color: .randomPastelColor),
            Category(name: "Pan importado", color: .randomPastelColor),
        ]).setFailureType(to: Error.self)
            .delay(for: 2, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
