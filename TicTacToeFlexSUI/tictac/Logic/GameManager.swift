import Foundation

class GameManager: ObservableObject {
    @Published var showGame: Bool = false
    @Published var boardSize: Int = 3
    @Published var currentGame: GameType = .ticTacToe
    @Published var firstPlayer: Player = .human
    @Published var aiDifficulty: AIDifficulty = .expert // Default difficulty
    
}
