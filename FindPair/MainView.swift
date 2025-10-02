import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                VStack(spacing: 32) {
                    Text("Find Pair")
                        .font(.largeTitle)
                        .bold()

                    Text("Choose grid size")
                        .font(.headline)

                    VStack(spacing: 16) {
                        NavigationLink(destination: GameView(gridSize: 2)) {
                            Text("2 × 2")
                                .frame(minWidth: 200, minHeight: 50)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        NavigationLink(destination: GameView(gridSize: 4)) {
                            Text("4 × 4")
                                .frame(minWidth: 200, minHeight: 50)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}
