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
        let categoryRepository = CategoryRepositoryImpl(
            remoteDataSource: MockCategoryRemoteDataSource()
        )
        let bannerRepository = BannerRepositoryImpl(
            bannerDataSource: MockBannerRemoteDataSourceImpl()
        )
        let productRepository = ProductRepositoryImpl(
            productRemoteDataSource: MockProductRemoteDataSourceImpl()
        )
        let feedUseCase = GetFeedUseCaseImpl(
            categoriesUseCase: GetCategoriesUseCaseImpl(
                categoryRepository: categoryRepository
            ), 
            bannersUseCase: GetBannersUseCaseImpl(
                bannerRepository: bannerRepository
            ),
            promotedBannersUseCase: GetPromotedBannersUseCaseImpl(
                bannerRepository: bannerRepository
            ),
            productsUseCase: GetProductsUseCaseImpl(
                productRepository: productRepository
            )
        )
        container.register(GetFeedUseCase.self, provider: feedUseCase)
    }
}

