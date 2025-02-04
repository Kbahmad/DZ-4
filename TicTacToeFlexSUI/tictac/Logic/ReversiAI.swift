import Foundation

class ReversiAI {
    let boardSize: Int
    let evaluationTable: [[Int]]

    init(boardSize: Int) {
        self.boardSize = boardSize

        //  evaluation values for each cell on the board.
        // Corners are highly valuable, edges are less valuable.
        self.evaluationTable = [
            [100, -10, 10, 5, 5, 10, -10, 100],
            [-10, -20, 1, 1, 1, 1, -20, -10],
            [10, 1, 5, 2, 2, 5, 1, 10],
            [5, 1, 2, 0, 0, 2, 1, 5],
            [5, 1, 2, 0, 0, 2, 1, 5],
            [10, 1, 5, 2, 2, 5, 1, 10],
            [-10, -20, 1, 1, 1, 1, -20, -10],
            [100, -10, 10, 5, 5, 10, -10, 100]
        ]
    }

    // the best move for the AI based on evaluationTable
    func bestMove(for player: ReversiPlayer, in board: [[String]]) -> (row: Int, col: Int)? {
        var bestScore = Int.min
        var bestMove: (row: Int, col: Int)?

        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if board[row][col] == "" {
                    let moveScore = evaluateMove(row: row, col: col, player: player, board: board)
                    if moveScore > bestScore {
                        bestScore = moveScore
                        bestMove = (row, col)
                    }
                }
            }
        }
        return bestMove
    }

    // the desirability of a move based on the evaluationTable
    private func evaluateMove(row: Int, col: Int, player: ReversiPlayer, board: [[String]]) -> Int {
        let reversiGame = ReversiGame() // Temporary instance for move validation
        reversiGame.board = board
        if reversiGame.isValidMove(row: row, col: col, player: player) {
            return evaluationTable[row][col]
        }
        return Int.min // Invalid move
    }
}
