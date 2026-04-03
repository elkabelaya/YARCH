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
     @State var linear: Bool = true
     let data: CatalogDetailsHistogramViewModel

     var body: some View {
         ZStack(alignment: .bottomTrailing) {
             Chart(data.data) { candle in
                 if linear {
                     LineMark(
                         x: .value("Date", candle.date),
                         y: .value("Value", candle.close)
                     )
                     .interpolationMethod(.catmullRom)
                 } else {
                     RuleMark(
                         x: .value("Date", candle.date),
                         yStart: .value("Low", candle.low),
                         yEnd: .value("High", candle.high)
                     )
                     .foregroundStyle(candle.close >= candle.open ? .green : .red)

                     BarMark(
                         x: .value("Date", candle.date),
                         yStart: .value("Open", candle.open),
                         yEnd: .value("Close", candle.close),
                         width: 10
                     )
                     .foregroundStyle(candle.close >= candle.open ? .green : .red)
                 }

             }
             .chartYScale(domain: data.min...data.max)
             .chartXAxis {
                 AxisMarks(position: .bottom)
             }
             .chartYAxis {
                 AxisMarks(position: .leading)
             }
             .padding()

             Button(action: {linear.toggle()},
                    label: {
                 Text(linear ? "Candle" : "Line")

             })
             .buttonStyle(.borderedProminent)
             .padding(16)
         }
     }
 }
