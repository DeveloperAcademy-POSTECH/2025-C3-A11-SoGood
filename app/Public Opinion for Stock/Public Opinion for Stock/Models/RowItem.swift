//
//  RowItem_test.swift
//  Public Opinion for Stock
//
//  Created by Jacob on 6/3/25.
//

import Foundation

struct RowItem: Identifiable {
    let id = UUID()
    let name: String
    let value: Int
    let iconName: String //한글을 -> 영어로 바꿔야할것
    
    var koreanToEnglish: String {
        switch iconName {
        case "전지":
            return "Electricity"
        case "배터리":
            return "Battery"
        case "건설":
            return "Construction"
        case "게임":
            return "Game"
        case "디스플레이":
            return "Display"
        case "바이오":
            return "Biotech"
        case "반도체":
            return "Semiconductor"
        case "방산":
            return "DefenceIndustry"
        case "보험":
            return "Insurance"
        case "수소":
            return "Hydrogen"
        case "엔터":
            return "Entertainment"
        case "여행":
            return "Travel"
        case "원전":
            return "NuclarEnergy"
        case "유통":
            return "Distribution"
        case "은행":
            return "Bank"
        case "음식료":
            return "Food"
        case "이차전지":
            return "SecondaryElectricity"
        case "임플란트":
            return "Implant"
        case "자동차":
            return "Car"
        case "전선":
            return "Wire"
        case "조선":
            return "Vessle"
        case "철강":
            return "Iron"
        case "패션":
            return "Fashion"
        case "풍력":
            return "WindEnergy"
        case "피부미용":
            return "SkinCare"
        case "화장품":
            return "Cosmatic"
        case "화학":
            return "Chemistry"
        case "IT":
            return "IT"
        default:
            return "iconName"
        }
    }
}
