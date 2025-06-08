//
//  SentimentPoint.swift
//  Public Opinion for Stock
//
//  Created by 유승재 on 6/2/25.
//

import SwiftUI
import Charts

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}

struct SentimentPoint: Identifiable {
    let id = UUID()
    let date: String
    let value: Int
    let type: String
}

struct SentimentChartView: View {
    let records: [SentimentRecord]
    var body: some View {
        Chart {
            // 긍정 곡선
            ForEach(records) { record in
                LineMark(
                    x: .value("Date", record.date.toDate() ?? Date()),
                    y: .value("Value", record.positive),
                    series: .value("Type", "긍정적")
                )
                .foregroundStyle(.red)
                .interpolationMethod(.catmullRom)
            }
            // 부정 곡선
            ForEach(records) { record in
                LineMark(
                    x: .value("Date", record.date.toDate() ?? Date()),
                    y: .value("Value", record.negative),
                    series: .value("Type", "부정적")
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom)
            }
            // 중립 곡선
            ForEach(records) { record in
                LineMark(
                    x: .value("Date", record.date.toDate() ?? Date()),
                    y: .value("Value", record.neutral),
                    series: .value("Type", "중립")
                )
                .foregroundStyle(.gray)
                .interpolationMethod(.catmullRom)
            }
        }
        .frame(height: 220)
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
            }
        }
    }
}