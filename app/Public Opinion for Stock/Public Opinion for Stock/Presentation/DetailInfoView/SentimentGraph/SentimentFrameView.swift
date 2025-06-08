//
//  ContentView.swift
//  Public Opinion for Stock
//
//  Created by 유승재 on 5/29/25.
//

import SwiftUI
import Charts
import FirebaseFirestore

struct SentimentFrameView: View {
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
                }
            }
            Spacer()
        }
        .padding()
    }
}
