//
//  LierApp.swift
//  Lier
//
//  Created by Pedro on 24-06-24.
//

import SwiftUI

@main
struct LierApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var cartService = CartServiceImpl()
    
    var body: some Scene {
        WindowGroup {
            MainContentView(viewModel: MainContentViewModel(cartService: cartService))
                .preferredColorScheme(.dark)
                .environment(cartService)
        }
    }
}
