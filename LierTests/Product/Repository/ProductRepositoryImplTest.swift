//
//  ProductRepositoryImplTest.swift
//  LierTests
//
//  Created by Pedro on 12-07-24.
//

import XCTest
import Combine
@testable import Lier

final class ProductRepositoryImplTest: XCTestCase {
    var productRepository: ProductRepositoryImpl!
    var mockProductRemoteDataSource: MockProductRemoteDataSource!
    var disposeBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockProductRemoteDataSource = MockProductRemoteDataSource()
        productRepository = ProductRepositoryImpl(productRemoteDataSource: mockProductRemoteDataSource)
    }
    
    override func tearDown() {
        mockProductRemoteDataSource = nil
        productRepository = nil
        super.tearDown()
    }
    
    func testGetProductsFromRemoteSuccess() {
        //Arrange
        let expectedProducts = ProductStub.products
        mockProductRemoteDataSource.stubbedProducts = Just(expectedProducts).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        //Act
        var receivedProducts: [Product]?
        let expectation = expectation(description: "Products fetched")
        productRepository
            .getProducts()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    XCTFail("Expected success but got \(failure)")
                }
            }) {
                receivedProducts = $0
                expectation.fulfill()
            }.store(in: &disposeBag)
        waitForExpectations(timeout: 1)
        
        //Asset
        XCTAssertEqual(receivedProducts, expectedProducts)
    }
}

class MockProductRemoteDataSource: ProductRemoteDataSource {
    var stubbedProducts: AnyPublisher<[Product], Error>!
    
    func getProducts() -> AnyPublisher<[Product], any Error> {
        return stubbedProducts
    }
}
