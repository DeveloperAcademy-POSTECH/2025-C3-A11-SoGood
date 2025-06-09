import SwiftUI

struct SentimentTextView: View {
    let records: [SentimentRecord]
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                Text("긍정적")
                    .font(.caption)
                    .foregroundColor(.red)
                Text("\(records.map { $0.positive }.reduce(0, +))개")
                    .font(.title3).bold()
                    .foregroundColor(.red)
            }
            VStack(alignment: .leading) {
                Text("부정적")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("\(records.map { $0.negative }.reduce(0, +))개")
                    .font(.title3).bold()
                    .foregroundColor(.blue)
            }
            VStack(alignment: .leading) {
                Text("중립적")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(records.map { $0.neutral }.reduce(0, +))개")
                    .font(.title3).bold()
                    .foregroundColor(.gray)
            }
        }
    }
}