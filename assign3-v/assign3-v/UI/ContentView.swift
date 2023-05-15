//
//  ContentView.swift
//  assign3
//
//  Created by Yizhou Li on 10/3/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GameView().tabItem {
                Label("Board", systemImage: "gamecontroller")
            }
            ScoreView().tabItem {
                Label("Scores", systemImage: "list.dash")
            }
            AboutView().tabItem {
                Label("About", systemImage: "info.circle")
            }
        }
    }
}
