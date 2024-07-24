@testable import FakeNFT
import XCTest

final class ExampleUnitTests: XCTestCase {
    func testExample() {
        // TODO: - Не забудьте написать unit-тесты
    }
}

class NetworkClientCartTests: XCTestCase {
    
    func testSendSuccess() {
        // Given
        let mockSession = MockURLSession()
        let networkClient = NetworkClientCart(session: mockSession)
        let mockData = """
        [
            {
                "id": "1",
                "name": "NFT 1",
                "description": "Description 1",
                "price": 10.0,
                "rating": 5.0,
                "author": "Author 1",
                "createdAt": "2023-01-01T00:00:00Z",
                "images": ["https://example.com/image1.jpg"]
            },
            {
                "id": "2",
                "name": "NFT 2",
                "description": "Description 2",
                "price": 20.0,
                "rating": 4.0,
                "author": "Author 2",
                "createdAt": "2023-01-01T00:00:00Z",
                "images": ["https://example.com/image2.jpg"]
            }
        ]
        """.data(using: .utf8)!
        mockSession.nextData = mockData
        
        let request = URLRequest(url: URL(string: "https://example.com")!)
        let expectation = self.expectation(description: "Completion handler invoked")
        
        // When
        var result: Result<[NFTModel], Error>?
        networkClient.send(request: request, type: [NFTModel].self) { response in
            result = response
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            switch result {
            case .success(let nftList):
                XCTAssertEqual(nftList.count, 2)
                XCTAssertEqual(nftList[0].name, "NFT 1")
                XCTAssertEqual(nftList[1].name, "NFT 2")
            case .failure(let error):
                XCTFail("Expected success, got \(error) instead")
            case .none:
                XCTFail("Expected result, got none")
            }
        }
    }
    
    func testSendFailure() {
        // Given
        let mockSession = MockURLSession()
        let networkClient = NetworkClientCart(session: mockSession)
        mockSession.nextError = NSError(domain: "Test", code: -1, userInfo: nil)
        
        let request = URLRequest(url: URL(string: "https://example.com")!)
        let expectation = self.expectation(description: "Completion handler invoked")
        
        // When
        var result: Result<[NFTModel], Error>?
        networkClient.send(request: request, type: [NFTModel].self) { response in
            result = response
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            switch result {
            case .success:
                XCTFail("Expected failure, got success instead")
            case .failure(let error):
                XCTAssertNotNil(error)
            case .none:
                XCTFail("Expected result, got none")
            }
        }
    }
    
    
    func testCurrencyModelDecoding() {
        // Пример JSON для тестирования
        let jsonString = """
            {
                "title": "Bitcoin",
                "name": "BTC",
                "image": "https://example.com/bitcoin.png",
                "id": "1"
            }
            """
        // Преобразуем JSON строку в Data
        let jsonData = jsonString.data(using: .utf8)!
        
        // Декодируем JSON в модель
        do {
            let currency = try JSONDecoder().decode(CurrencyModel.self, from: jsonData)
            // Проверяем значения
            XCTAssertEqual(currency.title, "Bitcoin")
            XCTAssertEqual(currency.name, "BTC")
            XCTAssertEqual(currency.image, "https://example.com/bitcoin.png")
            XCTAssertEqual(currency.id, "1")
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }
    
}

