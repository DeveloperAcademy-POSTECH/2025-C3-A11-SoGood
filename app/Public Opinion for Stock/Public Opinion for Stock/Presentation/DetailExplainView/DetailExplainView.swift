//
//  detaildetail.swift
//  Public Opinion for Stock
//
//  Created by 장준하 on 6/2/25.
//
import SwiftUI

struct DetailExplainView: View {
    enum Sentiment: String, CaseIterable {
        case positive = "긍정적 의견"
        case negative = "부정적 의견"
        case neutral = "중립적 의견"
        
        var color: Color {
            switch self {
            case .positive: return .red
            case .negative: return .blue
            case .neutral: return .gray
            }
        }
    }

    struct Feedback: Identifiable {
        let id: String
        let text: String
        let source: String
        let time: String
        let sentiment: Sentiment
    }

    @Environment(\.dismiss) private var dismiss
    @Namespace private var underlineNamespace
    @State private var selectedSentiment: Sentiment = .positive
    @State private var feedbacks: [Feedback] = []

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                }

                HStack(spacing: 0) {
                    ForEach(Sentiment.allCases, id: \.self) { sentiment in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedSentiment = sentiment
                            }
                        }) {
                            VStack(spacing: 4) {
                                Text(sentiment.rawValue)
                                    .font(.system(size: 16))
                                    .fontWeight(selectedSentiment == sentiment ? .semibold : .regular)
                                    .foregroundColor(selectedSentiment == sentiment ? sentiment.color : .gray)
                                    .frame(maxWidth: .infinity)

                                ZStack {
                                    if selectedSentiment == sentiment {
                                        Rectangle()
                                            .fill(sentiment.color)
                                            .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                                            .frame(height: 3)
                                    } else {
                                        Rectangle()
                                            .fill(Color.clear)
                                            .frame(height: 3)
                                    }
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                Spacer()
                    .frame(width: 44)
            }
            .background(Color.white)

            Divider()

            Text("반도체 | \(formattedToday()) 기준")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(feedbacks.filter { $0.sentiment == selectedSentiment }) { item in
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
        .onAppear {
            loadFeedbacks()
        }
        .navigationBarHidden(true)
    }

    // MARK: - Helper: Load Dummy Feedbacks
    func loadFeedbacks() {
        self.feedbacks = [
            Feedback(
                id: UUID().uuidString,
                text: "“엔비디아, 올해 중국용 차세대 '블랙웰' 칩으로 최대 100억 달러 수익 낼 듯, 가격은 6,500~8,000달러”",
                source: "인포마켓",
                time: "06:41",
                sentiment: .positive
            ),
            Feedback(
                id: UUID().uuidString,
                text: "“TSMC, 2025년 하반기부터 세계 최초 2나노 공정 양산 시작”",
                source: "ET뉴스",
                time: "07:12",
                sentiment: .neutral
            ),
            Feedback(
                id: UUID().uuidString,
                text: "“인텔-삼성 파운드리 경쟁 격화…AI 칩 수요에 따른 설계난 주목”",
                source: "매일경제",
                time: "08:03",
                sentiment: .negative
            ),
            Feedback(
                id: UUID().uuidString,
                text: "“SK하이닉스, 차세대 HBM 공급 확대에 주가 강세”",
                source: "머니투데이",
                time: "08:45",
                sentiment: .positive
            ),
            Feedback(
                id: UUID().uuidString,
                text: "“글로벌 반도체 시장, 경기 둔화 우려 속 투자 위축 조짐”",
                source: "연합뉴스",
                time: "09:22",
                sentiment: .negative
            ),
            Feedback(
                id: UUID().uuidString,
                text: "“국내 팹리스, 미국 IRA 법안 영향 평가 중”",
                source: "ZDNet Korea",
                time: "10:01",
                sentiment: .neutral
            )
        ]
    }

    // MARK: - Helper: Format Today's Date
    func formattedToday() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: Date())
    }
}

#Preview {
    DetailExplainView()
}
