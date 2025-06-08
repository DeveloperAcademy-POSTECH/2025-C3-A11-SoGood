import Foundation

extension DetailExplainView {
    func loadFeedbacks() {
        guard let detailData = sectorDetailDetail else { return }
        var newFeedbacks: [Feedback] = []
        
        // sectorDetailDetail의 각 채널을 순회
        for (channelName, channelData) in detailData {
            if let channelInfo = channelData as? [String: Any],
            let posts = channelInfo["posts"] as? [[String: Any]],
            let score = channelInfo["score"] as? Int {
                
                // score를 기반으로 sentiment 결정
                let sentiment: Sentiment = {
                    switch score {
                    case 60...: return .positive
                    case ..<40: return .negative
                    default: return .neutral
                    }
                }()
                
                // 각 포스트를 Feedback으로 변환
                for post in posts {
                    if let content = post["content"] as? String,
                    let time = post["time"] as? String {
                        
                        let feedback = Feedback(
                            id: UUID().uuidString,
                            text: content,
                            source: channelName,  // 채널 이름을 source로 사용
                            time: time.components(separatedBy: " ")[1],  // "2025-06-07 07:53:42" -> "07:53:42"
                            sentiment: sentiment  // score 기반으로 결정된 sentiment
                        )
                        newFeedbacks.append(feedback)
                    }
                }
            }
        }
        self.feedbacks = newFeedbacks
    }
}