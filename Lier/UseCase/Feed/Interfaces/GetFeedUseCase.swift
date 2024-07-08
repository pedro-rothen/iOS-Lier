//
//  GetFeedUseCase.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

protocol GetFeedUseCase {
    func getFeed() -> AnyPublisher<[FeedEntry], FeedError>
}

enum FeedEntry: Identifiable {
    var id: String? {
        switch self {
        case .categories(let categories):
            "categories\(categories.hashValue)"
        case .singleBanner(let banner):
            "singleBanner\(banner.hashValue)"
        case .carrousselBanner(let banners):
            "carrousselBanner\(banners.hashValue)"
        case .products(let category, let products):
            "products\(category.hashValue)\(products.hashValue)"
        }
    }
    case categories([Category])
    case singleBanner(Banner)
    case carrousselBanner([Banner])
    case products(Category, [Product])
}
