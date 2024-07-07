//
//  MockProductRemoteDataSourceImpl.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation
import Combine

class MockProductRemoteDataSourceImpl: ProductRemoteDataSource {
    func getProducts() -> AnyPublisher<[Product], Error> {
        return Just(
            [
                Product(name: "Pan francés", image: "https://images.lider.cl/wmtcl?source=url[file:/productos/333213a.jpg]&scale=size[180x180]&sink", price: 100),
                Product(name: "Hallulla", image: "https://images.lider.cl/wmtcl?source=url[file:/productos/701367a.jpg]&scale=size[180x180]&sink", price: 100),
                Product(name: "Pan Amasado", image: "https://images.lider.cl/wmtcl?source=url[file:/productos/330660a.jpg]&scale=size[180x180]&sink", price: 100),
                Product(name: "Pan Dobladas", image: "https://images.lider.cl/wmtcl?source=url[file:/productos/295859a.jpg]&scale=size[180x180]&sink", price: 100),
                Product(name: "Pan de Molde", image: "https://images.lider.cl/wmtcl?source=url[file:/productos/1017777a.jpg]&scale=size[180x180]&sink", price: 100)
            ]
        ).setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
