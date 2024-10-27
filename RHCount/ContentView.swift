//
//  ContentView.swift
//  RHCount
//
//  Created by Lunasol on 10/26/24.
//

import SwiftUI
import Combine

// 定义计时器数据模型
class TimerCellModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var time: Int = 0
    private var timer: AnyCancellable?
    
    // 开始计时
    func start() {
        stop() // 防止重复启动
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.time += 1
            }
    }
    
    // 停止计时
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    // 重置计时器
    func reset() {
        stop()
        time = 0
    }
}

struct ContentView: View {
    @State private var cellModels = Array(repeating: TimerCellModel(), count: 50) // 生成50个cell的计时器模型
    @State private var visibleCells = Set<UUID>() // 用于追踪当前可见cell
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(cellModels) { model in
                    TimerCellView(model: model)
                        .onAppear {
                            visibleCells.insert(model.id)
                            model.start()
                        }
                        .onDisappear {
                            visibleCells.remove(model.id)
                            model.stop()
                        }
                }
            }
        }
    }
}

struct TimerCellView: View {
    @ObservedObject var model: TimerCellModel
    @State private var isPaused = false
    
    var body: some View {
        HStack {
            Text("Timer: \(model.time / 10).\(model.time % 10) s")
                .padding()
            Spacer()
            Button(action: {
                isPaused.toggle()
                if isPaused {
                    model.stop()
                } else {
                    model.start()
                }
            }) {
                Text(isPaused ? "Resume" : "Pause")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .background(Color(.gray))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
