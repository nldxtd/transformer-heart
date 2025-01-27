import SwiftUI

class CoordinatesManager: ObservableObject {
    @Published var kPositions: [CGPoint] = []
    @Published var qPositions: [CGPoint] = []
    @Published var horizontalHeadPositions: [CGPoint] = []
    @Published var verticalHeadPositions: [CGPoint] = []
    
    func calculatePositions(tokensCount: Int) {
        for i in 0..<tokensCount {
            kPositions.append(CGPoint(x: 50, y: 50 - CGFloat(i * 15)))
            qPositions.append(CGPoint(x: 150, y: 50 - CGFloat(i * 15)))
            horizontalHeadPositions.append(CGPoint(x: 100 + CGFloat(i * 22), y: 100))
            verticalHeadPositions.append(CGPoint(x: 100, y: 100 + CGFloat(i * 22)))
        }
    }
}

class AttentionHeadViewModel: ObservableObject {
    @Published var headWeight: [[Double]]

    init(headWeight: [[Double]]) {
        self.headWeight = headWeight
    }
}

struct AttentionHeadView: View {
    var head: Int
    @ObservedObject var headViewModel: AttentionHeadViewModel
    var color: Color = Color.pink
    var backgroundColor: Color = Color.gray
    var zoom: CGFloat = 1.0
    var defaultRadius: CGFloat = 10
    var spacing: CGFloat = 2
    var title: String = ""
    var titleFont: Font = .subheadline

    var body: some View {
        // Attention Head
        VStack {

            VStack(spacing: spacing*zoom) {
                ForEach(0..<head, id: \.self) { rowIndex in
                    HStack(spacing: spacing*zoom) {
                        ForEach(0..<head, id: \.self) { colIndex in
                            Circle()
                                .fill(color.opacity(headViewModel.headWeight[rowIndex][colIndex]))
                                .frame(width: defaultRadius*2*zoom, height: defaultRadius*2*zoom)
                        }
                    }
                }
            }
            if title != "" {
                Text(title)
                    .frame(width: 130)
                    .font(titleFont)
                    .lineLimit(1)
            }
        }
    }
}
