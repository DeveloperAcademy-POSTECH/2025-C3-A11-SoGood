//
//  TestDummyData.swift
//  Public Opinion for Stock
//
//  Created by 우정아 on 6/2/25.
//

import Foundation


struct PublicOpinions: Identifiable {
    var id = UUID()
    let sector: String
    let date: String
    let sentiment: String
    let headline: String
    let summary: String
}

struct DummyPublicOpinions {
    static let sampleData: [PublicOpinions] = [
        PublicOpinions(sector: "바이오", date: "2025-05-21", sentiment: "부정", headline: "임상 부작용 보고", summary: "임상시험 중 부작용 사례가 보고되어 논란이 일고 있습니다."),
        PublicOpinions(sector: "IT", date: "2025-05-20", sentiment: "긍정", headline: "AI 칩셋 개발 속도", summary: "AI 칩셋 개발 속도가 빨라지고 있어 업계 기대감이 높아지고 있습니다."),
        PublicOpinions(sector: "IT", date: "2025-05-21", sentiment: "부정", headline: "IT 정규직 채용 축소", summary: "대형 IT 기업들이 정규직 채용을 줄이기로 발표했습니다."),
        PublicOpinions(sector: "IT", date: "2025-05-22", sentiment: "중립", headline: "신제품 공개 예정", summary: "다음 주 새로운 스마트폰 제품이 공개될 예정입니다."),
        PublicOpinions(sector: "IT", date: "2025-05-20", sentiment: "중립", headline: "업계 매출 정체", summary: "상반기 IT 업계 매출이 전년 대비 비슷한 수준을 기록했습니다."),
        PublicOpinions(sector: "금융", date: "2025-05-20", sentiment: "부정", headline: "보험사 수익 감소", summary: "보험사 수익이 전년 대비 하락세를 보였습니다."),
        PublicOpinions(sector: "금융", date: "2025-05-21", sentiment: "긍정", headline: "디지털 금융 확산", summary: "비대면 금융 서비스가 빠르게 확산되고 있습니다."),
        PublicOpinions(sector: "금융", date: "2025-05-22", sentiment: "긍정", headline: "핀테크 기업 IPO 기대", summary: "국내 핀테크 기업의 IPO 소식에 시장이 주목하고 있습니다."),
        PublicOpinions(sector: "금융", date: "2025-05-21", sentiment: "중립", headline: "은행 금리 유지", summary: "은행들이 예금 금리를 유지하기로 결정했습니다."),
        PublicOpinions(sector: "바이오", date: "2025-05-20", sentiment: "긍정", headline: "의료 AI 기술 주목", summary: "AI를 이용한 바이오 진단 기술이 주목받고 있습니다."),
        PublicOpinions(sector: "바이오", date: "2025-05-21", sentiment: "부정", headline: "연구 부정행위 논란", summary: "한 대학 연구소에서 실험 결과 조작 의혹이 제기됐습니다."),
        PublicOpinions(sector: "바이오", date: "2025-05-22", sentiment: "중립", headline: "백신 개발 진전", summary: "백신 개발이 안정적으로 진행 중이지만 시장 반응은 제한적입니다."),
        PublicOpinions(sector: "바이오", date: "2025-05-21", sentiment: "긍정", headline: "글로벌 제약사 협력", summary: "국내 제약사가 글로벌 제약사와의 협력을 확대하고 있습니다."),
        PublicOpinions(sector: "IT", date: "2025-05-20", sentiment: "부정", headline: "개발자 유출 사고", summary: "IT 기업 내부 개발 자료가 외부로 유출된 사건이 발생했습니다."),
        PublicOpinions(sector: "IT", date: "2025-05-21", sentiment: "긍정", headline: "자율주행 기술 진전", summary: "자율주행 기술이 한 단계 발전해 시범 도시에 적용될 예정입니다."),
        PublicOpinions(sector: "금융", date: "2025-05-22", sentiment: "부정", headline: "해외 투자 손실", summary: "금융사들이 해외 채권에서 손실을 입은 것으로 나타났습니다."),
        PublicOpinions(sector: "금융", date: "2025-05-20", sentiment: "중립", headline: "가계부채 증가", summary: "가계부채 증가세가 지속되고 있지만 정부 대응은 제한적입니다."),
        PublicOpinions(sector: "바이오", date: "2025-05-22", sentiment: "긍정", headline: "면역치료제 신기술 발표", summary: "신규 면역치료제가 학회에서 소개되어 기대를 모으고 있습니다."),
        PublicOpinions(sector: "바이오", date: "2025-05-21", sentiment: "중립", headline: "유전자 편집 연구 확장", summary: "유전자 편집 기술 연구가 확장되고 있지만 안전성 검증은 더 필요합니다."),
        PublicOpinions(sector: "바이오", date: "2025-05-20", sentiment: "부정", headline: "치료제 임상 중단", summary: "중요한 치료제의 임상이 중단되며 주가에 타격을 주고 있습니다."),
        PublicOpinions(sector: "IT", date: "2025-05-22", sentiment: "긍정", headline: "디지털 전환 수혜", summary: "디지털 전환 수요가 늘며 IT 기업 수익성 개선 기대가 커졌습니다."),
        PublicOpinions(sector: "IT", date: "2025-05-20", sentiment: "중립", headline: "IT 시장 조정 국면", summary: "단기 급등에 따른 조정 가능성이 제기되고 있습니다."),
        PublicOpinions(sector: "금융", date: "2025-05-21", sentiment: "부정", headline: "채권금리 변동성 확대", summary: "시장 금리 변동성이 커지며 투자 불안감이 확산되고 있습니다."),
        PublicOpinions(sector: "금융", date: "2025-05-22", sentiment: "중립", headline: "외환 보유액 발표", summary: "금융 당국이 새로운 외환 보유액 수치를 발표했습니다."),
        PublicOpinions(sector: "바이오", date: "2025-05-21", sentiment: "긍정", headline: "임상 성공 발표", summary: "임상 결과가 성공적으로 도출되어 시장 기대감이 커졌습니다."),
        PublicOpinions(sector: "바이오", date: "2025-05-20", sentiment: "중립", headline: "연구비 지원 확대", summary: "정부가 바이오 분야 연구비를 확대 지원할 방침입니다."),
        PublicOpinions(sector: "IT", date: "2025-05-22", sentiment: "부정", headline: "규제 강화 예고", summary: "정부가 IT 기업들에 대한 규제를 강화할 가능성을 시사했습니다."),
        PublicOpinions(sector: "IT", date: "2025-05-21", sentiment: "긍정", headline: "5G 보급률 상승", summary: "5G 인프라 보급률이 빠르게 증가하고 있습니다."),
        PublicOpinions(sector: "금융", date: "2025-05-20", sentiment: "긍정", headline: "국내 증시 외국인 순매수", summary: "외국인 투자자들이 국내 주식을 대거 순매수했습니다."),
        PublicOpinions(sector: "금융", date: "2025-05-21", sentiment: "중립", headline: "부동산 PF 관련 리스크", summary: "부동산 프로젝트파이낸싱 관련 리스크가 다시 부상하고 있습니다.")
    ]
}
