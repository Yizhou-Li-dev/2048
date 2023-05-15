//
//  assign3_vApp.swift
//  assign3-v
//
//  Created by Yizhou Li on 10/9/21.
//

import SwiftUI

@main
struct Assign3_vApp: App {
    @StateObject var gameViewController = Twos()
//    @StateObject var scoreViewController = ScoreViewController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameViewController)
//                .environmentObject(scoreViewController)
        }
    }
}
