//import SwiftUI
//import Combine
//
//struct TimerCell: View {
//    @ObservedObject var timerModel: TimerModel
//    @EnvironmentObject var timerManager: TimerManager
//
//    var body: some View {
//        HStack {
//            Text("Timer \(timerModel.id): \(timerModel.timeElapsed, specifier: "%.1f")s")
//            Spacer()
//            Button(action: {
//                timerModel.togglePause()
//            }) {
//                Text(timerModel.isPaused ? "Resume" : "Pause")
//                    .foregroundColor(.blue)
//            }
//            .padding()
//        }
//        .onAppear {
//            timerManager.showTimer(id: timerModel.id)
//        }
//        .onDisappear {
//            timerManager.hideTimer(id: timerModel.id)
//        }
//    }
//}
//
//class TimerModel: ObservableObject, Identifiable {
//    let id: Int
//    @Published var timeElapsed: Double = 0.0
//    @Published var isPaused: Bool = false
//
//    init(id: Int) {
//        self.id = id
//    }
//
//    func update(_ interval: TimeInterval) {
//        guard !isPaused else { return }
//        timeElapsed += interval
//    }
//    
//    func togglePause() {
//        isPaused.toggle()
//    }
//}
//
//class TimerManager: ObservableObject {
//    @Published var items: [TimerModel] = (0..<50).map { TimerModel(id: $0) }
//    private var timer: AnyCancellable?
//    private var visibleTimers = Set<Int>()
//
//    func start() {
//        timer = Timer.publish(every: 0.1, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                self?.updateTimers()
//            }
//    }
//
//    func stop() {
//        timer?.cancel()
//        timer = nil
//    }
//
//    func showTimer(id: Int) {
//        visibleTimers.insert(id)
//    }
//
//    func hideTimer(id: Int) {
//        visibleTimers.remove(id)
//    }
//
//    private func updateTimers() {
//        let interval = 0.1
//        for item in items where visibleTimers.contains(item.id) {
//            item.update(interval)
//        }
//    }
//}
//
//struct ContentView: View {
//    @StateObject private var timerManager = TimerManager()
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 10) {
//                ForEach(timerManager.items) { timer in
//                    TimerCell(timerModel: timer)
//                        .environmentObject(timerManager)
//                }
//            }
//            .padding(.vertical)
//            .onAppear {
//                timerManager.start()
//            }
//            .onDisappear {
//                timerManager.stop()
//            }
//        }
//    }
//}
//
//



import SwiftUI
import Combine

struct TimerCell: View {
    @ObservedObject var timerModel: TimerModel
    @EnvironmentObject var timerManager: TimerManager

    var body: some View {
        HStack {
            Text("Timer \(timerModel.id): \(timerModel.timeElapsed, specifier: "%.1f") s")
                .padding()
            Spacer()
//            Button(action: {
//                timerModel.togglePause()
//            }) {
//                Text(timerModel.isPaused ? "Resume" : "Pause")
//                    .foregroundColor(.blue)
//            }
//            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .onAppear {
            timerManager.showTimer(id: timerModel.id)
        }
        .onDisappear {
            timerManager.hideTimer(id: timerModel.id)
        }
    }
}

class TimerModel: ObservableObject, Identifiable {
    let id: Int
    @Published var timeElapsed: Double = 0.0
//    @Published var isPaused: Bool = false

    init(id: Int) {
        self.id = id
    }

    func update(_ interval: TimeInterval) {
//        guard !isPaused else { return }
        timeElapsed += interval
    }
    
//    func togglePause() {
//        isPaused.toggle()
//    }
}

class TimerManager: ObservableObject {
    @Published var items: [TimerModel] = (0..<50).map { TimerModel(id: $0) }
    private var timer: AnyCancellable?
    private var visibleTimers = Set<Int>()

    func start() {
        // Start a single timer that updates all visible timers
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimers()
            }
    }

    func stop() {
        timer?.cancel()
        timer = nil
    }

    func showTimer(id: Int) {
        visibleTimers.insert(id)
    }

    func hideTimer(id: Int) {
        visibleTimers.remove(id)
    }

    private func updateTimers() {
        let interval = 0.1
        for id in visibleTimers {
            if let timer = items.first(where: { $0.id == id }) {
                timer.update(interval)
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(timerManager.items) { timer in
                    TimerCell(timerModel: timer)
                        .environmentObject(timerManager)
                }
            }
            .padding(.vertical)
            .onAppear {
                timerManager.start()
            }
            .onDisappear {
                timerManager.stop()
            }
        }
    }
}


