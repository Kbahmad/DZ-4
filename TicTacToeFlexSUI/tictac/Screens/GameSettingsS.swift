import SwiftUI

enum GameType {
    case ticTacToe, reversi
}

struct GameSettingsS: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var selectedGame: GameType = .ticTacToe
    @State private var firstPlayer: Player = .human

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Text("Select Game")
                    .font(.title)
                    .padding()

                Picker("Game", selection: $selectedGame) {
                    Text("Tic Tac Toe").tag(GameType.ticTacToe)
                    Text("Reversi").tag(GameType.reversi)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedGame == .ticTacToe {
                    Picker("Who Starts?", selection: $firstPlayer) {
                        Text("Human First").tag(Player.human)
                        Text("AI First").tag(Player.ai)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }

                Text("Размер поля: \(gameManager.boardSize)x\(gameManager.boardSize)")
                Slider(value: Binding(
                    get: { Double(gameManager.boardSize) },
                    set: { newValue in gameManager.boardSize = Int(newValue)
                    }
                ), in: 3...10, step: 1)
                .padding()
                .disabled(selectedGame == .reversi)

                Button(action: {
                    gameManager.currentGame = selectedGame
                    gameManager.firstPlayer = firstPlayer
                    gameManager.showGame = true
                }) {
                    Text("Start")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                Spacer()
            }.navigationTitle("Game Settings")
        }
    }
}

#Preview {
    MainS().environmentObject(GameManager())
}
