//
//  model.swift
//  assign3
//
//  Created by Yizhou Li on 10/3/21.
//

import Foundation

//struct Game {
//    static var score = 0
//}

struct Tile: Equatable {
    var val, id, rowNow, colNow : Int
}

struct Score: Hashable, Codable {
    var score: Int
    var time: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
    
    init(score: Int, time: Date) {
        self.score = score
        self.time = time
    }
}

enum Direction {
    case left
    case right
    case up
    case down
}
