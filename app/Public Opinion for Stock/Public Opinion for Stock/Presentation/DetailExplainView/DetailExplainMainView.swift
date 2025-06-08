import SwiftUI

struct DetailExplainMainView: View {
    @Binding var selectedSentiment: Sentiment
    let feedbacks: [Feedback]
    
    var filteredFeedbacks: [Feedback] {
        feedbacks.filter { $0.sentiment == selectedSentiment }
    }
    
    var body: some View {
        if filteredFeedbacks.isEmpty {
            VStack {
                Spacer()
                Text("의견 없음")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
        } else {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredFeedbacks) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.text)
                                .font(.body)
                                .multilineTextAlignment(.leading)

                            HStack {
                                Text(item.source)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(item.time)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(4)
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}