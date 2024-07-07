//
//  DIContainer.swift
//  Lier
//
//  Created by Pedro on 05-07-24.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    private var dependency: T
    
    init() {
        self.dependency = DIContainer.shared.resolve()
    }
    
    var wrappedValue: T {
        get { dependency }
    }
}

class DIContainer {
    static let shared = DIContainer()
    private var providers: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, provider: T) {
        providers["\(type)"] = provider
    }
    
    func resolve<T>() -> T {
        let key = "\(T.self)"
        guard let provider = providers[key] as? T else {
            fatalError("DI: \(key) not registered")
        }
        return provider
    }
}
