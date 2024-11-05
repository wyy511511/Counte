import SwiftUI
import Combine
struct TimerCell: View {
    @ObservedObject var timerModel: TimerModel
    @EnvironmentObject var timerManager: TimerManager
    
    
    var body: some View {
        HStack{
            Text(("Timer \(timerModel.id): \(timerModel.timePassed, specifier: "%.1f") s"))
//            Button(action: timerModel.togglePause()){ //少了个大括号
//                Text(timerModel.isPaused?"resume/start":"pause")
//            }
            Button(action: {
                timerModel.togglePause()
            }){
                Text(timerModel.isPaused ?"resume/start":"pause")
            }
        }
            .onAppear{
                timerManager.showTimer(id: timerModel.id)
            }
            .onDisappear{
                timerManager.hideTimer(id: timerModel.id)
            }
        
    }
}

class TimerModel: ObservableObject, Identifiable{
    let id:Int
    @Published var timePassed: Double = 0.0
    @Published var isPaused: Bool = false //ed 而不是er
    
    init(id: Int) {
        self.id = id
    }
    
    func update(_ interval: Double){
        timePassed += interval
    }
    func togglePause(){
        isPaused.toggle()
    }
    
}

class TimerManager: ObservableObject{
    @Published var items:[TimerModel] = (0..<50).map{TimerModel(id:$0)}
    private var timer:AnyCancellable?
    private var visibleItems = Set<Int>()
    
    
    
    
    func start(){
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink{ _ in
                self.updateTimers()
            }
        
    }
    func stop(){
        timer?.cancel()
        timer = nil
    }
    func showTimer(id: Int){
        visibleItems.insert(id)
        
    }
    func hideTimer(id:Int){
        visibleItems.remove(id)
        
    }
    
    private func updateTimers(){
        let interval = 0.1
        items.filter{
            visibleItems.contains($0.id) && !$0.isPaused
        }.forEach{$0.update(interval)}
    }
}

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(timerManager.items){timer in //少了timer in
                    TimerCell(timerModel: timer)//小写
                        .environmentObject(timerManager)//小写
                }
            }
            .onAppear{
                timerManager.start()
            }
            .onDisappear{
                timerManager.stop()
            }
        }
    }
}
