import SwiftUI
import Combine

struct TimeCell: View {
    @ObservedObject  var timerModel: TimerModel// why not private
    var body: some View {
        
        Text("\(timerModel.id):\(timerModel.timePassed)")
            .onAppear{
                timerModel.start()
            }
            .onDisappear{
                timerModel.stop()
            }
    }
}

class TimerModel: ObservableObject, Identifiable{
    let id:Int
    @Published  var timePassed: Double = 0//不是private 否则 CellView里看不见
    
    private var cancellable: AnyCancellable?
    
    
    init(id: Int) {
        self.id = id
    }
    
    func start(){
        cancellable = Timer.publish(every: 0.1, on:.main , in: .default)
            .autoconnect()
            .sink{ [weak self] _ in
                self?.timePassed += 0.1 //why self 不加 [weak self] 这个的话就不让用啊
            }
    }
    func stop(){
        cancellable?.cancel()
        cancellable = nil
    }
    
    
}



struct ContentView: View {
    @State private var timers: [TimerModel] = (0..<50).map{
        TimerModel(id:$0)
    }
    var body: some View {
        
        ScrollView{
            LazyVStack{
                ForEach(timers){ timer in
                    TimeCell(timerModel: timer)
                    
                }
            }
        }
        
    }
}
