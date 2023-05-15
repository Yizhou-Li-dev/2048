//
//  ScoreViewController.swift
//  assign3-v
//
//  Created by Yizhou Li on 10/14/21.
//

import Foundation

//class ScoreViewController {
//    static var scores: [Score] = [Score(score: 400, time: Date()), Score(score: 300, time: Date())]
//    
////    init() {
////        scores = [Score(score: 400, time: Date()), Score(score: 300, time: Date())]
////    }
//    
//    static func updateScores() {
//        // record the score
//        let count = UserDefaults.standard.integer(forKey: "count")
//        
//        do {
//            try UserDefaults.standard.setCodable(Score(score: Game.score, time: Date())
//                                                 , forKey: count.description)
//            UserDefaults.standard.set(count + 1, forKey: "count")
//        } catch {
//            
//        }
//        
//        let scoresCount: Int? = UserDefaults.standard.integer(forKey: "count")
//        var i = 0
//        
//        while i < (scoresCount ?? 0) {
//            scores.append(UserDefaults.standard.getCodable(Score.self, forKey: i.description)!)
//            i += 1
//        }
//    }
//}
