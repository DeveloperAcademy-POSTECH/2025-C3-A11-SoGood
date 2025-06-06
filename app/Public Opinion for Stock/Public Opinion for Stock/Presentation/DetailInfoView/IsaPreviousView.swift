//
//  IsaPreviousView.swift
//  Public Opinion for Stock
//
//  Created by 우정아 on 6/5/25.
//

import SwiftUI

// TODO: 추후 삭제
struct IsaPreviousView: View {
    @StateObject private var viewModel = SectorViewModel()
//    @State var sectors: [String] = []
    var sectorTitles: [String] {
        Array(viewModel.sectors.keys).sorted()
    }
    
    // sectorName과 SectorData 묶은 배열
    var validSectors: [(name: String, data: SectorData)] {
        sectorTitles.compactMap { name in
            if let data = viewModel.sectors[name] {
                return (name: name, data: data)
            } else {
                return nil
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("투자분야 반응")
                
                List {
                    ForEach(validSectors, id: \.name) { item in
                        let latestDate = item.data.dates.keys.sorted(by: <).last ?? "날짜없음"
                        
                        NavigationLink(
                            destination: SentimentBarChart(
                                sectorName: item.name,
                                sectorData: item.data,
                                allSector: sectorTitles,
                                selectedDate: latestDate
                            )
                        ) {
                            Text(item.name)
                        }
                        
                        
                    }
                }
                
            }
        }
    }
}

#Preview {
    IsaPreviousView()
}
