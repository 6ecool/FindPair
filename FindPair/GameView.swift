import SwiftUI

struct GameView: View {
    let gridSize: Int 

    @State private var emojis: [String] = []
    @State private var revealed: [Bool] = []
    @State private var matched: [Bool] = []
    @State private var faceUpIndices: [Int] = []
    @State private var winShown: Bool = false

    @Environment(\.dismiss) var dismiss

    private let allEmojis = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼",
                             "🐨","🐯","🦁","🐮","🐷","🐸","🐵","🐔",
                             "🐧","🐦","🐴","🦄","🐝","🦋","🐞","🐢"]

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Text("\(gridSize) × \(gridSize) Game")
                        .font(.title)
                        .bold()
                    Spacer()
                    Button("Restart") {
                        withAnimation { setupGame() }
                    }
                    .padding(8)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                GeometryReader { geometry in
                    let spacing: CGFloat = 12
                    let totalWidth = geometry.size.width - 32
                    let itemWidth = (totalWidth - spacing * CGFloat(gridSize - 1)) / CGFloat(gridSize)
                    let columns = Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing), count: gridSize)

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(emojis.indices, id: \.self) { index in
                                Button {
                                    cardTapped(index: index)
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(matched[index] ? Color.gray.opacity(0.3) : Color(UIColor.secondarySystemBackground))
                                            .frame(height: itemWidth)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                            )

                                        Text(revealed[index] ? emojis[index] : "")
                                            .font(.system(size: min(72, itemWidth * 0.6)))
                                            .frame(width: itemWidth, height: itemWidth)
                                    }
                                }
                                .disabled(matched[index])
                            }
                        }
                        .padding(16)
                    }
                }
                .frame(maxHeight: .infinity)

                Spacer()
            }


            if winShown {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("🎉 You Win! 🎉")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)

                    Text("Congratulations, you found all pairs!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)

                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation { setupGame() }
                        }) {
                            Text("Play Again")
                                .frame(minWidth: 120, minHeight: 44)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            dismiss() // ✅ возвращаемся в MainView
                        }) {
                            Text("Close")
                                .frame(minWidth: 120, minHeight: 44)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 300)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .onAppear(perform: setupGame)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: winShown)
    }



    private func setupGame() {
        
        let total = gridSize * gridSize
        let pairsCount = total / 2

        var pool = allEmojis.shuffled()
        if pool.count < pairsCount {
            pool += allEmojis.shuffled()
        }
        let chosen = Array(pool.prefix(pairsCount))

        var list: [String] = []
        for e in chosen {
            list.append(e)
            list.append(e)
        }
        list.shuffle()

        emojis = list
        revealed = Array(repeating: false, count: total)
        matched = Array(repeating: false, count: total)
        faceUpIndices = []
        winShown = false
    }

    private func cardTapped(index: Int) {
        if matched[index] { return }

        if faceUpIndices.count == 2 {
            let a = faceUpIndices[0], b = faceUpIndices[1]
            if emojis[a] != emojis[b] {
                revealed[a] = false
                revealed[b] = false
            }
            faceUpIndices.removeAll()
        }

        if revealed[index] { return }

        withAnimation {
            revealed[index] = true
        }
        faceUpIndices.append(index)

        if faceUpIndices.count == 2 {
            let a = faceUpIndices[0], b = faceUpIndices[1]
            if emojis[a] == emojis[b] {
                matched[a] = true
                matched[b] = true
                faceUpIndices.removeAll()

                if matched.filter({ $0 }).count == emojis.count {
                    withAnimation {
                        winShown = true
                    }
                }
            }
        }
    }
}
