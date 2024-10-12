//
//  URLSessionHTTPClientTests.swift
//  NSNetworkTests
//
//  Created by Muhammad Nobel Shidqi on 11/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

import XCTest
import NSNetwork

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUpWithError() throws {
        URLProtocolSpy.startInterceptingRequest()
    }
    
    override func tearDownWithError() throws {
        URLProtocolSpy.stopInterceptingRequest()
    }

    func test_get_deliversSuccessDataOnHTTPURLResponse() {
        let expectedData = anyData()
        let result = resultValueFor(data: expectedData, response: anyHTTPURLResponse(), error: nil)
        switch result {
        case let .success(data):
            XCTAssertEqual(data, expectedData, "Expected to receive \(expectedData), got \(data) instead.")
        default:
            XCTFail("Expected to receive success result, got \(result!) instead.")
        }
    }
    
    func test_get_deliversInvalidDataErrorOnEmptyData() {
        let result = resultValueFor(data: Data(), response: anyHTTPURLResponse(), error: nil)
        switch result {
        case .success:
            XCTFail("Expected to receive failure result, got \(result!) instead.")
        default:
            break
        }
    }
    
    func test_get_deliversClientErrorOnAllClientErrorStatusCodes() {
        let clientErrorStatusCodes: [Int] = Array(400...451)
        clientErrorStatusCodes.forEach { code in
            let result = resultValueFor(data: nil, response: anyHTTPURLResponse(statusCode: code), error: nil)
            switch result {
            case let .failure(error):
                XCTAssertEqual(error, .client(data: nil, code: code))
            default:
                XCTFail("Expected to receive client error, got \(result!) instead.")
            }
        }
    }
    
    func test_get_deliversServerErrorOnAllServerErrorStatusCodes() {
        let serverErrorStatusCodes: [Int] = Array(500...512)
        serverErrorStatusCodes.forEach { code in
            let result = resultValueFor(data: nil, response: anyHTTPURLResponse(statusCode: code), error: nil)
            switch result {
            case let .failure(error):
                XCTAssertEqual(error, .server(data: nil, code: code))
            default:
                XCTFail("Expected to receive client error, got \(result!) instead.")
            }
        }
    }
    
    func test_get_deliversErrorOnAllInvalidRequests() {
        XCTAssertNotNil(resultErrorFor(resultValueFor(data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor(resultValueFor(data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor(resultValueFor(data: anyData(), response: nil, error: anyError())))
        XCTAssertNotNil(resultErrorFor(resultValueFor(data: nil, response: anyURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor(resultValueFor(data: anyData(), response: anyURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor(resultValueFor(data: nil, response: anyURLResponse(), error: anyError())))
    }

}

private extension URLSessionHTTPClientTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient(session: .shared)
        trackForMemoryLeaks(in: sut, file: file, line: line)
        return sut
    }
    
    func resultValueFor(data: Data?, response: URLResponse?, error: Error?) -> HTTPClient.Result? {
        var receivedValue: HTTPClient.Result?
        
        let exp = expectation(description: "Waiting for get request.")
        makeSUT().get(from: anyURL()) { result in
            receivedValue = result
            exp.fulfill()
        }
        
        URLProtocolSpy.stub(data: data, response: response, error: error)
        
        wait(for: [exp], timeout: 1.0)
        return receivedValue
    }
    
    func resultErrorFor(_ result: URLSessionHTTPClient.Result?) -> HTTPClientError? {
        return switch result {
        case let .failure(error): error
        default: nil
        }
    }
    
}
