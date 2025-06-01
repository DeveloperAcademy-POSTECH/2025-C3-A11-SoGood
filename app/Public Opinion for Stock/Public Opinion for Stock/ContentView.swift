//
//  ContentView.swift
//  Public Opinion for Stock
//
//  Created by 유승재 on 5/29/25.
//

import SwiftUI
import Charts
import FirebaseFirestore

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
    let type: String // "긍정적" or "부정적"
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

struct ContentView: View {
    @EnvironmentObject var viewModel: SentimentViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("감정기록 차트")
                .font(.title2).bold()
            Text("해당 종목의 여론을 시간순으로 정리했어요.")
                .font(.subheadline)
                .foregroundColor(.gray)
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text("오류: \(error)").foregroundColor(.red)
            } else {
                SentimentChartView(records: viewModel.records)
                HStack {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("긍정적")
                                .font(.caption)
                                .foregroundColor(.red)
                            Text("\(viewModel.records.map { $0.positive }.reduce(0, +))개")
                                .font(.title3).bold()
                                .foregroundColor(.red)
                        }
                        VStack(alignment: .leading) {
                            Text("부정적")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text("\(viewModel.records.map { $0.negative }.reduce(0, +))개")
                                .font(.title3).bold()
                                .foregroundColor(.blue)
                        }
                        VStack(alignment: .leading) {
                            Text("중립적")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("\(viewModel.records.map { $0.neutral }.reduce(0, +))개")
                                .font(.title3).bold()
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Picker("섹터 선택", selection: $viewModel.selectedSector) {
                        ForEach(viewModel.sectors, id: \.self) { sector in
                            Text(sector).tag(sector)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 120)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(SentimentViewModel(category: "IT"))
}
