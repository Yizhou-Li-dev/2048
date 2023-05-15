//
//  Random.swift
//  assign3
//
//  Created by Yizhou Li on 10/3/21.
//

import Foundation

// a number generator
struct SeededGenerator: RandomNumberGenerator {
    let seed: UInt64
    var curr: UInt64
    init(seed: UInt64 = 0) {
        self.seed = seed
        curr = seed
    }
    
    mutating func next() -> UInt64  {
        curr = (103 &+ curr) &* 65537
        curr = (103 &+ curr) &* 65537
        curr = (103 &+ curr) &* 65537
        return curr
    }
}

// a extension allows UserDefaults to store customized objects
public extension UserDefaults {
    func setCodable<T: Codable>(_ object: T, forKey: String) throws {
        let jsonData: Data = try JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }
    
    func getCodable<T: Codable>(_ ot: T.Type, forKey: String) -> T? {
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(ot, from: result)
    }
}
