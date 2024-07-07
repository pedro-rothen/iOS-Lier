//
//  CartService.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation

protocol CartService {
    var items: [CartItem] { get }
    func getItem(of product: Product) -> CartItem?
    func addUnit(of product: Product)
    func removeUnit(of product: Product)
    func calculateTotal() -> Double
}

