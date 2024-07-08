//
//  BannerUseCase.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

///TODO:  Break into two use case, violating principle of single responsibility
protocol BannerUseCase {
    func getPromotedBanners() -> AnyPublisher<[Banner], Error>
    func getBanners() -> AnyPublisher<[Banner], Error>
}
