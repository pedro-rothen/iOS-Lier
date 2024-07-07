//
//  BannerRepositoryImpl.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

class BannerRepositoryImpl: BannerRepository {
    let bannerDataSource: BannerRemoteDataSource
    
    init(bannerDataSource: BannerRemoteDataSource) {
        self.bannerDataSource = bannerDataSource
    }
    
    func getPromotedBanners() -> AnyPublisher<[Banner], any Error> {
        return bannerDataSource.getPromotedBanners()
    }
    
    func getBanners() -> AnyPublisher<[Banner], any Error> {
        return bannerDataSource.getBanners()
    }
}
