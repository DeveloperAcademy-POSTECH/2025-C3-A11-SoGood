import SwiftUI

struct DetailInfoMainTopView: View {
    let currentSectorName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("오늘 대중의 이야기")
                    .font(.title)
                    .foregroundStyle(.lablePrimary)
                
                Button {
                    print("AI 요약 버튼 눌렀어엽")
                } label: {
                    HStack {
                        Text("AI요약")
                            .font(.caption1)
                            .underline()
                            .foregroundStyle(.lableSecondary)
                        Image(systemName: "info.circle")
                            .font(.caption1)
                            .foregroundStyle(.lableSecondary)
                    }
                }
                .padding(.top, 8)
                Spacer()
            }.padding(.bottom, 4)
            
            Text("\(currentSectorName) 종목에 대한 사람들의 반응을 모아봤어요.")
                .multilineTextAlignment(.leading)
                .font(.subheadline1)
                .foregroundStyle(.lablePrimary)
                .padding(.bottom, 37)
        }
    }
}