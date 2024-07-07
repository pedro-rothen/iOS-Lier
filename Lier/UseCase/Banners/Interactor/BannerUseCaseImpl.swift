//
//  BannerUseCaseImpl.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

class BannerUseCaseImpl: BannerUseCase {
    let bannerRepository: BannerRepository
    
    init(bannerRepository: BannerRepository) {
        self.bannerRepository = bannerRepository
    }
    
    func getPromotedBanners() -> AnyPublisher<[Banner], any Error> {
        return bannerRepository.getPromotedBanners()
    }
    
    func getBanners() -> AnyPublisher<[Banner], any Error> {
        return bannerRepository.getBanners()
    }
}
