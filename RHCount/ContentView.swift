
import SwiftUI

struct TimerCell: View {
    @ObservedObject var timerModel: TimerModel
    var isFocused: Bool

    var body: some View {
        HStack {
            Text("Timer \(timerModel.id): \(timerModel.timeElapsed, specifier: "%.1f") s")
                .padding()
            Spacer()
        }
        .background(isFocused ? Color.blue.opacity(0.2) : Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isFocused ? .isSelected : [])
    }
}

class TimerModel: ObservableObject, Identifiable {
    let id: Int
    @Published var timeElapsed: Double = 0.0
    @Published var isActive: Bool = false {
        didSet {
            isActive ? start() : stop()
        }
    }
    private var timer: Timer?

    init(id: Int) {
        self.id = id
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

struct AccessibilityFocusController: UIViewRepresentable {
    @Binding var focusedIndex: Int?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            self.updateAccessibilityFocus()
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        updateAccessibilityFocus()
    }

    private func updateAccessibilityFocus() {
        guard let index = focusedIndex else { return }
        let announcement = "Focused on Timer \(index)"
        UIAccessibility.post(notification: .layoutChanged, argument: announcement)
    }
}

struct ContentView: View {
    @State private var timers: [TimerModel] = (0..<50).map { TimerModel(id: $0) }
    @State private var focusedIndex: Int? = nil

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(timers) { timer in
                        TimerCell(timerModel: timer, isFocused: focusedIndex == timer.id)
                            .onTapGesture {
                                if focusedIndex == timer.id {
                                    focusedIndex = nil // Remove focus
                                } else {
                                    focusedIndex = timer.id // Set focus to tapped cell
                                }
                            }
                            .onChange(of: focusedIndex) { newFocus in
                                if newFocus == timer.id {
                                    timer.isActive = true
                                } else {
                                    timer.isActive = false
                                }
                            }
                    }
                }
                .padding(.vertical)
            }
            
            // Accessibility Focus Controller
            AccessibilityFocusController(focusedIndex: $focusedIndex)
                .frame(width: 1, height: 1)
//                .hidden()
        }
    }
}

