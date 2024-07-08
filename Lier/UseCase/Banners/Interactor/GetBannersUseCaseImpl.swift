//
//  GetBannersUseCaseImpl.swift
//  Lier
//
//  Created by Pedro on 08-07-24.
//

import Combine

class GetBannersUseCaseImpl: GetBannersUseCase {
    let bannerRepository: BannerRepository
    
    init(bannerRepository: BannerRepository) {
        self.bannerRepository = bannerRepository
    }
    
    func execute() -> AnyPublisher<[Banner], any Error> {
        return bannerRepository.getBanners()
    }
}
