//
//  CartWidgetView.swift
//  Lier
//
//  Created by Pedro on 28-06-24.
//

import SwiftUI

struct CartWidgetView: View {
    @Binding var cartService: CartService
    
    var body: some View {
        HStack {
            Image(systemName: "cart")
                .frame(width: 30, height: 30)
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .foregroundColor(.blue)
                .background(
                    Circle()
                        .fill(.yellow)
                )
            let quantity = cartService.items.count
            Text("\(quantity) \(quantity == 1 ? "Producto" : "Productos")")
            Spacer()
            Text("$\(Int(cartService.calculateTotal()))")
        }.padding([.leading, .trailing], 20)
            .padding(.top, 10)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.blue)
                    .ignoresSafeArea(.all)
            }.overlay(alignment: .top) {
                Capsule()
                    .frame(width: 70, height: 5)
                    .foregroundColor(.white)
            }
    }
}

#Preview {
    CartWidgetView(cartService: .constant(CartServiceImpl()))
}
