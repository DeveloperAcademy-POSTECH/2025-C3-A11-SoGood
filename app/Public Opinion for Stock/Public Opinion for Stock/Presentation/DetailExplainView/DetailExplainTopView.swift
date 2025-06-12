import SwiftUI

struct DetailExplainTopView: View {
    @Binding var selectedSentiment: Sentiment
    let selectedSector: String
    let date: String
    @Environment(\.dismiss) private var dismiss

    @Namespace private var underlineNamespace

    var body: some View {
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
            
            Text("\(selectedSector) | \(date) 기준")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
    }
}