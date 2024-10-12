//
//  XCTestCase+MemoryLeaks.swift
//  NSNetworkTests
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(in instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Expected to deallocate \(instance!).", file: file, line: line)
        }
    }
}
