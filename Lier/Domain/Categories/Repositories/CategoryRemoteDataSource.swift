//
//  CategoryRemoteDataSource.swift
//  Lier
//
//  Created by Pedro on 04-07-24.
//

import Foundation
import Combine

protocol CategoryRemoteDataSource {
    func getCategories() -> AnyPublisher<[Category], Error>
}
