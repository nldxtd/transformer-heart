import SwiftUI

struct HorizontalMatrixView: View {
    var row: Int
    var col: Int
    var matrixWeight: [[Double]]
    var color: Color
    var backgroundColor: Color = Color.gray
    var zoom: CGFloat = 1.0
    var defaultWidth: CGFloat = 12
    var defaultHeight: CGFloat = 13
    var spacing: CGFloat = 2
    var cornerRadius: CGFloat = 4
    var title: String = ""
    var titleFont: Font = .headline

    var body: some View {
        // Stack of vectors
        VStack {
            if title != "" {
                Text(title)
                    .padding()
                    .font(titleFont)
            }
            
            VStack(spacing: spacing*zoom) {
                ForEach(0..<row, id: \.self) { rowIndex in
                    HStack(spacing: spacing*zoom) {
                        ForEach(0..<col, id: \.self) { colIndex in
                            Rectangle()
                                .fill(color.opacity(matrixWeight[rowIndex][colIndex]))
                                .frame(width: defaultWidth*zoom, height: defaultHeight*zoom)
                        }
                    }
                }
            }
            .cornerRadius(cornerRadius)
        }
        
    }
}

struct VerticalMatrixView: View {
    var row: Int
    var col: Int
    var matrixWeight: [[Double]]
    var color: Color
    var backgroundColor: Color = Color.gray
    var zoom: CGFloat = 1.0
    var defaultWidth: CGFloat = 10
    var defaultHeight: CGFloat = 30
    var spacing: CGFloat = 2
    var cornerRadius: CGFloat = 4
    var title: String = ""
    var titleFont: Font = .headline

    var body: some View {
        // Stack of vectors
        VStack {
            if title != "" {
                Text(title)
                    .padding()
                    .font(titleFont)
            }

            HStack(spacing: spacing*zoom) {
                ForEach(0..<col, id: \.self) { colIndex in
                    VStack(spacing: spacing*zoom) {
                        ForEach(0..<row, id: \.self) { rowIndex in
                            Rectangle()
                                .fill(color.opacity(matrixWeight[rowIndex][colIndex]))
                                .frame(width: defaultWidth*zoom, height: defaultHeight*zoom)
                        }
                    }
                }
            }
        }
        .frame(width: CGFloat(CGFloat(col)*defaultWidth*zoom), height: CGFloat(CGFloat(row)*defaultHeight*zoom))
        .background(backgroundColor.opacity(0.1))
        .cornerRadius(cornerRadius)
    }
}

class MatrixViewModel: ObservableObject {
    @Published var matrixWeight: [[Double]]

    init(matrixWeight: [[Double]]) {
        self.matrixWeight = matrixWeight
    }
}


struct KQVMatrixView: View {
    var row: Int
    var col: Int
    @ObservedObject var matrixViewModel: MatrixViewModel
    var tokensCount : Int = 7
    var colors: [Color] = [.orange, .green, .purple]
    var backgroundColor: Color = Color.gray
    var largeTitle: String = "QKV Matrix"
    var largeTitleFont: Font = .headline
    var subTitle: [String] = ["Q", "K", "V"]
    var subTitleFont: Font = .subheadline
    var cornerRadius: CGFloat = 6
    var vertivalSpacing: CGFloat = 2
    var horizontalSpacing: CGFloat = 2
    var defaultWidth: CGFloat = 10
    var defaultHeight: CGFloat = 12

    private var matrixWidth: CGFloat {
        CGFloat(col) * defaultWidth + CGFloat(col-1) * horizontalSpacing
    }
    private var colsPerMatrix: Int {
        max(col / 3, 1)
    }

    var body: some View {
        VStack(alignment: .center) {
            Text(largeTitle)
                .font(largeTitleFont)
                .padding()

            HStack {
                ForEach(subTitle.indices, id: \.self) { index in
                    Text(subTitle[index])
                        .font(subTitleFont)
                        .frame(width: matrixWidth / CGFloat(subTitle.count))
                }
            }

            VStack(spacing: vertivalSpacing) {
                ForEach(0..<row, id: \.self) { rowIndex in
                    HStack(spacing: horizontalSpacing) {
                        ForEach(0..<col, id: \.self) { colIndex in
                            Rectangle()
                                .fill(colors[colIndex/colsPerMatrix].opacity(matrixViewModel.matrixWeight[rowIndex][colIndex]))
                                .frame(width: defaultWidth, height: defaultHeight)
                        }
                    }
                }
            }
            .cornerRadius(cornerRadius)
        }
    }
}
