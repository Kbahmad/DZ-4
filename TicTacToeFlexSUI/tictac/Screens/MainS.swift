import SwiftUI

struct MainS: View {
    @StateObject var gameManager = GameManager()

    var body: some View {
        if gameManager.showGame {
            if gameManager.currentGame == .ticTacToe {
                GridS(difficulty: gameManager.aiDifficulty)
                    .environmentObject(gameManager)
            } else if gameManager.currentGame == .reversi {
                ReversiView()
                    .environmentObject(gameManager)
            }
        } else {
            GameSettingsS()
                .environmentObject(gameManager)
        }
    }
}

#Preview {
    MainS()
}
