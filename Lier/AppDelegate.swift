//
//  AppDelegate.swift
//  Lier
//
//  Created by Pedro on 05-07-24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupDI()
        return true
    }
    
    func setupDI() {
        let container = DIContainer.shared
        let feedUseCase = FeedUseCaseImpl(
            categoryRepository: CategoryRepositoryImpl(
                remoteDataSource: MockCategoryRemoteDataSource()
            ), bannerRepostiory: BannerRepositoryImpl(
                bannerDataSource: MockBannerRemoteDataSourceImpl()
            ), productRepository: ProductRepositoryImpl(
                productRemoteDataSource: MockProductRemoteDataSourceImpl()
            )
        )
        container.register(FeedUseCase.self, provider: feedUseCase)
    }
}

