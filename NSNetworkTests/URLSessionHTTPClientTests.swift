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
        let sut = makeSUT()
        let exp = expectation(description: "Waiting for request observer.")
        
        sut.get(from: "") { result in
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
                XCTFail("Expected to receive invalid url error, got \(data) instead.")
            } catch let error as HTTPError {
                XCTAssertEqual(error, .invalidURL)
            }
            exp.fulfill()
        }
       
        URLProtocolSpy.stub(data: anyData(), response: anyHTTPURLResponse(), error: nil)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_getURLString_performsRequestWithMatchingURL() {
        let sut = makeSUT()
        let requestedURLString = "any-url-string.com"
        let exp = expectation(description: "Waiting for request observer.")
        
        sut.get(from: requestedURLString) { _ in }
        
        URLProtocolSpy.observeRequest { request in
            XCTAssertEqual(request.url?.absoluteString, requestedURLString)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_getURL_performsRequestWithMatchingURL() {
        let sut = makeSUT()
        let exp = expectation(description: "Waiting for request observer.")
        
        sut.get(from: anyURL()) { _ in }
        
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
        expectTo(requestWith: (method: .GET, headers: [:]), when: {
            sut.get(from: anyURL()) { _ in }
        })
    }
    
    func test_get_performsRequestWithQueryParametersAndHeaders() {
        let sut = makeSUT()
        let queryParams: HTTPClient.QueryParameters = ["id":1, "username": "anonymous123"]
        let headers: HTTPClient.Headers = ["id": 1, "name": "anonymous", "height": 170.5]
        
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
        let result = resultValueGetRequestWith(data: expectedData, response: anyHTTPURLResponse(), error: nil)
        switch result {
        case .failure:
            XCTFail("Expected to receive success result, got \(result) instead.")
        default:
            break
        }
    }
    
    func test_getAsync_deliversSuccessDataOnHTTPURLResponse() {
        let expectedData = anyData()
        
        assertThatGetAsync(
            withResponse: (data: expectedData, response: anyHTTPURLResponse(), error: nil),
            resulting: .success(expectedData)
        )
    }
    
    func test_get_deliversClientErrorOnAllClientErrorStatusCodes() {
        let clientErrorStatusCodes: [Int] = Array(400...451)
        clientErrorStatusCodes.forEach { code in
            let result = resultValueGetRequestWith(data: nil, response: anyHTTPURLResponse(statusCode: code), error: nil)
            switch result {
            case let .failure(error):
                XCTAssertEqual(error, .client(data: nil, code: code))
            default:
                XCTFail("Expected to receive client error, got \(result) instead.")
            }
        }
    }
    
    func test_getAsync_deliversClientErrorOnAllClientErrorStatusCodes() {
        let clientErrorStatusCodes: [Int] = Array(400...404)
        clientErrorStatusCodes.forEach { code in
            assertThatGetAsync(
                withResponse: (data: nil, response: anyHTTPURLResponse(statusCode: code), error: nil),
                resulting: .failure(.client(data: nil, code: code))
            )
        }
    }
    
    func test_get_deliversServerErrorOnAllServerErrorStatusCodes() {
        let serverErrorStatusCodes: [Int] = Array(500...512)
        serverErrorStatusCodes.forEach { code in
            let result = resultValueGetRequestWith(data: nil, response: anyHTTPURLResponse(statusCode: code), error: nil)
            switch result {
            case let .failure(error):
                XCTAssertEqual(error, .server(data: nil, code: code))
            default:
                XCTFail("Expected to receive client error, got \(result) instead.")
            }
        }
    }
    
    func test_getAsync_deliversServerErrorOnAllServerErrorStatusCodes() {
        let clientErrorStatusCodes: [Int] = Array(500...512)
        clientErrorStatusCodes.forEach { code in
            assertThatGetAsync(
                withResponse: (data: nil, response: anyHTTPURLResponse(statusCode: code), error: nil),
                resulting: .failure(.server(data: nil, code: code))
            )
        }
    }
    
    func test_get_deliversErrorOnAllInvalidRequests() {
        XCTAssertNotNil(resultErrorFor(resultValueGetRequestWith(data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor(resultValueGetRequestWith(data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor(resultValueGetRequestWith(data: anyData(), response: nil, error: anyError())))
        XCTAssertNotNil(resultErrorFor(resultValueGetRequestWith(data: nil, response: anyURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor(resultValueGetRequestWith(data: anyData(), response: anyURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor(resultValueGetRequestWith(data: nil, response: anyURLResponse(), error: anyError())))
    }
    
    func test_getAsync_deliversErrorOnAllInvalidRequests() {
        assertThatGetAsync(withResponse: (data: nil, response: anyURLResponse(), error: anyError()), resulting: .failure(.unknown(message: anyError().localizedDescription)))
        assertThatGetAsync(withResponse: (data: anyData(), response: anyURLResponse(), error: nil), resulting: .failure(.invalidResponse))
        assertThatGetAsync(withResponse: (data: nil, response: anyURLResponse(), error: nil), resulting: .failure(.invalidResponse))
    }
    
    func test_get_doesNotDeliversAnyResultAfterCancelingRequest() {
        let task = makeSUT().get(from: anyURL()) { _ in
            XCTFail("Expected not to receive any result after canceling request.")
        }
        
        XCTAssertNotNil(task?.id)
        task?.cancel()
        
        URLProtocolSpy.stub(data: nil, response: anyHTTPURLResponse(), error: nil)
    }
    
    // MARK: - POST
    func test_post_performsRequestWithHTTPMethodPOST() {
        let sut = makeSUT()
        let data = anyData()
        expectTo(requestWith: (method: .POST, headers: ["username":"abc123"]), when: {
            sut.post(data, to: anyURL(), headers: ["username":"abc123"]) { _ in }
        })
    }
    
    func test_postWithBody_deliversSuccessOnHTTPURLResponse() {
        let sut = makeSUT()
        let data = anyHTTPBody()
        let exp = expectation(description: "Waiting for post request.")
        
        sut.post(data, to: anyURL()) { result in
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
    
    func test_postAsyncWithBody_deliversSuccessOnHTTPURLResponse() {
        let sut = makeSUT()
        let data = anyHTTPBody()
        let exp = expectation(description: "Waiting for post request.")
        
        Task {
            do {
                try await sut.post(data, to: anyURL())
            } catch {
                XCTFail("Expected to receive success, got \(error) instead.")
            }
            exp.fulfill()
        }
        
        
        URLProtocolSpy.stub(data: nil, response: anyHTTPURLResponse(), error: nil)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_postWithEmptyBody_deliversFailureOnHTTPURLResponse() {
        let sut = makeSUT()
        let exp = expectation(description: "Waiting for post request.")
        
        sut.post(Data(), to: anyURL()) { result in
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
        let data = anyData()
        expectTo(requestWith: (method: .PUT, headers: ["id": "123"]), when: {
            sut.put(data, to: anyURL(), headers: ["id": "123"]) { _ in }
        })
    }
    
    // MARK: - PATCH
    func test_patch_performsRequestWithHTTPMethodPATCH() {
        let sut = makeSUT()
        let data = anyData()
        expectTo(requestWith: (method: .PATCH, headers: [:]), when: {
            sut.patch(data, to: anyURL()) { _ in }
        })
    }
    
    // MARK: - DELETE
    func test_delete_performsRequestWithHTTPMethodDELETE() {
        let sut = makeSUT()
        expectTo(requestWith: (method: .DELETE, headers: [:]), when: {
            sut.delete(from: anyURL()) { _ in }
        })
    }

}

// MARK: - URLSessionHTTPClientTests + Extension
private extension URLSessionHTTPClientTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(in: sut, file: file, line: line)
        return sut
    }
    
    func expectTo(
        requestWith params: (method: HTTPMethod, headers: HTTPClient.Headers),
        when operation: @escaping() -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Waiting for request observer.")
        
        operation()
        
        URLProtocolSpy.observeRequest { request in
            XCTAssertEqual(request.httpMethod, params.method.rawValue, "Expect to perform request with method: \(params.method.rawValue), got \(String(describing: request.httpMethod)) instead.", file: file, line: line)
            params.headers.forEach {
                XCTAssertNotNil(request.value(forHTTPHeaderField: $0.key), "Expect to perform request with headers key: \($0.key), value: \($0.value).", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func resultValueGetRequestWith(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> HTTPClient.Result? {
        var receivedValue: HTTPClient.Result?
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Waiting for get request.")
        
        sut.get(from: anyURL()) { result in
            receivedValue = result
            exp.fulfill()
        }
        
        URLProtocolSpy.stub(data: data, response: response, error: error)
        
        wait(for: [exp], timeout: 1.0)
        return receivedValue
    }
    
    func assertThatGetAsync(
        withResponse response: (data: Data?, response: URLResponse?, error: Error?),
        resulting result: HTTPClient.Result,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Waiting for get request.")
        
        Task {
            do {
                let data = try await makeSUT().get(from: anyURL())
                switch result {
                case let .success(expectedData):
                    XCTAssertEqual(expectedData, data, file: file, line: line)
                case .failure:
                    XCTFail("Expected to receive \(result), got \(data) instead.", file: file, line: line)
                }
            } catch let error as HTTPError {
                switch result {
                case let .failure(expectedError):
                    XCTAssertEqual(expectedError, error, file: file, line: line)
                default:
                    XCTFail("Expected to receive \(result), got \(error) instead.", file: file, line: line)
                }
            }
            exp.fulfill()
        }
        
        URLProtocolSpy.stub(data: response.data, response: response.response, error: response.error)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func resultErrorFor(_ result: URLSessionHTTPClient.Result?) -> HTTPError? {
        return switch result {
        case let .failure(error): error
        default: nil
        }
    }
    
}
