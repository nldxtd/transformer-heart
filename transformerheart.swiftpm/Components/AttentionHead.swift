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
    @Binding var highlightRow: Int
    @Binding var highlightCol: Int
    var isActive: Bool = false

    var body: some View {
        // Attention Head
        VStack(spacing: spacing*zoom) {
            ForEach(0..<head, id: \.self) { rowIndex in
                HStack(spacing: spacing*zoom) {
                    ForEach(0..<head, id: \.self) { colIndex in
                        Circle()
                            .fill(headViewModel.headWeight[rowIndex][colIndex]==0 ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color.middlePurple(amount: headViewModel.headWeight[rowIndex][colIndex]))
                            .frame(width: defaultRadius*2*zoom, height: defaultRadius*2*zoom)
                            .scaleEffect(circleScale)
                            .overlay(
                                (rowIndex == highlightRow && colIndex == highlightCol) ?
                                    Circle().stroke(Color.red, lineWidth: 2) :
                                    nil
                            )
                            .onTapGesture {
                                if isActive {
                                    highlightRow = rowIndex
                                    highlightCol = colIndex
                                }
                            }
                    }
                }
            }
        }
    }
}

struct MainPageAttentionHeadView: View {
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
    @Binding var highlightRow: Int
    @Binding var highlightCol: Int
    var isActive: Bool = false
    
    var body: some View {
        // Attention Head
        VStack(spacing: spacing*zoom) {
            ForEach(0..<head, id: \.self) { rowIndex in
                HStack(spacing: spacing*zoom) {
                    ForEach(0..<head, id: \.self) { colIndex in
                        Circle()
                            .fill(headViewModel.headWeight[rowIndex][colIndex]==0 ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color.middlePurple(amount: headViewModel.headWeight[rowIndex][colIndex]))
                            .frame(width: defaultRadius*2*zoom, height: defaultRadius*2*zoom)
                            .scaleEffect(circleScale)
                            .overlay(
                                (rowIndex == highlightRow && colIndex == highlightCol) ?
                                Circle().stroke(Color.red, lineWidth: 2) :
                                    nil
                            )
                    }
                }
            }
        }
    }
}

extension Color {
    static func middlePurple(amount: Double) -> Color {
        let clampedAmount = min(max(amount, 0), 1) // Ensure value is between 0 and 1

        // Define light purple and purple
        let lightPurple = Color(red: 0.8, green: 0.6, blue: 1.0)
        let purple = Color(red: 0.5, green: 0.0, blue: 0.5)

        // Blend the colors based on the amount
        return lightPurple.blend(with: purple, amount: clampedAmount)
    }

    // Helper method to blend two colors
    func blend(with color: Color, amount: Double) -> Color {
        let from = UIColor(self)
        let to = UIColor(color)

        var fromRed: CGFloat = 0, fromGreen: CGFloat = 0, fromBlue: CGFloat = 0, fromAlpha: CGFloat = 0
        var toRed: CGFloat = 0, toGreen: CGFloat = 0, toBlue: CGFloat = 0, toAlpha: CGFloat = 0

        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)

        // Interpolate RGB values
        let red = fromRed + CGFloat(amount) * (toRed - fromRed)
        let green = fromGreen + CGFloat(amount) * (toGreen - fromGreen)
        let blue = fromBlue + CGFloat(amount) * (toBlue - fromBlue)

        return Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
}


