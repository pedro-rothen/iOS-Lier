//
//  MainContentView.swift
//  Lier
//
//  Created by Pedro on 26-06-24.
//

import SwiftUI
import Combine

@MainActor
struct MainContentView: View {
    @State private var searchQuery: String = ""
    @State var viewModel: MainContentViewModel
    
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            Header()
            Spacer().frame(height: 20)
            SearchBar()
            Content()
            Spacer()
            if !viewModel.isCartEmpty() {
                CartWidgetView(cartService: $viewModel.cartService)
            }
//            NavigationLink("Detail") {
//                CartDetailView()
//            }
        }.ignoresSafeArea()
    }
    
    @ViewBuilder
    func Content() -> some View {
        switch viewModel.uiState {
        case .loading:
            ProgressView()
                .tint(.lierYellow)
                .controlSize(.extraLarge)
                .padding(.top, 20)
        case .error:
            LierErrorButton {
                viewModel.getEntries()
            }
        case .success:
            Feed()
        case .offline://TODO
            EmptyView()
        }
    }
    
    @ViewBuilder
    func Feed() -> some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                if let entries = viewModel.entries {
                    ForEach(entries, id: \.id) { entry in
                        switch entry {
                        case .categories(let categories):
                            CategoriesRow(categories: categories)
                        case .products(let category, let products):
                            ProductsRow(category: category, products: products)
                        case .carrousselBanner(let banners):
                            BannersCarroussel(banners: banners)
                        case .singleBanner(let banner):
                            SingleBanner(banner: banner)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func CategoriesRow(categories: [Category]) -> some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(categories, id: \.hashValue) { category in
                    Text(category.name)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .background {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(hex: category.color))
                        }
                }
            }.padding([.top, .bottom], 10)
        }
    }
        
    @ViewBuilder
    func ProductsRow(category: Category, products: [Product]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(category.name)
                .font(.system(size: 22, weight: .bold))
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach(products, id: \.hashValue) { product in
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: product.image)) {
                                $0.image?.resizable()
                            }.frame(width: 150, height: 150)
                                //.frame(maxWidth: .infinity) Getting glitches with dynamic width
                                //.aspectRatio(1, contentMode: .fill)
                            Text("$\(Int(product.price))")
                                .fontWeight(.bold)
                            Text(product.name)
                                .lineLimit(1)
                            Text("1 un")
                                .fontWeight(.light)
                            ZStack {
                                if !viewModel.isAdded(product: product) {
                                    Button(action: {
                                        viewModel.addUnitToCart(of: product)
                                    }) {
                                        Text("Agregar")
                                            .foregroundColor(.white)
                                            .padding(5)
                                            .padding([.leading, .trailing], 10)
                                    }.overlay {
                                        Capsule()
                                            .stroke(lineWidth: 2)
                                    }
                                } else {
                                    HStack {
                                        CartActionButton(title: "-") {
                                            viewModel.removeUnitToCart(of: product)
                                        }
                                        Text("\(viewModel.quantity(of: product))")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        CartActionButton(title: "+") {
                                            viewModel.addUnitToCart(of: product)
                                        }
                                    }
                                }
                            }.frame(maxWidth: .infinity, minHeight: 50)
                        }.frame(width: 150)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func CartActionButton(title: String, action: @escaping () -> ()) -> some View {
        Button(action: action) {
            Text(title)
        }.frame(width: 50)
            .tint(.white)
            .background {
                Circle()
                    .stroke(lineWidth: 2)
            }
    }
    
    @ViewBuilder
    func BannersCarroussel(banners: [Banner]) -> some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(banners, id: \.hashValue) { banner in
                    Text(banner.name)
                        .frame(width: 150, height: 120)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .background {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(hex: banner.color))
                        }
                }
            }.padding([.top, .bottom], 10)
        }
    }
    
    @ViewBuilder
    func SingleBanner(banner: Banner) -> some View {
        Text(banner.name)
            .frame(maxWidth: .infinity, idealHeight: 120)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .background {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: banner.color))
            }
    }
    
    @ViewBuilder
    func Header() -> some View {
        ZStack {
            HStack {
                DeliveryMethodWidgetView()
                Spacer()
                UserIcon()
            }.padding()
        }.background {
            RoundedRectangle(cornerRadius: 15).fill(.blue)
                .ignoresSafeArea(.all)
        }
    }
    
    @ViewBuilder
    func UserIcon() -> some View {
        VStack {
            Image(systemName: "person")
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
                .background(
                    Circle().fill(.yellow)
                )
            Text("Mi cuenta")
        }
    }
    
    @ViewBuilder
    func SearchBar() -> some View {
        TextField("Search",
            text: $searchQuery,
            prompt: Text("¿Qué producto buscas hoy?")
                .foregroundColor(.white)
        ).padding(15)
            .background {
                Capsule().fill(.blue)
            }
    }
}

@Observable
class MainContentViewModel {
    var cartService: CartService
    var entries: [FeedEntry]?
    var uiState: BasicUiState = .loading
    private var disposeBag = Set<AnyCancellable>()
    
    @ObservationIgnored
    @Injected var getFeedUseCase: GetFeedUseCase
    
    init(cartService: CartService) {
        self.cartService = cartService
        getEntries()
    }
    
    func getEntries() {
        uiState = .loading
        getFeedUseCase
            .getFeed()
            .sink(receiveCompletion: { [weak self] completion in
                self?.uiState = switch completion {
                    case .finished:
                        .success
                    case .failure(_):
                        .error
                }
            }) { [weak self] in
                self?.entries = $0
            }.store(in: &disposeBag)
    }
    
    func isCartEmpty() -> Bool {
        return cartService.isEmpty()
    }
    
    func isAdded(product: Product) -> Bool {
        return cartService.getItem(of: product) != nil
    }
    
    func quantity(of product: Product) -> Int {
        return cartService.getItem(of: product)?.quantity ?? 0
    }
    
    func addUnitToCart(of product: Product) {
        cartService.addUnit(of: product)
    }
    
    func removeUnitToCart(of product: Product) {
        cartService.removeUnit(of: product)
    }
}

enum BasicUiState {
    case loading, error, success, offline
}

struct LierErrorButton: View {
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Text("Reintentar 😔")
        }
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    let cartService = CartServiceImpl()
    let viewModel = MainContentViewModel(cartService: cartService)
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        //viewModel.uiState = .error
    }
    return MainContentView(viewModel: viewModel)
        .environment(cartService)
}
