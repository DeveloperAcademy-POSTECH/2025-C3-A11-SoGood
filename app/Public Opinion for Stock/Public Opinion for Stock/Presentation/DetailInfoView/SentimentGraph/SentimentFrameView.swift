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
                SentimentTextView(records: viewModel.records)
            }
            Spacer()
        }
        .padding()
    }
}
