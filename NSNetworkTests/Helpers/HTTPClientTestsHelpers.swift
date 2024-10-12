//
//  HTTPClientTestsHelpers.swift
//  NSNetworkTests
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

import Foundation

func anyURL() -> URL {
    URL(string: "any-url")!
}

func anyData() -> Data {
    "Any Data".data(using: .utf8)!
}

func anyError() -> Error {
    NSError(domain: "", code: 0)
}

func anyHTTPURLResponse(statusCode: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func anyURLResponse() -> URLResponse {
    URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}
