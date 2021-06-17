import XCTest
@testable import SwiftletBarcodes

final class SwiftletBarcodesTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let barcode = SwiftletBarcodes.generate(from: "12345678", format: .code128)
        XCTAssert(barcode != nil)
    }
}
