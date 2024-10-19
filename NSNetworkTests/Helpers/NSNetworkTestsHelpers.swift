//
//  HTTPClientTestsHelpers.swift
//  NSNetworkTests
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

import Foundation

func anyHTTPBody() -> Data {
    let dict: [String: Any?] = [
        "id": 1,
        "name": "James",
        "address": nil,
        "height": 170.5
    ]
    return try! JSONSerialization.data(withJSONObject: dict)
}

func anyURL() -> URL {
    URL(string: "any-url")!
}

func anyData() -> Data {
    "{\"id\": \"abc123\"}".data(using: .utf8)!
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
