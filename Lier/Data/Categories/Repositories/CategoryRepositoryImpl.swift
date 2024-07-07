//
//  CategoryRepositoryImpl.swift
//  Lier
//
//  Created by Pedro on 04-07-24.
//

import Foundation
import Combine

class CategoryRepositoryImpl: CategoryRepository {
    let remoteDataSource: CategoryRemoteDataSource
    
    init(remoteDataSource: CategoryRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getCategories() -> AnyPublisher<[Category], Error> {
        return remoteDataSource.getCategories()
    }
}
