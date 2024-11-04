import SwiftUI
import Combine

struct TimerCell: View {
    @ObservedObject var timerModel: TimerModel

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
        .onAppear {
            timerModel.start()
        }
        .onDisappear {
            timerModel.stop()
        }
    }
}

class TimerModel: ObservableObject, Identifiable {
    let id: Int
    @Published var timeElapsed: Double = 0.0
    @Published var isPaused: Bool = false

    private var cancellable: AnyCancellable?

    init(id: Int) {
        self.id = id
    }

    func start() {
        if isPaused { return } // If paused, don't start

        // Combine publisher that emits every 0.1 seconds
        cancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()  // Automatically starts the timer when subscribed
            .filter { [weak self] _ in
                self?.isPaused == false // Only pass through when not paused
            }
            .sink { [weak self] _ in
                self?.timeElapsed += 0.1
            }
    }

    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }

    func togglePause() {
        isPaused.toggle()
        if isPaused {
            stop() // Cancel the timer updates
        } else {
            start() // Resume the timer updates
        }
    }
}

struct ContentView: View {
    @State private var timers: [TimerModel] = (0..<50).map { TimerModel(id: $0) }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(timers) { timer in
                    TimerCell(timerModel: timer)
                }
            }
            .padding(.vertical)
        }
    }
}

