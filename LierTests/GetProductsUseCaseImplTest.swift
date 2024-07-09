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
    
    class MockProductRepository: ProductRepository {
        var getProductsResult: Result<[Product], Error> = .success([])
        
        func getProducts() -> AnyPublisher<[Product], any Error> {
            Result.Publisher(getProductsResult).eraseToAnyPublisher()
        }
    }
    
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
        let expectedProducts = [Product(name: "Pan", image: "", price: 100)]
        mockProductRepository.getProductsResult = .success(expectedProducts)
        
        //Act
        var receivedProducts: [Product]?
        let expectation = expectation(description: "Get products expectations")
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
