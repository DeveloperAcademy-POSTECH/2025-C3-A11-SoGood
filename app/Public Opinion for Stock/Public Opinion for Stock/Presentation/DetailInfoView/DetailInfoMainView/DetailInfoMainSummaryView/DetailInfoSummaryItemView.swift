import SwiftUI

struct DetailInfoSummaryItemView: View {
    @Binding var sectorDetail: [String: Any]?
    let sentimentType: String
    @State private var isExpanded: Bool = false
    
    // 감정 타입에 따른 색상
    private var sentimentColor: Color {
        switch sentimentType {
        case "positive":
            return .redPrimary
        case "negative":
            return .bluePrimary
        default:
            return .lableSecondary
        }
    }
    
    // 감정 타입에 따른 제목
    private var sentimentTitle: String {
        switch sentimentType {
        case "positive":
            return "긍정적 반응"
        case "negative":
            return "부정적 반응"
        default:
            return "중립적 반응"
        }
    }
    
    // 헤드라인과 요약 데이터를 위한 계산 프로퍼티
    private var summaryData: (headline: String, summary: String) {
        if let summaryDict = sectorDetail?["summary"] as? [String: [String: Any]],
           let sentimentData = summaryDict[sentimentType] as? [String: String] {
            return (
                headline: sentimentData["headline"] ?? "정보 없음",
                summary: sentimentData["summary"] ?? "해당 유형의 의견을 확인할 수 있는 게시글이 부족합니다."
            )
        }
        return (
            headline: "정보 없음",
            summary: "해당 유형의 의견을 확인할 수 있는 게시글이 부족합니다."
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(sentimentTitle)
                    .font(.headline3)
                    .foregroundStyle(sentimentColor)
                
                Spacer()
                
                Button {
                    isExpanded.toggle()
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.lableSecondary)
                }
            }
            
            // 헤드라인 표시
            Text(summaryData.headline)
                .font(isExpanded ? .body3 : .body2)
                .foregroundStyle(.lablePrimary)
                .lineLimit(nil)
            
            // 확장된 경우 요약 표시
            if isExpanded {
                Text(summaryData.summary)
                    .font(.body1)
                    .foregroundStyle(.lablePrimary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical)
    }
}