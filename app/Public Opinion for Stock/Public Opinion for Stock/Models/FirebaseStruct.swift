// Sector_score -> datas 데이터 구조
// name에는 섹터이름, counts에는 각 감정의 갯수
struct SectorRawScore {
    let name: String
    let count: Counts
}
extension SectorRawScore {
    static func parse(from data: [String: Any]) -> [SectorRawScore] {
        var sectorScores: [SectorRawScore] = []
        
        for (sectorName, sectorData) in data {
            if let sectorDict = sectorData as? [String: Any],
               let counts = Counts.parse(from: sectorDict) {
                let sectorScore = SectorRawScore(
                    name: sectorName,
                    count: counts
                )
                sectorScores.append(sectorScore)
            }
        }
        
        return sectorScores
    }
}

// Sector_detail -> "섹터" -> dates -> "날짜"
struct SectorDetailDate {
    let counts: Counts
    let summary: Summary
}
extension SectorDetailDate {
    static func parse(from data: [String: Any]) -> SectorDetailDate? {
        guard let countsData = data["counts"] as? [String: Any],
              let counts = Counts.parse(from: countsData),
              let summaryData = data["summary"] as? [String: [String: String]],
              let summary = Summary.parse(from: summaryData) else {
            return nil
        }
        
        return SectorDetailDate(counts: counts, summary: summary)
    }
}

// Sector_detail -> "섹터" -> detail_dates -> "날짜"
struct SectorDetailDetailDate {
    let channels: [String: Channel]
}
extension SectorDetailDetailDate {
    static func parse(from data: [String: Any]) -> SectorDetailDetailDate? {
        var channels: [String: Channel] = [:]
        
        for (channelName, channelData) in data {
            if let channelDict = channelData as? [String: Any],
               let channel = Channel.parse(from: channelDict) {
                channels[channelName] = channel
            }
        }
        
        return SectorDetailDetailDate(channels: channels)
    }
}

// 각 채널의 데이터를 담는 구조체
struct Channel {
    let posts: [Post]
    let score: Int
}
extension Channel {
    static func parse(from data: [String: Any]) -> Channel? {
        guard let score = data["score"] as? Int,
              let postsData = data["posts"] as? [[String: Any]] else {
            return nil
        }
        
        let posts = postsData.compactMap { Post.parse(from: $0) }
        return Channel(posts: posts, score: score)
    }
}

// 각 포스트의 데이터를 담는 구조체
struct Post: Codable {
    let content: String
    let time: String    // "yyyy-MM-dd HH:mm:ss" 형식
    let views: Int
}
extension Post {
    static func parse(from data: [String: Any]) -> Post? {
        guard let content = data["content"] as? String,
              let time = data["time"] as? String,
              let views = data["views"] as? Int else {
            return nil
        }
        
        return Post(content: content, time: time, views: views)
    }
}


/// 소단위 Model
// 각 섹터의 positive, negative, neutral 각 감정의 갯수
struct Counts: Codable {
    let positive: Int
    let negative: Int
    let neutral: Int
}
extension Counts {
    static func parse(from data: [String: Any]) -> Counts? {
        guard let positive = data["positive"] as? Int,
              let negative = data["negative"] as? Int,
              let neutral = data["neutral"] as? Int else {
            return nil
        }
        
        return Counts(
            positive: positive,
            negative: negative,
            neutral: neutral
        )
    }
}

// 해당 섹터 positive, neutral, negative 각 감정의 요약
struct Summary: Codable {
    let positive: SentimentDetail
    let neutral: SentimentDetail
    let negative: SentimentDetail
}
extension Summary {
    static func parse(from data: [String: [String: String]]) -> Summary? {
        guard let positiveData = data["positive"],
              let neutralData = data["neutral"],
              let negativeData = data["negative"] else {
            return nil
        }
        
        return Summary(
            positive: SentimentDetail(
                headline: positiveData["headline"] ?? "",
                summary: positiveData["summary"] ?? ""
            ),
            neutral: SentimentDetail(
                headline: neutralData["headline"] ?? "",
                summary: neutralData["summary"] ?? ""
            ),
            negative: SentimentDetail(
                headline: negativeData["headline"] ?? "",
                summary: negativeData["summary"] ?? ""
            )
        )
    }
}

// 해당 섹터 positive, neutral, negative summary Model
struct SentimentDetail: Codable {
    let headline: String
    let summary: String
}

// SectorRawScore 배열을 딕셔너리로 변환
extension Array where Element == SectorRawScore {
    func toDictionary() -> [String: [String: Int]] {
        var result: [String: [String: Int]] = [:]
        for score in self {
            result[score.name] = [
                "positive": score.count.positive,
                "negative": score.count.negative,
                "neutral": score.count.neutral
            ]
        }
        return result
    }
}

// SectorDetailDate를 딕셔너리로 변환
extension SectorDetailDate {
    func toDictionary() -> [String: Any] {
        return [
            "counts": [
                "positive": counts.positive,
                "negative": counts.negative,
                "neutral": counts.neutral
            ],
            "summary": [
                "positive": [
                    "headline": summary.positive.headline,
                    "summary": summary.positive.summary
                ],
                "neutral": [
                    "headline": summary.neutral.headline,
                    "summary": summary.neutral.summary
                ],
                "negative": [
                    "headline": summary.negative.headline,
                    "summary": summary.negative.summary
                ]
            ]
        ]
    }
}

// SectorDetailDetailDate를 딕셔너리로 변환
extension SectorDetailDetailDate {
    func toDictionary() -> [String: [String: Any]] {
        var result: [String: [String: Any]] = [:]
        
        for (channelName, channel) in channels {
            var posts: [[String: Any]] = []
            for post in channel.posts {
                posts.append([
                    "content": post.content,
                    "time": post.time,
                    "views": post.views
                ])
            }
            
            result[channelName] = [
                "posts": posts,
                "score": channel.score
            ]
        }
        
        return result
    }
}

// Channel을 딕셔너리로 변환
extension Channel {
    func toDictionary() -> [String: Any] {
        return [
            "posts": posts.map { $0.toDictionary() },
            "score": score
        ]
    }
}

// Post를 딕셔너리로 변환
extension Post {
    func toDictionary() -> [String: Any] {
        return [
            "content": content,
            "time": time,
            "views": views
        ]
    }
}

// 디버깅을 위한 문자열 변환 extension도 추가할 수 있습니다
extension SectorDetailDate {
    func toSimpleString() -> String {
        let dict = self.toDictionary()
        return "\(dict)"
    }
}

extension SectorDetailDetailDate {
    func toSimpleString() -> String {
        let dict = self.toDictionary()
        return "\(dict)"
    }
}