import SwiftUI

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
    @Binding var circleScale: CGFloat

    var body: some View {
        // Attention Head
        VStack {
            VStack(spacing: spacing*zoom) {
                ForEach(0..<head, id: \.self) { rowIndex in
                    HStack(spacing: spacing*zoom) {
                        ForEach(0..<head, id: \.self) { colIndex in
                            Circle()
                                .fill(Color(red: 1, green: 1, blue: 1-headViewModel.headWeight[rowIndex][colIndex]/20))
                                .frame(width: defaultRadius*2*zoom, height: defaultRadius*2*zoom)
                                .scaleEffect(circleScale)
                        }
                    }
                }
            }
            if title != "" {
                Text(title)
                    .padding()
                    .font(titleFont)
            }
        }
    }
}
