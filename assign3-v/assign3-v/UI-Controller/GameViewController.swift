//
//  GameViewController.swift
//  assign3-v
//
//  Created by Yizhou Li on 10/14/21.
//

import Foundation

// the game class
class Twos: ObservableObject {
    @Published public var board: [[Tile]]!
    @Published public var tileViews: [[TileView]]!
    @Published public var scores: [Score]!
    
    @Published public var score: Int!
    @Published public var mode: Bool!
    public var seededGenerator: SeededGenerator!
    
    @Published public var isLose: Bool!
    @Published public var canTurnUp: Bool!
    @Published public var canTurnDown: Bool!
    @Published public var canTurnLeft: Bool!
    @Published public var canTurnRight: Bool!
    
//    @EnvironmentObject var scoreViewController: ScoreViewController
    
    init() {
        initBoard()
        initTileViews()
        initScores()
  
        score = 0
        mode = false
        
        isLose = false
        canTurnUp = true
        canTurnDown = true
        canTurnLeft = true
        canTurnRight = true
        
        seededGenerator = SeededGenerator(seed: 14)
        spawn()
        spawn()
    }
    
    // apply the button logic
    func handleButton(dir: Direction) {
        // Check the finish condition
        func areWeDone() {
            if !canTurnUp && !canTurnDown && !canTurnLeft && !canTurnDown {
                isLose.toggle()
            }
        }
        
        if !collapse(dir: dir) {
            switch dir {
            case .up:
                canTurnUp = false
            case .down:
                canTurnDown = false
            case .left:
                canTurnLeft = false
            case .right:
                canTurnRight = false
            }
        } else {
            canTurnUp = true
            canTurnDown = true
            canTurnLeft = true
            canTurnRight = true
        }
        
        areWeDone()
    }
    
    // initialize the tileViews
    func initTileViews() {
        tileViews = Array(repeating: [TileView](), count: 4)
        for i in 0...3 {
            for j in 0...3 {
                tileViews[i].append(TileView(tile: board[i][j]))
            }
        }
    }
    
    // initialize the board
    func initBoard() {
        board = Array(repeating: [Tile](), count: 4)
        for i in 0...3 {
            for j in 0...3 {
                board[i].append(Tile(val: 0, id: i * 4 + j, rowNow: i, colNow: j))
            }
        }
    }
    
    // initialize scores array
    func initScores() {
        scores = []

        var scoresCount = UserDefaults.standard.integer(forKey: "scoresCount")
        
        if scoresCount == 0 {
            do {
                try UserDefaults.standard.setCodable(Score(score: 400, time: Date()), forKey: "0")
                try UserDefaults.standard.setCodable(Score(score: 300, time: Date()), forKey: "1")
                UserDefaults.standard.set(2, forKey: "scoresCount")
                scoresCount = 2
            } catch {
                
            }
        }
        
        for i in 0..<scoresCount {
            scores.append(UserDefaults.standard.getCodable(Score.self, forKey: i.description)!)
        }
        
        scores.sort() { num1, num2 in
            if num1.score >= num2.score { return true }
            else { return false }
        }
    }
    
    // update scores array
    func updateScores() {
        let scoresCount = UserDefaults.standard.integer(forKey: "scoresCount")
        
        do {
            try UserDefaults.standard.setCodable(Score(score: score, time: Date()), forKey: scoresCount.description)
        } catch {
            
        }
        
        scores.append(UserDefaults.standard.getCodable(Score.self, forKey: scoresCount.description)!)
        scores.sort() { num1, num2 in
            if num1.score >= num2.score { return true }
            else { return false }
        }
        
        UserDefaults.standard.set(scoresCount + 1, forKey: "scoresCount")
    }
    
    // start a new game
    public func clearBoard(rand: Bool) {
        initBoard()
        updateScores()
        score = 0
        
        if rand == true {
            // enter random mode
            seededGenerator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
        } else {
            // enter deterministic mode
            seededGenerator = SeededGenerator(seed: 14)
        }
    }
    
