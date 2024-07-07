//
//  MockBannerRemoteDataSourceImpl.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

class MockBannerRemoteDataSourceImpl: BannerRemoteDataSource {
    func getPromotedBanners() -> AnyPublisher<[Banner], any Error> {
        return getBanners()
            .map {
                let banners = $0.shuffled()
                return Array(banners.prefix(3))
            }
            .eraseToAnyPublisher()
    }
    
    func getBanners() -> AnyPublisher<[Banner], any Error> {
        return Just(
            [
                Banner(name: "Recién llegados", color: .randomPastelColor),
                Banner(name: "Para completos", color: .randomPastelColor),
                Banner(name: "Para sándwich", color: .randomPastelColor),
                Banner(name: "Para hamburguesa", color: .randomPastelColor)
            ]
        ).setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

extension String {
    static var randomPastelColor: String {
        return [
            "#b8dbd3",
            "#f7e7b4",
            "#68c4af",
            "#96ead7",
            "#f2f6c3"
        ].randomElement()!
    }
}
