//
//  detaildetail.swift
//  Public Opinion for Stock
//
//  Created by 장준하 on 6/2/25.
//
import SwiftUI

struct DetailExplainView: View {

    @State private var selectedSentiment: Sentiment = .positive
    @State var feedbacks: [Feedback] = []

    let sectorDetailDetail: [String: Any]?
    let date: String
    let selectedSector: String

    var body: some View {
        VStack(spacing: 0) {
            DetailExplainTopView(selectedSentiment: $selectedSentiment, selectedSector: selectedSector, date: date)

            DetailExplainMainView(selectedSentiment: $selectedSentiment, feedbacks: feedbacks)
        }
        .onAppear {
            loadFeedbacks()
        }
        .navigationBarHidden(true)
    }
}