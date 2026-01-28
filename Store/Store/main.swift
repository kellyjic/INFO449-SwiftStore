//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String {get}
    func price() -> Int
}

class Item: SKU {
    let name: String
    private let itemPrice: Int
     
    init(name: String, priceEach: Int){
        self.name = name
        self.itemPrice = priceEach
    }
    
    func price() -> Int {
        return itemPrice
    }
}

class Receipt {
    private var scannedItems: [SKU] = []
    
    init(scannedItems: [SKU]) {
        self.scannedItems = scannedItems
    }
    
//    func scan(_ item: SKU) {
//        scannedItems.append(item)
//    }
    
    func items() -> [SKU] {
        return scannedItems
    }
    
    func total() -> Int {
        var sum = 0
        for item in scannedItems {
            sum += item.price()
        }
        return sum
    }

    func output() -> String {
        var lines: [String] = ["Receipt:"]

        for item in scannedItems {
            let dollars = Double(item.price()) / 100.0
            lines.append("\(item.name): $\(String(format: "%.2f", dollars))")
        }

        lines.append("------------------")

        let totalDollars = Double(total()) / 100.0
        lines.append("TOTAL: $\(String(format: "%.2f", totalDollars))")

        return lines.joined(separator: "\n")
    }

    
}

class Register {
    private var scannedItems: [SKU] = []
    
    func scan(_ item: SKU) {
        scannedItems.append(item)
    }
    
    func subtotal() -> Int {
        scannedItems.map { $0.price() }.reduce(0, +)
    }
    
    func total() -> Receipt {
        let receipt = Receipt(scannedItems: scannedItems)
        scannedItems.removeAll()
        return receipt
    }

}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

