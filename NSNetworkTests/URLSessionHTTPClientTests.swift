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

    // MARK: - GET
    func test_getFromInvalidURL_deliversInvalidURLError() {
        let exp = expectation(description: "Waiting for request observer.")
        
        makeSUT().get(from: "") { result in
            switch result {
            case let .failure(error):
                XCTAssertEqual(error, .invalidURL, "Expected to receive invalid url error, got \(result) instead.")
            default:
                XCTFail("Expected to receive invalid url error, got \(result) instead.")
            }
            exp.fulfill()
        }
        
        URLProtocolSpy.stub(data: anyData(), response: anyHTTPURLResponse(), error: nil)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_getAsyncFromInvalidURL_deliversInvalidURLError() {
        let exp = expectation(description: "Waiting for get request.")
        
        Task {
            do {
                let data = try await makeSUT().get(from: "")
                XCTFail("Expected to receive invalid url error, got \(data!) instead.")
            } catch let error as HTTPError {
                XCTAssertEqual(error, .invalidURL)
            }
            exp.fulfill()
        }
       
        URLProtocolSpy.stub(data: anyData(), response: anyHTTPURLResponse(), error: nil)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_getURLString_performsRequestWithMatchingURL() {
        let requestedURLString = "any-url-string.com"
        let exp = expectation(description: "Waiting for request observer.")
        
        makeSUT().get(from: requestedURLString) { _ in }
        
        URLProtocolSpy.observeRequest { request in
            XCTAssertEqual(request.url?.absoluteString, requestedURLString)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_getURL_performsRequestWithMatchingURL() {
        let exp = expectation(description: "Waiting for request observer.")
        
        makeSUT().get(from: anyURL()) { _ in }
        
        URLProtocolSpy.observeRequest { request in
            XCTAssertEqual(request.url, anyURL())
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_getOptionalURL_performsRequestWithMatchingURL() {
        let exp = expectation(description: "Waiting for request observer.")
        let optionalURL = URL(string: "any-optional-url")
        
        makeSUT().get(from: optionalURL) { _ in }
        
        URLProtocolSpy.observeRequest { request in
            XCTAssertEqual(request.url, optionalURL)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_get_performsRequestWithHTTPMethodGET() {
        let sut = makeSUT()
        expectTo(requestWithMethod: .GET, when: {
            sut.get(from: anyURL()) { _ in }
        })
    }
    
    func test_get_performsRequestWithQueryParametersAndHeaders() {
        let sut = makeSUT()
        let queryParams: HTTPClient.QueryParameters = ["id":1, "username": "anonymous123", "none": nil]
        let headers: HTTPClient.Headers = ["id": 1, "name": "anonymous", "height": 170.5, "none": nil]
        
        let exp = expectation(description: "Waiting for request observer.")
        
        sut.get(from: anyURL(), parameters: queryParams, headers: headers) { _ in }
        
        URLProtocolSpy.observeRequest { request in
            XCTAssertNotNil(request.url?.query())
            headers.compactMapValues{ $0 }.forEach {
                XCTAssertNotNil(request.value(forHTTPHeaderField: $0.key))
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_get_deliversSuccessDataOnHTTPURLResponse() {
        let expectedData: Data? = nil
        let result = resultValueFor(data: expectedData, response: anyHTTPURLResponse(), error: nil)
        switch result {
        case .failure:
            XCTFail("Expected to receive success result, got \(result!) instead.")
        default:
            break
        }
    }
    
    func test_getAsync_deliversSuccessDataOnHTTPURLResponse() {
        let exp = expectation(description: "Waiting for get request.")
        let expectedData = anyData()
        
        Task {
            do {
                let data = try await makeSUT().get(from: anyURL())
                XCTAssertEqual(data, expectedData)
            } catch let error as HTTPError {
                XCTFail("Expected to receive \(expectedData), got \(error) instead.")
            }
            exp.fulfill()
        }
       
        URLProtocolSpy.stub(data: expectedData, response: anyHTTPURLResponse(), error: nil)
        
        wait(for: [exp], timeout: 1)
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
    
    func test_getAsync_deliversClientErrorOnAllClientErrorStatusCodes() {
        let clientErrorStatusCodes: [Int] = Array(400...404)
        clientErrorStatusCodes.forEach { code in
            
            let exp = expectation(description: "Waiting for get request.")
            
            Task {
                do {
                    let data = try await makeSUT().get(from: anyURL())
                    XCTFail("Expected to receive client error with code: \(code), got \(data!) instead.")
                } catch let error as HTTPError {
                    switch error {
                    case .client:
                        XCTAssertEqual(error, .client(data: nil, code: code))
                    default:
                        XCTFail("Expected to receive client error with code: \(code), got \(error) instead.")
                    }
                }
                exp.fulfill()
            }
           
            URLProtocolSpy.stub(data: nil, response: anyHTTPURLResponse(statusCode: code), error: nil)
            
            wait(for: [exp], timeout: 1.0)
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
    
    func test_getAsync_deliversServerErrorOnAllServerErrorStatusCodes() {
        let clientErrorStatusCodes: [Int] = Array(500...512)
        clientErrorStatusCodes.forEach { code in
            
            let exp = expectation(description: "Waiting for get request.")
            
            Task {
                do {
                    let data = try await makeSUT().get(from: anyURL())
                    XCTFail("Expected to receive server error with code: \(code), got \(data!) instead.")
                } catch let error as HTTPError {
                    switch error {
                    case .server:
                        XCTAssertEqual(error, .server(data: nil, code: code))
                    default:
                        XCTFail("Expected to receive server error with code: \(code), got \(error) instead.")
                    }
                }
                exp.fulfill()
            }
           
            URLProtocolSpy.stub(data: nil, response: anyHTTPURLResponse(statusCode: code), error: nil)
            
            wait(for: [exp], timeout: 1.0)
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
    
    // MARK: - POST
    func test_post_performsRequestWithHTTPMethodPOST() {
        let sut = makeSUT()
        expectTo(requestWithMethod: .POST, when: {
            sut.post(anyData(), to: anyURL()) { _ in }
        })
    }
    
    func test_postWithBody_deliversSuccessOnHTTPURLResponse() {
        let data = anyHTTPBody()
        let exp = expectation(description: "Waiting for post request.")
        
        makeSUT().post(data, to: anyURL()) { result in
            switch result {
            case .success:
                break
            default:
                XCTFail("Expected to receive success, got \(result) instead.")
            }
            exp.fulfill()
        }
        
        URLProtocolSpy.stub(data: nil, response: anyHTTPURLResponse(), error: nil)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_postWithEmptyBody_deliversFailureOnHTTPURLResponse() {
        let exp = expectation(description: "Waiting for post request.")
        
        makeSUT().post(Data(), to: anyURL()) { result in
            switch result {
            case .failure:
                break
            default:
                XCTFail("Expected to receive failure, got \(result) instead.")
            }
            exp.fulfill()
        }
        
        URLProtocolSpy.stub(data: nil, response: anyHTTPURLResponse(), error: anyError())
        
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - PUT
    func test_put_performsRequestWithHTTPMethodPUT() {
        let sut = makeSUT()
        expectTo(requestWithMethod: .PUT, when: {
            sut.put(anyData(), to: anyURL()) { _ in }
        })
    }
    
    // MARK: - PATCH
    func test_patch_performsRequestWithHTTPMethodPATCH() {
        let sut = makeSUT()
        expectTo(requestWithMethod: .PATCH, when: {
            sut.patch(anyData(), to: anyURL()) { _ in }
        })
    }
    
    // MARK: - DELETE
    func test_delete_performsRequestWithHTTPMethodDELETE() {
        let sut = makeSUT()
        expectTo(requestWithMethod: .DELETE, when: {
            sut.delete(from: anyURL()) { _ in }
        })
    }

}

// MARK: - URLSessionHTTPClientTests + Extension
private extension URLSessionHTTPClientTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient(session: .shared)
        trackForMemoryLeaks(in: sut, file: file, line: line)
        return sut
    }
    
    func expectTo(requestWithMethod method: HTTPMethod, when operation: @escaping() -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Waiting for request observer.")
        
        operation()
        
        URLProtocolSpy.observeRequest { request in
            XCTAssertEqual(request.httpMethod, method.rawValue, "Expect to perform request with \(method.rawValue), got \(request.httpMethod!) instead.", file: file, line: line)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
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
    
    func resultErrorFor(_ result: URLSessionHTTPClient.Result?) -> HTTPError? {
        return switch result {
        case let .failure(error): error
        default: nil
        }
    }
    
}
