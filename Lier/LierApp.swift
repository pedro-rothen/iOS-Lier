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
    ///TODO: Wrapper observable to bridge CartService to an Observable object, @State does not allow CartService. We are breaking rules as we are depending on implementation rather than an abstraction.
    @State var cartService: CartServiceImpl = CartServiceImpl()
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .preferredColorScheme(.dark)
                .environment(MainContentViewModel(cartService: cartService))
                .environment(cartService)
        }
    }
}
