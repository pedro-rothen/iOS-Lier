//
//  GetPromotedBannersUseCase.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

protocol GetPromotedBannersUseCase {
    func execute() -> AnyPublisher<[Banner], Error>
}
