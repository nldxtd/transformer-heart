import SwiftUI

class VectorViewModel: ObservableObject {
    @Published var weight: [Double]

    init(weight: [Double]) {
        self.weight = weight
    }
}

struct VectorView: View {
    var dimention: Int
    var vectorWeight: [Double]
    var labels: [Double]
    var color: Color
    var backgroundColor: Color = Color.gray
    var zoom: CGFloat = 1.0
    var defaultWidth: CGFloat = 10
    var defaultHeight: CGFloat = 30
    var spacing: CGFloat = 2
    var cornerRadius: CGFloat = 2
    var title: String = ""
    var titleFont: Font = .headline
    var titleWidth: CGFloat = 140
    var titleHeight: CGFloat = 60
    var matrixMode: Bool = false
    var highlightRow: Bool = false
    var withLabel: Bool = false

    var body: some View {
        VStack {
            if title != "" {
                Text(title)
                    .font(titleFont)
                    .frame(maxWidth: titleWidth, minHeight: titleHeight)
            }

            // Vector view
            HStack(spacing: spacing*zoom) {
                ForEach(0..<dimention, id: \.self) { index in
                    Rectangle()
                        .fill(color.opacity(vectorWeight[index]))
                        .frame(width: defaultWidth*zoom, height: defaultHeight*zoom)
                        .overlay(
                            Text(String(format: "%.2f", labels[index]))
                                .font(.caption)
                                .opacity(withLabel ? 1 : 0)
                        )
                }
            }
            .cornerRadius(matrixMode ? 0 : cornerRadius*zoom)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.blue.opacity(highlightRow ? 0.3 : 0), lineWidth: highlightRow ? 3 : 0)
            )
        }
    }
}

struct VerticalVectorView: View {
    var dimention: Int
    @ObservedObject var vector: VectorViewModel
    var labels: [String]
    var color: Color = .gray
    var zoom: CGFloat = 1.0
    var defaultWidth: CGFloat = 12
    var defaultHeight: CGFloat = 12
    var spacing: CGFloat = 2
    var cornerRadius: CGFloat = 2
    var title: String = ""
    var titleFont: Font = .headline
    var titleWidth: CGFloat = 140
    var titleHeight: CGFloat = 60
    var withLabel: Bool = false

    var body: some View {
        VStack {
            if title != "" {
                Text(title)
                    .font(titleFont)
                    .frame(maxWidth: titleWidth, minHeight: titleHeight)
            }

            // Vector view
            VStack(spacing: spacing*zoom) {
                ForEach(0..<dimention, id: \.self) { index in
                    Rectangle()
                        .fill(color.opacity(abs(vector.weight[index])))
                        .frame(width: defaultWidth*zoom, height: defaultHeight*zoom)
                        .overlay(
                            Text(labels[index])
                                .font(.caption)
                                .opacity(withLabel ? 1 : 0)
                        )
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            )
        }
    }
}

class VectorListViewModel: ObservableObject {
    @Published var vectorListWeight: [[Double]]

    init(matrixWeight: [[Double]]) {
        self.vectorListWeight = matrixWeight
    }
}

struct VectorList: View {
    var dimention: Int
    @ObservedObject var vectors: VectorListViewModel
    var labels: [[Double]]
    var color: Color
    var backgroundColor: Color = Color.gray
    var zoom: CGFloat = 1.0
    var defaultWidth: CGFloat = 10
    var defaultHeight: CGFloat = 30
    var spacing: CGFloat = 16
    var vectorSpacing: CGFloat = 2
    var cornerRadius: CGFloat = 4
    var title: String = ""
    var titleFont: Font = .headline
    var titleWidth: CGFloat = 140
    var titleHeight: CGFloat = 60
    var matrixMode: Bool = false
    var highlightLastRow: Bool = false
    var withLabel: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if title != "" {
                Text(title)
                    .font(titleFont)
            }

            // Vector into a vertical list
            VStack(alignment: .center, spacing: spacing*zoom) {
                ForEach(0..<vectors.vectorListWeight.count, id: \.self) { index in
                    VectorView(
                        dimention: dimention, 
                        vectorWeight: vectors.vectorListWeight[index], 
                        labels: labels[index],
                        color: color,
                        defaultWidth: defaultWidth, 
                        defaultHeight: defaultHeight,
                        spacing: vectorSpacing,
                        matrixMode: matrixMode,
                        highlightRow: index==vectors.vectorListWeight.count-1 ? highlightLastRow : false,
                        withLabel: withLabel
                    )
                }
            }
            .cornerRadius(matrixMode ? cornerRadius*zoom: 0)
        }
    }
}