    // collapse in a specific direction
    public func collapse(dir: Direction) -> Bool {
        
        func shiftLeft() {
            for i in 0...3 {
                // bubble sort; shift number to the left; ID is the orginal pos
                // , rowNow and colNow is the current pos
                for _ in 0...3 {
                    for j in 1...3 {
                        if board[i][j - 1].val == 0 {
                            let tempVal = board[i][j - 1].val
                            board[i][j - 1].val = board[i][j].val
                            board[i][j].val = tempVal
                        }
                    }
                }
            }
            
            // merge numbers if possible
            for i in 0...3 {
                var tempId = 0
                
                // Tile 0 value equals Tile 1 value
                if board[i][0].val == board[i][1].val {
                    tempId = board[i][0].id

                    board[i][0].val = board[i][0].val + board[i][1].val
                    board[i][0].id = board[i][1].id
                    
                    board[i][1].val = 0
                    board[i][1].id = tempId
                    
                    score += board[i][0].val
                    // Tile 2 value equals Tile 3 value
                    if board[i][2].val == board[i][3].val {
                        tempId = board[i][1].id

                        board[i][1].val = board[i][2].val + board[i][3].val
                        board[i][1].id = board[i][3].id
                        
                        board[i][3].id = tempId
                        
                        board[i][2].val = 0
                        
                        score += board[i][1].val
                    } else {
                        tempId = board[i][1].id
                        
                        board[i][1].id = board[i][2].id
                        board[i][1].val = board[i][2].val
                        
                        board[i][2].id = board[i][3].id
                        board[i][2].val = board[i][3].val
                        
                        board[i][3].id = tempId
                    }
                    
                    board[i][3].val = 0
                } else if board[i][1].val == board[i][2].val {
                    // Tile 1 value equals Tile 2 value
                    tempId = board[i][1].id
                    
                    board[i][1].id = board[i][2].id
                    board[i][1].val = board[i][1].val + board[i][2].val
                    
                    board[i][2].id = board[i][3].id
                    board[i][2].val = board[i][3].val
                    
                    board[i][3].id = tempId
                    board[i][3].val = 0
                    
                    score += board[i][1].val
                } else if board[i][2].val == board[i][3].val {
                    // Tile 2 value equals Tile 3 value
                    tempId = board[i][2].id
                    
                    board[i][2].id = board[i][3].id
                    board[i][2].val = board[i][2].val + board[i][3].val
                    
                    board[i][3].id = tempId
                    board[i][3].val = 0
                        
                    score += board[i][2].val
                }
            }
        }
        
        // generic version of right rotation
        func rotate2D<T>(input: [[T]]) ->[[T]] {
            var resultArray:[[T]] = Array(repeating: [], count: 4)
            for i in stride(from: 3, to: -1, by: -1) {
                for j in 0...3 {
                    resultArray[j].append(input[i][j])
                }
            }
            return resultArray
        }
        
        // define using only rotate2D
        func rightRotate() {
            board = rotate2D(input: board)
        }
        
        let tempScore = score
 
        helpUpdateBoard()

        switch dir {
        case .left:
            shiftLeft()
        case .right:
            rightRotate()
            rightRotate()
            shiftLeft()
            rightRotate()
            rightRotate()
        case .up:
            rightRotate()
            rightRotate()
            rightRotate()
            shiftLeft()
            rightRotate()
        case .down:
            rightRotate()
            shiftLeft()
            rightRotate()
            rightRotate()
            rightRotate()
        }
        
        // Return whether the collapse occured
        if !spawn() && tempScore == score {
            return false
        }
        
        return true
    }
    
    // spwan a new "tile"
    public func spawn() -> Bool {
        var num = Int.random(in: 1...2, using: &seededGenerator)
        if num == 1 {
            num = 2
        } else {
            num = 4
        }
        
        var tracker = 0
        var trackerArr = [(Int, Int)]()
        for i in 0...3 {
            for j in 0...3 {
                if board[i][j].val == 0 {
                    tracker += 1
                    trackerArr.append((i, j))
                }
            }
        }
        
        if tracker == 0 {
            return false
        } else {
            let index = Int.random(in: 1...tracker, using: &seededGenerator)
            var i, j: Int
            (i, j) = trackerArr[index - 1]
            
            board[i][j].val = num
            board[i][j].rowNow = i
            board[i][j].colNow = j
//
            // code that let spawn element stay in the same spot
//            let k = board[i].firstIndex() { num in
//                num.id == i * 4 + j
//            }
//            let tempVal = board[i][k!].val
//            let tempRow = board[i][k!].rowNow
//            let tempCol = board[i][k!].colNow
//
//            board[i][k!].val = num
//            board[i][k!].rowNow = i
//            board[i][k!].colNow = j
//
//            board[i][j].val = tempVal
//            board[i][j].rowNow = tempRow
//            board[i][j].colNow = tempCol
            // ---
        }
        
        
        helpUpdateTileViews()
        return true
    }
    
    // a helper function used to update board
    func helpUpdateBoard() {
        for i in 0...3 {
            for j in 0...3 {
                board[i][j].id = i * 4 + j
            }
        }
    }
    
    // a helper function used to update tileView
    func helpUpdateTileViews() {
        let boardCopy = board!
        for i in 0...3 {
            for j in 0...3 {
                let tempId = boardCopy[i][j].id
                let tempVal = boardCopy[i][j].val
                let tempRow = boardCopy[i][j].rowNow
                let tempCol = boardCopy[i][j].colNow

                tileViews[tempId / 4][tempId % 4].tile.val = tempVal
                tileViews[tempId / 4][tempId % 4].tile.rowNow = tempRow
                tileViews[tempId / 4][tempId % 4].tile.colNow = tempCol
            }
        }
    }
}
