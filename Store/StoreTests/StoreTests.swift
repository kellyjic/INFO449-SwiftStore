//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    //extra tests i created myself
    func testSingleItemSubtotal() {
        let register = Register()
        let pencil = Item(name: "Pencil", priceEach: 99)

        register.scan(pencil)

        let subtotal = register.subtotal()
        XCTAssertEqual(subtotal, 99)
        }
    
    func testRegisterResetsAfterTotal() {
        register.scan(Item(name: "Pencil", priceEach: 99))
        _ = register.total()

        XCTAssertEqual(0, register.subtotal())
    }
    
    func testCouponGeneral() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
            register.addCoupon(Coupon(itemName: "Beans (8oz Can)"))

            let receipt = register.total()

            XCTAssertEqual(170, receipt.total())
    }
    
    func testCouponAppliesToOnlyOneItem() {
        register.scan(Item(name: "Beans", priceEach: 199))
        register.scan(Item(name: "Beans", priceEach: 199))
        
        register.addCoupon(Coupon(itemName: "Beans"))

        let receipt = register.total()

        XCTAssertEqual(369, receipt.total())
    }

    
    

}
