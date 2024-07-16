//
//  GetProductsUseCaseImplTest.swift
//  LierTests
//
//  Created by Pedro on 08-07-24.
//

import XCTest
import Combine
@testable import Lier

final class GetProductsUseCaseImplTest: XCTestCase {
    var getProductsUseCase: GetProductsUseCaseImpl!
    var mockProductRepository: MockProductRepository!
    var disposeBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockProductRepository = MockProductRepository()
        getProductsUseCase = GetProductsUseCaseImpl(productRepository: mockProductRepository)
    }
    
    override func tearDown() {
        mockProductRepository = nil
        getProductsUseCase = nil
        super.tearDown()
    }
    
    func testGetProductsSuccess() {
        //Arrange
        let expectedProducts = ProductStub.products
        mockProductRepository.stubbedProducts = Just(expectedProducts).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        //Act
        var receivedProducts: [Product]?
        let expectation = expectation(description: "Products fetched")
        getProductsUseCase
            .execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    XCTFail("Expected success but got \(failure)")
                }
            }) { products in
                receivedProducts = products
                expectation.fulfill()
            }.store(in: &disposeBag)
        waitForExpectations(timeout: 1)
        
        //Assert
        XCTAssertEqual(receivedProducts, expectedProducts)
    }
}

class MockProductRepository: ProductRepository {
    var stubbedProducts: AnyPublisher<[Product], Error>!
    
    func getProducts() -> AnyPublisher<[Product], Error> {
        return stubbedProducts
    }
}


struct ProductStub {
    static let products = [Product(name: "Pan", image: "", price: 100)]
}
