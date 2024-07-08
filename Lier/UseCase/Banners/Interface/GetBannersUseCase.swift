//
//  GetBannersUseCase.swift
//  Lier
//
//  Created by Pedro on 08-07-24.
//

import Foundation
import Combine

protocol GetBannersUseCase {
    func execute() -> AnyPublisher<[Banner], Error>
}
