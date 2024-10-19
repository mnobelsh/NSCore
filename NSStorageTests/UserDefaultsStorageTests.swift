//
//  UserDefaultsStorageTests.swift
//  UserDefaultsStorageTests
//
//  Created by Muhammad Nobel Shidqi on 11/10/24.
//

import XCTest
import NSStorage

final class UserDefaultsStorageTests: XCTestCase {

    func test_saveAllRepresentableData_deliversMatchingValues() {
        let sut = UserDefaultsStorage(suiteName: "testSuite")
        
        sut.save("String Value", withKey: "String")
        sut.save(1, withKey: "Integer")
        sut.save(1.5, withKey: "Float")
        sut.save(2.5, withKey: "Double")
        sut.save(true, withKey: "Bool")
        sut.save(anyData(), withKey: "Data")
        sut.save(CodableMock(), withKey: "Codable")
        
        let stringValue: String? = sut.get(withKey: "String")
        let integerValue: Int? = sut.get(withKey: "Integer")
        let floatValue: Float? = sut.get(withKey: "Float")
        let doubleValue: Double? = sut.get(withKey: "Double")
        let booleanValue: Bool? = sut.get(withKey: "Bool")
        let dataValue: Data? = sut.get(withKey: "Data")
        let codableValue: CodableMock? = sut.get(withKey: "Codable")
        
        XCTAssertEqual(stringValue, "String Value")
        XCTAssertEqual(integerValue, 1)
        XCTAssertEqual(floatValue, 1.5)
        XCTAssertEqual(doubleValue, 2.5)
        XCTAssertEqual(booleanValue, true)
        XCTAssertEqual(dataValue, anyData())
        XCTAssertEqual(codableValue, CodableMock())
    }
    
    func test_deletesStoredValue_deliversEmptyForRelatedKeys() {
        let sut = UserDefaultsStorage(suiteName: "testSuite")
        
        sut.save("String Value", withKey: "String")
        sut.save(1, withKey: "Integer")
        sut.save(1.5, withKey: "Float")
        
        sut.delete(withKey: "String")
        sut.delete(withKey: "Integer")
        sut.delete(withKey: "Float")
        
        let stringValue: String? = sut.get(withKey: "String")
        let integerValue: Int? = sut.get(withKey: "Integer")
        let floatValue: Float? = sut.get(withKey: "Float")
        
        XCTAssertNil(stringValue)
        XCTAssertNil(integerValue)
        XCTAssertNil(floatValue)
    }
    
    func test_deletesAll_deliversEmptyForAllKeys() {
        let sut = UserDefaultsStorage(suiteName: "testSuite")
        
        sut.save("String Value", withKey: "String")
        sut.save(1, withKey: "Integer")
        sut.save(1.5, withKey: "Float")
        
        sut.deleteAll()
        
        let stringValue: String? = sut.get(withKey: "String")
        let integerValue: Int? = sut.get(withKey: "Integer")
        let floatValue: Float? = sut.get(withKey: "Float")
        
        XCTAssertNil(stringValue)
        XCTAssertNil(integerValue)
        XCTAssertNil(floatValue)
    }
    
    func test_deletesDataOnSuiteStorage_doesNotAffectingStandardStorage() {
        let suiteSUT = UserDefaultsStorage(suiteName: "testSuite")
        let standardSUT = UserDefaultsStorage()
        
        suiteSUT.save(1, withKey: "id")
        standardSUT.save(2, withKey: "id")
        
        suiteSUT.deleteAll()
        
        let suiteValue: Int? = suiteSUT.get(withKey: "id")
        let standardValue: Int? = standardSUT.get(withKey: "id")
        
        XCTAssertNil(suiteValue)
        XCTAssertNotNil(standardValue)
    }
    
    func test_deletesDataOnStandardStorage_doesNotAffectingSuiteStorage() {
        let suiteSUT = UserDefaultsStorage(suiteName: "testSuite")
        let standardSUT = UserDefaultsStorage()
        
        suiteSUT.save(1, withKey: "id")
        standardSUT.save(2, withKey: "id")
        
        standardSUT.deleteAll()
        
        let suiteValue: Int? = suiteSUT.get(withKey: "id")
        let standardValue: Int? = standardSUT.get(withKey: "id")
        
        XCTAssertNotNil(suiteValue)
        XCTAssertNil(standardValue)
    }

}

private extension UserDefaultsStorageTests {
    
    func anyData() -> Data {
        "{\"id\": \"abc123\"}".data(using: .utf8)!
    }
    
    struct CodableMock: CodableItem, Equatable {
        var id: String = "1"
        var name: String = "Anonymous"
        var age: Int = 20
        var isActive: Bool = true
    }
    
}
