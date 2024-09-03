//
//  ContentView.swift
//  QuickSortVisualiser
//
//  Created by Hanisa Hilole on 3/9/2024.
//

import SwiftUI
import Charts

struct ContentView: View {
    var input: [Int] {
        var array = [Int]()
        for i in 1...30 {
            array.append(i)
        }
        
        return array.shuffled()
    }
    
    @State var data = [Int]()
    @State var activeValue = 0
    @State var previousValue = 0
    @State var pivotValue = 0
    
    
    var body: some View {
        NavigationView {
            VStack {
                Chart {
                    ForEach(Array(zip(data.indices, data)), id:\.0) { index, item in
                        BarMark(x: .value("Position", index), y: .value("Value", item))
                            .foregroundStyle(getColour(value: item).gradient)
                    }
                    
                }
                .frame(width: 330, height: 350)
                .foregroundStyle(.blue)
                .padding(25)
                
                Button {
                    quickSort(low: 0, high: data.count - 1)
                } label: {
                    Text("Sort using Quick Sort!")
                        .tint(.black)
                        .fontWeight(.semibold)
                }
                .padding(16)
                .background(.black.opacity(0.15))
                .clipShape(.buttonBorder)
                
            }
            .onAppear {
                data = input
            }
            .navigationTitle("Quick Sort Demo ⚡️")
        }
        
    }
    
    
    func quickSort(low: Int, high: Int) {
        if low < high {
            Task {
                var pivotIndex = try await  partition(low: low, high: high)
                quickSort(low: low, high: pivotIndex - 1)
                quickSort(low: pivotIndex + 1, high: high)
            }
            
            
            
        }
    }

    
    func partition(low: Int, high: Int) async -> Int {
            let pivot = data[high]
            var i = low - 1
            
            for j in low..<high {
                activeValue = data[j]
                pivotValue = pivot
                
                if data[j] <= pivot {
                    i += 1
                    data.swapAt(i, j)
                    previousValue = data[i]
                    try? await Task.sleep(for: .milliseconds(500))
                }
            }
            data.swapAt(i + 1, high)
            return i + 1
        }
    
    func getColour(value: Int) -> Color {
        if value == activeValue {
            return .green
        } else if value == previousValue {
            return .yellow
        } else if value == pivotValue {
            return .red
        }
        
        return .blue
    }

}

#Preview {
    ContentView()
}
