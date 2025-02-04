import SwiftUI

struct CircleFillAnimation: View {
    @State private var fillWidth: CGFloat = 0
    @State private var grayScale: Double = 0.5 // 0.0 表示黑色，1.0 表示白色
    
    var body: some View {
        VStack {
            ZStack {
                // 底部圆形
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 200, height: 200)
                
                // 填充部分
                Circle()
                    .fill(Color(white: grayScale, opacity: 1.0)) // 使用不透明的灰度颜色
                    .frame(width: 200, height: 200)
                    .mask(
                        Rectangle()
                            .frame(width: fillWidth, height: 200)
                            .offset(x: -100 + fillWidth/2)
                    )
                    .animation(.easeInOut(duration: 2), value: fillWidth)
            }
            
            // 灰度控制滑块
            VStack {
                Text("灰度值: \(grayScale, specifier: "%.2f")")
                Slider(value: $grayScale, in: 0...1)
                    .frame(width: 200)
            }
            .padding()
            
            // 控制按钮
            HStack(spacing: 20) {
                Button("开始填充") {
                    fillWidth = 200
                }
                
                Button("重置") {
                    fillWidth = 0
                }
            }
        }
    }
}

// 预览
struct CircleFillAnimation_Previews: PreviewProvider {
    static var previews: some View {
        CircleFillAnimation()
    }
}