//
//  PerformanceChartView.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import SwiftUI
import Charts

struct PerformanceChartView: View {
    let prices: [Double]
    
    var body: some View {
        VStack {
            if prices.isEmpty {
                Text("No Data")
                    .foregroundColor(.secondary)
            } else {
                Chart {
                    ForEach(prices.indices, id: \.self) { i in
                        LineMark(
                            x: .value("Index", i),
                            y: .value("Price", prices[i])
                        )
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .padding()
            }
        }
    }
}

struct PerformanceChartView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceChartView(prices: [34000, 35500, 36000, 37000, 38000])
    }
}
