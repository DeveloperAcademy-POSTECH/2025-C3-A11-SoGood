import SwiftUI

struct ButtonExamples: View {
    var body: some View {
        VStack(spacing: 20) {
            // 1. 기본 버튼
            Button("기본 버튼") {
                print("기본 버튼 클릭됨")
            }
            
            // 2. 커스텀 스타일 버튼
            Button(action: {
                print("커스텀 버튼 클릭됨")
            }) {
                Text("커스텀 버튼")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // 3. 아이콘이 있는 버튼
            Button(action: {
                print("아이콘 버튼 클릭됨")
            }) {
                HStack {
                    Image(systemName: "heart.fill")
                    Text("좋아요")
                }
                .foregroundColor(.red)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 2)
                )
            }
            
            // 4. 그라데이션 버튼
            Button(action: {
                print("그라데이션 버튼 클릭됨")
            }) {
                Text("그라데이션 버튼")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
            }
            
            // 5. 시스템 스타일 버튼
            Button("삭제하기", role: .destructive) {
                print("삭제 버튼 클릭됨")
            }
            .buttonStyle(.bordered)
            
            // 6. 큰 버튼
            Button(action: {
                print("큰 버튼 클릭됨")
            }) {
                Text("큰 버튼")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    ButtonExamples()
} 