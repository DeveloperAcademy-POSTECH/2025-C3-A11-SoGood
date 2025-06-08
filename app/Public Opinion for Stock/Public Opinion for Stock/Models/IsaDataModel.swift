import Foundation


// MARK: - 최상위 레벨 구조 (전체 데이터)
typealias SectorCollection = [String: SectorData]

// MARK: - 섹터별 데이터
struct SectorData: Codable, Identifiable {
    let id: String
    let dates: [String: DateInfo]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dates = try container.decode([String: DateInfo].self, forKey: .dates)
        
        if let sectorName = decoder.userInfo[.sectorName] as? String {
            self.id = sectorName
        } else {
            self.id = UUID().uuidString
        }
    }
    
    init(id: String, dates: [String: DateInfo]) {
        self.id = id
        self.dates = dates
    }
    
    enum CodingKeys: String, CodingKey {
        case dates
    }
}

// MARK: - 날짜별 정보
struct DateInfo: Codable, Identifiable {
    let id: String
    let counts: Counts
    let summary: Summary
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.counts = try container.decode(Counts.self, forKey: .counts)
        self.summary = try container.decode(Summary.self, forKey: .summary)
        
        if let date = decoder.userInfo[.date] as? String {
            self.id = date
        } else {
            self.id = UUID().uuidString
        }
    }
    init(id: String, counts: Counts, summary: Summary) {
        self.id = id
        self.counts = counts
        self.summary = summary
    }
    
    enum CodingKeys: String, CodingKey {
        case counts, summary
    }
}

// MARK: - CodingUserInfoKey 확장
extension CodingUserInfoKey {
    static let sectorName = CodingUserInfoKey(rawValue: "sectorName")!
    static let date = CodingUserInfoKey(rawValue: "date")!
}
