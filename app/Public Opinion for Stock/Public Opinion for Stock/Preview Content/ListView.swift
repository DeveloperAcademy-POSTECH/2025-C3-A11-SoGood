//
//  ListView.swift
//  Public Opinion for Stock
//
//  Created by Jacob on 6/2/25.
//
import SwiftUI

struct ListView: View {
    
    //샘플 데이터입니당
    let items: [RowItem_test] = [
        RowItem_test(name: "반도체", value: 16),
        RowItem_test(name: "게임", value: 5),
        RowItem_test(name: "건설", value: 14),
        RowItem_test(name: "방산", value: 0),
        RowItem_test(name: "이차전지", value: -16)
    ]
    
    //내림차순 메서드 코드
    var sortedItems: [RowItem_test] {
            items.sorted { $0.value > $1.value }
        }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text("투자분야 반응")
                .font(.title)
                .foregroundColor(.lablePrimary)

            Text("26개 종목의 긍정과 부정 의견 비율을 나타내요.")
                .font(.body1)
                .foregroundColor(.lablePrimary)
            
            Text("2025년 5월 30일  기준") // 날짜 변수 추가하기
                .font(.caption2)
                .foregroundColor(.lableSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
        
        //리스트 코드 (RowView를 불러옴)
        List {
            ForEach(Array(sortedItems.enumerated()), id: \.element.id) { index, item in
                        RowView(index: index, item: item)
                    }
                }
                .listStyle(.plain)
    }
}

#Preview {
    ListView()
}


