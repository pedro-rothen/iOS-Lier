//
//  GetFeedUseCaseImpl.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

class GetFeedUseCaseImpl: GetFeedUseCase {
    let categoriesUseCase: GetCategoriesUseCase
    let bannersUseCase: GetBannersUseCase
    let promotedBannersUseCase: GetPromotedBannersUseCase
    let productsUseCase: GetProductsUseCase
    
    init(categoriesUseCase: GetCategoriesUseCase, bannersUseCase: GetBannersUseCase, promotedBannersUseCase: GetPromotedBannersUseCase, productsUseCase: GetProductsUseCase) {
        self.categoriesUseCase = categoriesUseCase
        self.bannersUseCase = bannersUseCase
        self.promotedBannersUseCase = promotedBannersUseCase
        self.productsUseCase = productsUseCase
    }
    
    //TODO: Make this method smaller
    func execute() -> AnyPublisher<[FeedEntry], FeedError> {
        let bannersPublisher = bannersUseCase.execute()
        let promotedBannersPublisher = promotedBannersUseCase.execute()
        return categoriesUseCase
            .execute()
            .tryMap { categories in
                guard !categories.isEmpty else {
                    throw FeedError.noCategories
                }
                return categories
            }.flatMap { [weak self] (categories: [Category]) -> AnyPublisher<[FeedEntry], Error> in
                guard let self = self else {
                    return Fail(error: FeedError.unknown)
                        .eraseToAnyPublisher()
                }
                return buildCategoriesEntries(categories: categories)
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
    
    private func buildCategoriesEntries(categories: [Category]) -> AnyPublisher<[FeedEntry], Error> {
        productsUseCase
            .execute()
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
            }.eraseToAnyPublisher()
    }
}

enum FeedError: Error {
    case noCategories, noProducts, unknown
}
