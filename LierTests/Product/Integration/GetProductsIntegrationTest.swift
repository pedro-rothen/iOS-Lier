//
//  GetProductsIntegrationTest.swift
//  LierTests
//
//  Created by Pedro on 12-07-24.
//

import XCTest
import Combine
@testable import Lier

class GetProductsIntegrationTest: XCTestCase {
    var getProductsUseCase: GetProductsUseCase!
    var productRepository: ProductRepository!
    var mockProductRemoteDataSource: MockProductRemoteDataSource!
    var disposeBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockProductRemoteDataSource = MockProductRemoteDataSource()
        productRepository = ProductRepositoryImpl(productRemoteDataSource: mockProductRemoteDataSource)
        getProductsUseCase = GetProductsUseCaseImpl(productRepository: productRepository)
    }
    
    override func tearDown() {
        mockProductRemoteDataSource = nil
        productRepository = nil
        getProductsUseCase = nil
        super.tearDown()
    }
    
    func testGetProductsUseCaseIntegration() {
        //Act
        let expectedProducts = ProductStub.products
        mockProductRemoteDataSource.stubbedProducts = Just(expectedProducts).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        //Arrange
        var receivedProducts: [Product]?
        let expection = expectation(description: "Products fetched")
        getProductsUseCase
            .execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    XCTFail("Expected success but got \(failure)")
                }
            }) {
                receivedProducts = $0
                expection.fulfill()
            }.store(in: &disposeBag)
        waitForExpectations(timeout: 1)
        
        //Assert
        XCTAssertEqual(receivedProducts, expectedProducts)
    }
}
