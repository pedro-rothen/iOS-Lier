//
//  CartServiceImpl.swift
//  Lier
//
//  Created by Pedro on 06-07-24.
//

import Foundation

@Observable
class CartServiceImpl: CartService {
    var items = [CartItem]()
    
    func getItem(of product: Product) -> CartItem? {
        return items.first { $0.product == product }
    }
    
    func addUnit(of product: Product) {
        if let index = items.firstIndex(where: { $0.product == product }) {
            items[index].quantity += 1
        } else {
            items.append(
                CartItem(product: product, quantity: 1)
            )
        }
    }
    
    func removeUnit(of product: Product) {
        if let index = items.firstIndex(where: { $0.product == product }) {
            let cartItem = items[index]
            if cartItem.quantity == 1 {
                items.remove(at: index)
            } else {
                items[index].quantity -= 1
            }
        }
    }
    
    func calculateTotal() -> Double {
        return items.reduce(0) { $0 + Double($1.quantity) * $1.product.price }
    }
}
