//
//  GameView.swift
//  assign3
//
//  Created by Yizhou Li on 10/9/21.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var game: Twos
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea(.all)
            Text("""
                    Your Final Score is: \(game.score)
                 Swipe Down To Start A New Game
                 """)
        }
    }
}

struct ButtonView: View {
    @EnvironmentObject var game: Twos
    
    let name: String
    let dir: Direction
    
    var body: some View {
        Button(name) {
            game.handleButton(dir: dir)
        }
        .padding(.all)
    }
}

struct TileView: View {
    @EnvironmentObject var game: Twos
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var tile: Tile
    
    func setGridColor(num: Int) -> Color {
        switch num {
        case 0:
            return Color(hue: 0.1639, saturation: 0, brightness: 0.5)
        case 2:
            return Color(hue: 0.1639, saturation: 0.1, brightness: 0.5)
        case 4:
            return Color(hue: 0.1639, saturation: 0.2, brightness: 0.6)
        case 8:
            return Color(hue: 0.1639, saturation: 0.3, brightness: 0.7)
        case 16:
            return Color(hue: 0.1639, saturation: 0.4, brightness: 0.8)
        case 32:
            return Color(hue: 0.1639, saturation: 0.5, brightness: 0.9)
        case 64:
            return Color(hue: 0.1639, saturation: 0.6, brightness: 1)
        case 128:
            return Color(hue: 0.1639, saturation: 0.7, brightness: 1)
        default:
            return Color(hue: 0.1639, saturation: 1, brightness: 1)
        }
    }
    
    func setGridNum(num: Int) -> String {
        switch num {
        case 0:
            return ""
        default:
            return num.description
        }
    }
    
    var body: some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            width = 50
            height = 50
        } else {
            width = 30
            height = 30
        }
        
        return Text(setGridNum(num: tile.val))
            .frame(width: width, height: height)
            .padding(.all)
            .background(setGridColor(num: tile.val))
    }
}

struct GameView: View {
    @EnvironmentObject var game: Twos
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    func moveTo(t: Tile) -> (x: CGFloat, y: CGFloat) {
        var distanceX = 0
        var distanceY = 0
        
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            distanceX = 90
            distanceY = 90
        } else {
            distanceX = 70
            distanceY = 70
        }
        
        if t.id == t.rowNow * 4 + t.colNow {
            return (0, 0)
        } else {
            return (CGFloat(-(t.id % 4 - t.colNow) * distanceX), CGFloat(-(t.id / 4 - t.rowNow) * distanceY))
        }
    }
    
    var body: some View {
        let detectDirectionalDrags = DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                print(value.translation)
                
                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                    game.handleButton(dir: .left)
                    print("left swipe")
                }
                else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                    game.handleButton(dir: .right)
                    print("right swipe")
                }
                else if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
                    game.handleButton(dir: .up)
                    print("up swipe")
                }
                else if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                    game.handleButton(dir: .down)
                    print("down swipe")
                }
                else {
                    print("no clue")
                }
            }
        
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            // iPhone portrait
            VStack {
                Text("Score: \(game.score)")
                    .foregroundColor(Color.purple)
                    .padding(.vertical)
                
                // tileview parts
                VStack {
                    ForEach(0..<4, id: \.self) { i in
                        HStack {
                            ForEach(0..<4, id: \.self) { j in
                                game.tileViews[i][j]
                                    .offset(x: moveTo(t: game.tileViews[i][j].tile).x
                                            , y: moveTo(t: game.tileViews[i][j].tile).y)
                                    .animation(.easeInOut(duration: 1))
                            }
                        }
                    }
                }
                .gesture(detectDirectionalDrags)

                
                ButtonView(name: "Up", dir: .up)
                HStack {
                    ButtonView(name: "Left", dir: .left)
                    ButtonView(name: "Right", dir: .right)
                }
                ButtonView(name: "Down", dir: .down)
                
                Button("New Game") {
                    game.clearBoard(rand: game.mode)
                    game.spawn()
                    game.spawn()
                }
                
                Toggle(isOn: $game.mode) {
                    Text("Random or Deterministic")
                }
                .padding(.all)
                
                Text("\(game.mode ? "New game will start with Random mode" : "New game will start with Deterministic mode")")
                
            }.sheet(isPresented: $game.isLose, onDismiss: {
                game.clearBoard(rand: game.mode)
                game.spawn()
                game.spawn()
            }, content: {SummaryView()})
        }
        else {
            // iPhone Landscape
            HStack {
                VStack {
                    Text("Score: \(game.score)")
                        .foregroundColor(Color.purple)
                        .padding(.vertical)
                    
                    // tileview parts
                    VStack {
                        ForEach(0..<4, id: \.self) { i in
                            HStack {
                                ForEach(0..<4, id: \.self) { j in
                                    game.tileViews[i][j]
                                        .offset(x: moveTo(t: game.tileViews[i][j].tile).x
                                                , y: moveTo(t: game.tileViews[i][j].tile).y)
                                        .animation(.easeInOut(duration: 1))
                                }
                            }
                        }
                    }
                    .gesture(detectDirectionalDrags)
                }
                VStack {
                    HStack {
                        ButtonView(name: "Left", dir: .left)
                        
                        VStack {
                            ButtonView(name: "Up", dir: .up)
                            ButtonView(name: "Down", dir: .down)
                        }
                        
                        ButtonView(name: "Right", dir: .right)
                    }
                    
                    Button("New Game") {
                        game.clearBoard(rand: game.mode)
                        game.spawn()
                        game.spawn()
                    }
                    
                    Toggle(isOn: $game.mode) {
                        Text("Random or Deterministic")
                    }
                    .padding(.all)
                    
                    Text("\(game.mode ? "New game will start with Random mode" : "New game will start with Deterministic mode")")
                }
            }.sheet(isPresented: $game.isLose, onDismiss: {
                game.clearBoard(rand: game.mode)
                game.spawn()
                game.spawn()
            }, content: {SummaryView()})
        }
    }
}

