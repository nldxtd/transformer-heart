import SwiftUI

struct TokenList: View {
    var tokens: [String]
    var font: Font = .body
    var defaultWidth: CGFloat = 100
    var defaultHeight: CGFloat = 30
    var cornerRadius: CGFloat = 4
    var spacing: CGFloat = 16
    var backgroundColor: Color = .gray
    var title: String = ""
    var titleFont: Font = .headline
    var titleWidth: CGFloat = 140
    var isHorizontal: Bool = false

    var body: some View {
        
        let layout = isHorizontal ? AnyLayout(HStackLayout(spacing: spacing)) : AnyLayout(VStackLayout(spacing: spacing))

        VStack(alignment: .center) {
            
            if title != "" {
                Text(title)
                    .font(titleFont)
                    .frame(width: isHorizontal ? titleWidth * 2 : titleWidth)
                    .id("title-\(title)")
            }

            layout { // Dynamically switch between HStack and VStack
                ForEach(tokens, id: \.self) { token in
                    Text(token)
                        .font(font)
                        .frame(width: defaultWidth, height: defaultHeight)
                        .background(backgroundColor)
                        .cornerRadius(cornerRadius)
                        .id("token-\(token)") // Ensure consistent ID
                }
            }
        }
    }
}
