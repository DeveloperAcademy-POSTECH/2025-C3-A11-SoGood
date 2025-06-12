//
//  ListView.swift
//  Public Opinion for Stock
//
//  Created by Jacob on 6/2/25.
//
import SwiftUI

struct ListView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
    }
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        // 기존 문자열을 Date로 변환
        if let date = dateFormatter.date(from: mainViewModel.yesterday) {
            // 새로운 형식으로 변환
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 기준"
            return dateFormatter.string(from: date)
        }
        return mainViewModel.yesterday  // 변환 실패시 원본 반환
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 24){
            VStack (alignment: .leading, spacing: 8) {
                    Text("투자분야 반응")
                        .font(.title)
                        .foregroundColor(.lablePrimary)
                    VStack (alignment: .leading, spacing: 4){
                        Text("\(mainViewModel.sortedSectors.count)개 종목의 긍정과 부정 의견 점수를 나타내요.")
                        .font(.body1)
                        .foregroundColor(.lablePrimary)
                    
                    Text(formattedDate)
                        .font(.caption2)
                        .foregroundColor(.lableSecondary)
                    }
                }
                
            //리스트 코드 (RowView를 불러와서 나열)
            VStack {
                ForEach(Array(mainViewModel.sortedSectors.enumerated()), id: \.element.sector) { index, item in
                    //Navigation으로 DetailView로 넘겨줄때 정렬된 데이터들, 날짜를 보내줌
                    NavigationLink(destination: DetailInfoView(
                        sectors: mainViewModel.sortedSectors,
                        selectedSector: item.sector,
                        date: mainViewModel.yesterday
                    )
                    ) {
                        RowView(index: index, item: item)
                    }
                }
            }
        }
    }
}



