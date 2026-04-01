//
//  LinearChartView.swift
//  YARCH
//
//  Created by elka belaya  on 01.04.2026.
//  Copyright © 2026 Alfa-Bank. All rights reserved.
//
import SwiftUI
import Charts

struct LineChartView: View {
    let data: [CatalogDetailsHistogramItemViewModel]

    var body: some View {
        Chart(data) { point in
            LineMark(
                x: .value("Date", point.date),
                y: .value("Value", point.close)
            )
            .interpolationMethod(.catmullRom)
        }
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
    }
}
