import Foundation

enum GameMode {
    case humanVsHuman
    case humanVsAI
}

enum ReversiPlayer: String {
    case player1 = "X"
    case player2 = "O"
}

class ReversiGame: ObservableObject {
    @Published var board: [[String]]
    @Published var currentPlayer: ReversiPlayer = .player1
    @Published var player1Score = 2
    @Published var player2Score = 2
    @Published var gameOver = false
    @Published var winner: ReversiPlayer?
    @Published var gameMode: GameMode = .humanVsHuman

    let boardSize: Int = 8
    private var ai: ReversiAI?

    init() {

        self.board = Array(repeating: Array(repeating: "", count: boardSize), count: boardSize)
        resetBoard()
    }

    func resetBoard() {

        board = Array(repeating: Array(repeating: "", count: boardSize), count: boardSize)
        board[3][3] = ReversiPlayer.player1.rawValue
        board[3][4] = ReversiPlayer.player2.rawValue
        board[4][3] = ReversiPlayer.player2.rawValue
        board[4][4] = ReversiPlayer.player1.rawValue
        currentPlayer = .player1
        player1Score = 2
        player2Score = 2
        gameOver = false
        winner = nil
        ai = gameMode == .humanVsAI ? ReversiAI(boardSize: boardSize) : nil
    }

    func makeMove(row: Int, col: Int) {
        guard board[row][col] == "", isValidMove(row: row, col: col, player: currentPlayer) else { return }

        board[row][col] = currentPlayer.rawValue
        flipPieces(row: row, col: col, player: currentPlayer)
        updateScores()

        if !hasValidMove(for: .player1) && !hasValidMove(for: .player2) {
            gameOver = true
            determineWinner()
            return
        }

        currentPlayer = currentPlayer == .player1 ? .player2 : .player1

        if gameMode == .humanVsAI && currentPlayer == .player2 {
            aiMove()
        }
    }

    private func aiMove() {
        if let aiMove = ai?.bestMove(for: .player2, in: board) {
            makeMove(row: aiMove.row, col: aiMove.col)
        }
    }

    func isValidMove(row: Int, col: Int, player: ReversiPlayer) -> Bool {

        return directions.contains { direction in
            canFlipInDirection(row: row, col: col, player: player, direction: direction)
        }
    }

    private func canFlipInDirection(row: Int, col: Int, player: ReversiPlayer, direction: (Int, Int)) -> Bool {
        let opponent = player == .player1 ? ReversiPlayer.player2.rawValue : ReversiPlayer.player1.rawValue
        var r = row + direction.0
        var c = col + direction.1
        var foundOpponentPiece = false

        while r >= 0 && r < boardSize && c >= 0 && c < boardSize {
            if board[r][c] == opponent {
                foundOpponentPiece = true
            } else if board[r][c] == player.rawValue && foundOpponentPiece {
                return true
            } else {
                break
            }
            r += direction.0
            c += direction.1
        }
        return false
    }

    private func flipPieces(row: Int, col: Int, player: ReversiPlayer) {
        for direction in directions {
            if canFlipInDirection(row: row, col: col, player: player, direction: direction) {
                flipInDirection(row: row, col: col, player: player, direction: direction)
            }
        }
    }

    private func flipInDirection(row: Int, col: Int, player: ReversiPlayer, direction: (Int, Int)) {
        let opponent = player == .player1 ? ReversiPlayer.player2.rawValue : ReversiPlayer.player1.rawValue
        var r = row + direction.0
        var c = col + direction.1

        while r >= 0 && r < boardSize && c >= 0 && c < boardSize && board[r][c] == opponent {
            board[r][c] = player.rawValue
            r += direction.0
            c += direction.1
        }
    }

    private func updateScores() {
        player1Score = board.flatMap { $0 }.filter { $0 == ReversiPlayer.player1.rawValue }.count
        player2Score = board.flatMap { $0 }.filter { $0 == ReversiPlayer.player2.rawValue }.count
    }

    private func determineWinner() {
        if player1Score > player2Score {
            winner = .player1
        } else if player2Score > player1Score {
            winner = .player2
        } else {
            winner = nil
        }
    }

    private func hasValidMove(for player: ReversiPlayer) -> Bool {
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if board[row][col] == "" && isValidMove(row: row, col: col, player: player) {
                    return true
                }
            }
        }
        return false
    }

    private let directions = [
        (-1, 0), (1, 0), (0, -1), (0, 1),
        (-1, -1), (-1, 1), (1, -1), (1, 1)
    ]
}
