import Foundation

enum AIDifficulty {
    case beginner
    case intermediate
    case expert
}

enum Player: String {
    case human = "X"
    case ai = "O"
}

class TicTacToeAI {
    var boardSize: Int
    var board: [String]
    private var maxDepth: Int
    private var difficulty: AIDifficulty

    init(boardSize: Int, board: [String], difficulty: AIDifficulty) {
        self.boardSize = boardSize
        self.board = board
        self.difficulty = difficulty
        self.maxDepth = difficulty == .expert ? 5 : (difficulty == .intermediate ? 3 : 1)
    }

    func bestMove(currentBoard: [String]) -> Int? {
        self.board = currentBoard
        
        // Beginner mode: 20% chance of choosing a random move
        if difficulty == .beginner && Int.random(in: 0..<5) == 0 {
            let availableMoves = board.indices.filter { board[$0] == "" }
            return availableMoves.randomElement()
        }

        var bestScore = Int.min
        var bestMove: Int? = nil
        var alpha = Int.min
        let beta = Int.max

        for i in 0..<board.count {
            if board[i] == "" {
                board[i] = Player.ai.rawValue
                let score = minimax(isMaximizing: false, depth: 0, alpha: alpha, beta: beta)
                board[i] = ""
                
                if score > bestScore {
                    bestScore = score
                    bestMove = i
                }
                alpha = max(alpha, bestScore)
            }
        }
        return bestMove
    }

    private func minimax(isMaximizing: Bool, depth: Int, alpha: Int, beta: Int) -> Int {
        if let winner = checkWinner() {
            return winner == Player.ai.rawValue ? 10 - depth : -10 + depth
        }
        
        if board.allSatisfy({ !$0.isEmpty }) {
            return 0
        }
        
        if depth >= maxDepth {
            return heuristicEvaluation()
        }

        if isMaximizing {
            var maxEval = Int.min
            var currentAlpha = alpha
            for i in 0..<board.count where board[i] == "" {
                board[i] = Player.ai.rawValue
                let eval = minimax(isMaximizing: false, depth: depth + 1, alpha: currentAlpha, beta: beta)
                board[i] = ""
                maxEval = max(eval, maxEval)
                currentAlpha = max(currentAlpha, eval)
                if beta <= currentAlpha {
                    break
                }
            }
            return maxEval
        } else {
            var minEval = Int.max
            var currentBeta = beta
            for i in 0..<board.count where board[i] == "" {
                board[i] = Player.human.rawValue
                let eval = minimax(isMaximizing: true, depth: depth + 1, alpha: alpha, beta: currentBeta)
                board[i] = ""
                minEval = min(eval, minEval)
                currentBeta = min(currentBeta, eval)
                if currentBeta <= alpha {
                    break
                }
            }
            return minEval
        }
    }

    private func heuristicEvaluation() -> Int {
        var score = 0
        let winPatterns = winPatterns(for: boardSize)
        
        for pattern in winPatterns {
            let aiCount = pattern.filter { board[$0] == Player.ai.rawValue }.count
            let humanCount = pattern.filter { board[$0] == Player.human.rawValue }.count
            
            if aiCount == boardSize - 1 && humanCount == 0 {
                score += 5
            } else if humanCount == boardSize - 1 && aiCount == 0 {
                score -= 5
            } else if aiCount > 0 && humanCount == 0 {
                score += 1
            } else if humanCount > 0 && aiCount == 0 {
                score -= 1
            }
        }
        return score
    }

    private func checkWinner() -> String? {
        let winPatterns = winPatterns(for: boardSize)
        
        for pattern in winPatterns {
            let first = board[pattern[0]]
            if first != "", pattern.allSatisfy({ board[$0] == first }) {
                return first
            }
        }
        return nil
    }
    
    private func winPatterns(for size: Int) -> [[Int]] {
        var patterns = [[Int]]()
        
        for i in 0..<size {
            let row = (0..<size).map { i * size + $0 }
            patterns.append(row)
        }
        
        for i in 0..<size {
            let col = (0..<size).map { i + size * $0 }
            patterns.append(col)
        }
        
        let diag1 = (0..<size).map { $0 * (size + 1) }
        let diag2 = (0..<size).map { ($0 + 1) * (size - 1) }
        patterns.append(diag1)
        patterns.append(diag2)

        return patterns
    }
}
