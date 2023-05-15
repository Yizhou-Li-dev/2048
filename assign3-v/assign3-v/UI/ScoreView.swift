//
//  ScoreView.swift
//  assign3
//
//  Created by Yizhou Li on 10/9/21.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var game: Twos
    
    var body: some View {
        VStack {
            List {
                ForEach(0..<game.scores.count, id: \.self) { i in
                    Text("Score: \(game.scores[i].score) " + "Time: \(game.scores[i].time)")
                }
            }
            
            Button("clear") {
                UserDefaults.standard.removeObject(forKey: "scoresCount")

                game.scores.removeAll()
            }
        }
    }
}
