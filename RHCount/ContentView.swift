

import SwiftUI
import Combine

struct TimeCell: View {
    @ObservedObject  var timerModel: TimerModel// why not private
    var body: some View {
        
        HStack{
            Text("\(timerModel.id):\(timerModel.timePassed)")
            Button(action: {
                timerModel.togglePause()
            }){
                Text(timerModel.isPaused ? "resume":"stop")
                
            }
        }
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
    @Published var isPaused : Bool = false
    
    private var cancellable: AnyCancellable?
    
    
    init(id: Int) {
        self.id = id
    }
    
    func start(){
        if isPaused {return }
        cancellable = Timer.publish(every: 0.1, on:.main , in: .default)
            .autoconnect()
            .filter{ [weak self] _ in
                self?.isPaused == false
            }
            .sink{ [weak self] _ in
                self?.timePassed += 0.1 //why self 不加 [weak self] 这个的话就不让用啊
            }
    }
    func stop(){
        cancellable?.cancel()
        cancellable = nil
    }
    
    func togglePause(){
        isPaused.toggle()
        if isPaused{ //为啥要加这一部分
            stop()
        }else{
            start()
        }
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