//import SwiftUI
//import Combine
//
//struct TimerCell: View {
//    @ObservedObject var timerModel: TimerModel
//
//    var body: some View {
//        HStack {
//            Text("Timer \(timerModel.id): \(timerModel.timeElapsed, specifier: "%.1f")s")
//            Spacer()
//            Button(action: {
//                timerModel.togglePause()
//            }) {
//                Text(timerModel.isPaused ? "Resume" : "Pause")
//                    .foregroundColor(.blue)
//            }
//            .padding()
//        }
//    }
//}
//
//class TimerModel: ObservableObject, Identifiable {
//    let id: Int
//    @Published var timeElapsed: Double = 0.0
//    @Published var isPaused: Bool = false
//
//    init(id: Int) {
//        self.id = id
//    }
//
//    func update(_ interval: TimeInterval) {
//        guard !isPaused else { return }
//        timeElapsed += interval
//    }
//    
//    func togglePause() {
//        isPaused.toggle()
//    }
//}
//
//class TimerManager: ObservableObject {
//    @Published var items: [TimerModel] = (0..<50).map { TimerModel(id: $0) }
//    private var timer: AnyCancellable?
//
//    func start() {
//        timer = Timer.publish(every: 0.1, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                self?.updateTimers()
//            }
//    }
//
//    func stop() {
//        timer?.cancel()
//        timer = nil
//    }
//
//    private func updateTimers() {
//        let interval = 0.1
//        for item in items {
//            item.update(interval)
//        }
//    }
//}
//
//struct ContentView: View {
//    @StateObject private var timerManager = TimerManager()
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 10) {
//                ForEach(timerManager.items) { timer in
//                    TimerCell(timerModel: timer)
//                }
//            }
//            .padding(.vertical)
//            .onAppear {
//                timerManager.start()
//            }
//            .onDisappear {
//                timerManager.stop()
//            }
//        }
//    }
//}


//import SwiftUI
//import Combine
//
//struct TimerCell: View {
//    @ObservedObject var timerModel: TimerModel
//
//    var body: some View {
//        HStack {
//            Text("Timer \(timerModel.id): \(timerModel.timeElapsed, specifier: "%.1f") s")
//                .padding()
//            Spacer()
//            Button(action: {
//                timerModel.togglePause()
//            }) {
//                Text(timerModel.isPaused ? "Resume" : "Pause")
//                    .foregroundColor(.blue)
//            }
//            .padding()
//        }
//        .background(Color(.systemGray6))
//        .cornerRadius(10)
//        .padding(.horizontal)
//        .onAppear {
//            timerModel.start()
//        }
//        .onDisappear {
//            timerModel.stop()
//        }
//    }
//}
//
//class TimerModel: ObservableObject, Identifiable {
//    let id: Int
//    @Published var timeElapsed: Double = 0.0
//    @Published var isPaused: Bool = false
//
//    private var cancellable: AnyCancellable?
//
//    init(id: Int) {
//        self.id = id
//    }
//
//    func start() {
//        if isPaused { return } // If paused, don't start
//
//        // Combine publisher that emits every 0.1 seconds
////        cancellable = Timer.publish(every: 0.1, on: .main, in: .common)
//        cancellable = Timer.publish(every: 0.1, on: .main,in:.default)//手势会阻塞
//            .autoconnect()  // Automatically starts the timer when subscribed 取消这个之后就不行了
//            .filter { [weak self] _ in
//                self?.isPaused == false // Only pass through when not paused
//            }
//            .sink { [weak self] _ in
//                self?.timeElapsed += 0.1
//            }
//    }
//
//    func stop() {
//        cancellable?.cancel()
//        cancellable = nil
//    }
//
//    func togglePause() {
//        isPaused.toggle()
//        if isPaused {
//            stop() // Cancel the timer updates
//        } else {
//            start() // Resume the timer updates
//        }
//    }
//}
//
//struct ContentView: View {
//    @State private var timers: [TimerModel] = (0..<50).map { TimerModel(id: $0) }
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 10) {
//                ForEach(timers) { timer in
//                    TimerCell(timerModel: timer)
//                }
//            }
//            .padding(.vertical)
//        }
//    }
//}

//
//
//// Mark:  50 timers
//
//
//
//import Combine
//
//struct TimerCell: View{
//    @ObservableObject var timerModel: TimerModel
//    var body: some View{
//        HStack{
//            Text("Timer \(timerModel.id): \(timerModel.timeElapsed,specifier:"%.1f")s")
//
//            Spacer
//            Button(action:{
//                timerModel.togglePause()
//            }){
//                Text(timerModel.isPaused ? "Resume/start":"Pause")
//                    .foregroundColor(.blue)
//            }
//            .padding
//        }
//        .onAppear{
//            
//        }
//    }
//}
//
//
//class TimerModel: ObservableObject, Identifiable {
//    let id: Int
//    @Published var timeElapsed: Double = 0.0//double vs float?
//    @Published var isPaused: Bool = false
//
//    private var timer: Timer? //为啥要问号 为啥不在这里lazy
//    init(id:Int){
//        self.id = id
//    } // 其他构造器知识
//    
//    func start(){
//        guard !isPaused else {return} //
//        timer = Timer.scheduledTimer(withTimeInterval:0.1, repeats:true){_ in
//            self.timeElapsed +=0.1
//        } //用slector的另一种写 还有个叫block的
//    }
//    func stop(){
//        timer?.invalidate()//
//        timer = nil //
//    }
//
//    func togglePause(){
//        isPaused.toggle()
//        if isPaused{
//            stop()
//        }else{
//            start()
//        }//why not use ？ ：
//    }
//
//
//}
//struct ContentView: View{
//    @State private var items:[TimerModel] = (0<..50).map{ TimerModel(id:$0)} //why $0
//
//    var body: some View{
//        ScrollView{
//            LazyVStack(spacing:10){ //why LazyVStack  这里lazy和timer lazy相比 ？
//                ForEach(timers) {timer in
//                    TimerCell(timerModel: timer)
//                }
//            }
//            .padding(.vertical)
//        }
//    }
//}
