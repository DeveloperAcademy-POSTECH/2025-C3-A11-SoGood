//
//  TestViewModel.swift
//  Public Opinion for Stock
//
//  Created by 우정아 on 6/2/25.
//

import Foundation

class PublicOpinionsViewModel: ObservableObject {
    @Published var groupedBySectorAndDate: [String: [String: [PublicOpinions]]] = [:]
    //    @Published var groupedOpinions: [String: [PublicOpinions]] = [:]
    @Published var sentimentRatios: [String: Double] = [:]
    
        func loadDummyDataGroupedBySectorAndDate() {
            let data = DummyPublicOpinions.sampleData
            
            var result: [String: [String: [PublicOpinions]]] = [:]
            
            for opinion in data {
                let sector = opinion.sector
                let date = opinion.date
                
                result[sector, default: [:]][date, default: []].append(opinion)
            }
            self.groupedBySectorAndDate = result
        }
    
    
    func calculationSentimentRatios() {
        let allOpinions = DummyPublicOpinions.sampleData
        let totalCount = Double(allOpinions.count)
        
        let grouped = Dictionary(grouping: allOpinions, by: { $0.sentiment } )
        
        var result: [String: Double] = [:]
        for (sentiment, items) in grouped {
            result[sentiment] = (Double(items.count) / totalCount) * 100.0
        }
        
        self.sentimentRatios = result
    }
}
