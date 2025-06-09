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
    
    
    var body: some View {
        VStack {
            VStack (alignment: .leading, spacing: 8) {
                Text("투자분야 반응")
                    .font(.title)
                    .foregroundColor(.lablePrimary)
                
                Text("\(mainViewModel.sortedSectors.count)개 종목의 긍정과 부정 의견 점수를 나타내요.")
                    .font(.body1)
                    .foregroundColor(.lablePrimary)
                
                Text(mainViewModel.yesterday)
                    .font(.caption2)
                    .foregroundColor(.lableSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //리스트 코드 (RowView를 불러와서 나열)
            LazyVStack {
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
            .listStyle(.plain)
        }
    }
}



