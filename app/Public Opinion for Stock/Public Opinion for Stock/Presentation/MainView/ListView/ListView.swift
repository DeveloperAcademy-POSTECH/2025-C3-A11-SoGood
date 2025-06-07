//
//  ListView.swift
//  Public Opinion for Stock
//
//  Created by Jacob on 6/2/25.
//
import SwiftUI

struct ListView: View {
    @StateObject var viewModel = ListViewModel()
    
    //파베에서 불러온 데이터 내림차순 메서드 코드
    var sortedItems: [RowItem] {
        viewModel.items.sorted { $0.value > $1.value }
    }
    
    //날짜 포맷 함수
    func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월dd일 기준"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack (alignment: .leading, spacing: 8) {
                    Text("투자분야 반응")
                        .font(.title)
                        .foregroundColor(.lablePrimary)
                    
                    Text("26개 종목의 긍정과 부정 의견 점수를 나타내요.")
                        .font(.body1)
                        .foregroundColor(.lablePrimary)
                    
                    Text(formattedDate(viewModel.yesterday))
                        .font(.caption2)
                        .foregroundColor(.lableSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                
                //리스트 코드 (RowView를 불러와서 나열)
                List {
                    ForEach(Array(sortedItems.enumerated()), id: \.element.id) { index, item in
                        //Navigation으로 DetailView로 넘겨줄때 정렬된 데이터들, 날짜를 보내줌
                        NavigationLink(destination: DetailView(
                            items: sortedItems,
                            name: item.name,
                            date: viewModel.yesterday
                        )
                        ) {
                            RowView(index: index, item: item)
                        }
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    viewModel.fetchSectorScores()
                }
            }
        }
    }
}

#Preview {
    ListView()
}


