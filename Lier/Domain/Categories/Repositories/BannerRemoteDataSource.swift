//
//  BannerRemoteDataSource.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

protocol BannerRemoteDataSource {
    func getPromotedBanners() -> AnyPublisher<[Banner], Error>
    func getBanners() -> AnyPublisher<[Banner], Error>
}
