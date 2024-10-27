import SwiftUI

struct TimerCell: View {
    @ObservedObject var timerModel: TimerModel
    var onVisibleChange: (Bool) -> Void

    var body: some View {
        HStack {
            Text("Timer \(timerModel.id): \(timerModel.timeElapsed, specifier: "%.1f") s")
                .padding()
            Spacer()
            Button(action: {
                timerModel.togglePause()
            }) {
                Text(timerModel.isPaused ? "Resume" : "Pause")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .background(
            GeometryReader { geometry in
                Color.clear.onChange(of: geometry.frame(in: .global).minY) { _ in
                    let isVisible = geometry.frame(in: .global).minY < UIScreen.main.bounds.height &&
                                    geometry.frame(in: .global).maxY > 0
                    onVisibleChange(isVisible)
                }
            }
        )
    }
}

class TimerModel: ObservableObject, Identifiable {
    let id: Int
    @Published var timeElapsed: Double = 0.0
    @Published var isPaused: Bool = false
    private var timer: Timer?

    init(id: Int) {
        self.id = id
    }

    func start() {
        guard !isPaused else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.timeElapsed += 0.1
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func togglePause() {
        isPaused.toggle()
        if isPaused {
            stop()
        } else {
            start()
        }
    }
}

struct ContentView: View {
    @State private var timers: [TimerModel] = (0..<50).map { TimerModel(id: $0) }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(timers) { timer in
                    TimerCell(timerModel: timer) { isVisible in
                        if isVisible && !timer.isPaused {
                            timer.start()
                        } else {
                            timer.stop()
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

