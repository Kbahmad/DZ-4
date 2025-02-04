import SwiftUI

struct ReversiView: View {
    @StateObject private var game = ReversiGame()
    @State private var selectedGameMode: GameMode = .humanVsHuman

    var body: some View {
        VStack {
            Text("Reversi Game")
                .font(.largeTitle)
                .padding()

            Picker("Game Mode", selection: $selectedGameMode) {
                Text("Human vs Human").tag(GameMode.humanVsHuman)
                Text("Human vs AI").tag(GameMode.humanVsAI)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedGameMode) {
                game.gameMode = selectedGameMode
                game.resetBoard()
            }

            HStack {
                if selectedGameMode == .humanVsHuman {
                    Text("Player 1 (").bold()
                    Text("Black: X")
                        .foregroundColor(.black)
                        .bold()
                    Text(")   ")
                    Text("Player 2 (").bold()
                    Text("White: O")
                        .foregroundColor(.white)
                        .padding(2)
                        .background(Color.black)
                        .cornerRadius(4)
                        .bold()
                    Text(")")
                } else {
                    Text("Human (").bold()
                    Text("Black: X")
                        .foregroundColor(.black)
                        .bold()
                    Text(")   ")
                    Text("AI (").bold()
                    Text("White: O")
                        .foregroundColor(.white)
                        .padding(2)
                        .background(Color.black)
                        .cornerRadius(4)
                        .bold()
                    Text(")")
                }
            }
            .padding()

            HStack {
                Text("Player X (Black): \(game.player1Score)")
                Text("Player O (White): \(game.player2Score)")
            }
            .padding()

            VStack(spacing: 2) {
                ForEach(0..<game.boardSize, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<game.boardSize, id: \.self) { col in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.green)
                                    .frame(width: 40, height: 40)
                                    .border(Color.black)
                                    .onTapGesture {
                                        if game.gameMode == .humanVsHuman || game.currentPlayer == .player1 {
                                            game.makeMove(row: row, col: col)
                                        }
                                    }

                                if game.board[row][col] == "X" {
                                    Circle().foregroundColor(.black).frame(width: 30, height: 30)
                                } else if game.board[row][col] == "O" {
                                    Circle().foregroundColor(.white).frame(width: 30, height: 30)
                                }
                            }
                        }
                    }
                }
            }
            .padding()

            if game.gameOver {
                Text("Game Over! \(game.winner == nil ? "Draw!" : "\(game.winner!.rawValue) Wins!")")
                    .font(.headline)
                    .padding()

                Button("New Game") {
                    game.resetBoard()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ReversiView()
}
