//
//  DeliveryMethodWidgetView.swift
//  Lier
//
//  Created by Pedro on 26-06-24.
//

import SwiftUI

struct DeliveryMethodWidgetView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "truck.box")
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
                    .padding(5)
                    .background(
                        Circle()
                            .fill(.yellow)
                    )
                VStack(alignment: .leading) {
                    Text("Title")
                    Text("Subtitle")
                }
            }
            Text("Desde mañana 11:00")
                .padding([.leading, .trailing], 15)
                .padding([.top, .bottom], 5)
                .overlay {
                    Capsule().stroke(.yellow, lineWidth: 2.0)
                }
        }
    }
}

#Preview {
    DeliveryMethodWidgetView()
}
