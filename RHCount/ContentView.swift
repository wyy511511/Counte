//
//  ContentView.swift
//  RHCount
//
//  Created by Lunasol on 10/26/24.
//

import SwiftUI

struct TimerCell: View {
    @ObservedObject var timerModel: TimerModel

    var body: some View {
        HStack {
            Text("Timer \(timerModel.id): \(timerModel.timeElapsed, specifier: "%.1f") s")
                .padding()
            Spacer()
            Button(action: {
                timerModel.toggle()
            }) {
                Text(timerModel.isActive ? "Pause" : "Start")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

class TimerModel: ObservableObject, Identifiable {
    let id: Int
    @Published var timeElapsed: Double = 0.0
    @Published var isActive: Bool = false
    var timer: Timer?

    init(id: Int) {
        self.id = id
    }

    func toggle() {
        isActive.toggle()
        if isActive {
            start()
        } else {
            stop()
        }
    }

    private func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.timeElapsed += 0.1
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView: View {
    @State private var timers: [TimerModel] = (0..<50).map { TimerModel(id: $0) }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(timers) { timer in
                    TimerCell(timerModel: timer)
                }
            }
            .padding(.vertical)
        }
    }
}
