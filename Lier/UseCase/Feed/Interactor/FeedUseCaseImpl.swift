//
//  FeedUseCaseImpl.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

class FeedUseCaseImpl: FeedUseCase {
    let categoryRepository: CategoryRepository
    let bannerRepostiory: BannerRepository
    let productRepository: ProductRepository
    
    init(categoryRepository: CategoryRepository, bannerRepostiory: BannerRepository, productRepository: ProductRepository) {
        self.categoryRepository = categoryRepository
        self.bannerRepostiory = bannerRepostiory
        self.productRepository = productRepository
    }
    
    func getFeed() -> AnyPublisher<[FeedEntry], FeedError> {
        let productsPublisher = productRepository.getProducts()
        let bannersPublisher = bannerRepostiory.getBanners()
        let promotedBannersPublisher = bannerRepostiory.getPromotedBanners()
        return categoryRepository
            .getCategories()
            .tryMap { categories in
                guard !categories.isEmpty else {
                    throw FeedError.noCategories
                }
                return categories
            }.flatMap { categories in
                productsPublisher
                    .tryMap { products in
                        guard !products.isEmpty else {
                            throw FeedError.noProducts
                        }
                        var feed = [FeedEntry]()
                        feed.append(FeedEntry.categories(categories))
                        categories.forEach {
                            feed.append(FeedEntry.products($0, products.shuffled()))
                        }
                        return feed
                    }
            }.flatMap { feed in
                promotedBannersPublisher
                    .replaceError(with: [])
                    .map { promotedBanners in
                        var mutableFeed = feed
                        mutableFeed.append(FeedEntry.carrousselBanner(promotedBanners))
                        return mutableFeed
                    }
            }
            .flatMap { feed in
                bannersPublisher
                    .replaceError(with: [])
                    .map { banners in
                        var mutableFeed = feed
                        for banner in banners {
                            mutableFeed.append(FeedEntry.singleBanner(banner))
                        }
                        return mutableFeed
                    }
            }
            .map {
                $0.shuffled()
            }
            .mapError {
                $0 as? FeedError ?? FeedError.unknown
            }
            .eraseToAnyPublisher()
    }
}

enum FeedError: Error {
    case noCategories, noProducts, unknown
}
