import SwiftUI

struct TransformerFFNView: View {
    @State private var attentionOutputMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: embeddingMatrixWeight)
    @State private var feedforwardOutputMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: embeddingMatrixWeight)
    @State private var finalOutputMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: embeddingMatrixWeight)
    @State private var attentionOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var feedforwardOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var plusSignPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var inputLayerPositions: [CGPoint] = []
    @State private var hiddenLayerPositions: [CGPoint] = []
    @State private var finalLayerPosistions: [CGPoint] = []
    @State private var ffnHiddenConnectProgress: [CGFloat] = Array(repeating: 1.0, count: 14)
    @State private var ffnFinalConnectProgress: [CGFloat] = Array(repeating: 1.0, count: 10)

    @State private var fillWidth: CGFloat = 0

    @Binding var currentView: String
    var animationNamespace: Namespace.ID

    var body: some View {
        ZStack {
            // Overall is a horizontal view
            HStack(spacing: 30) {
                // Represent of Embedding Matrix
                VectorList(
                    dimention: 10,
                    vectors: attentionOutputMatrix,
                    color: .gray,
                    defaultWidth: 12,
                    defaultHeight: 13,
                    spacing: 2,
                    title: "Attention Output",
                    matrixMode: true
                )
                .matchedGeometryEffect(id: "Attention Output", in: animationNamespace)
                .background {
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                attentionOutputPosition = CGPoint(
                                    x: geo.frame(in: .named("ffnRootView")).midX,
                                    y: geo.frame(in: .named("ffnRootView")).maxY
                                )
                            }
                    }
                }

                // Feed-Forward Network
                VStack {
                    Text("Feed-Forward Network")
                        .font(.headline)
                        .padding()

                    HStack(spacing: 40) {
                        // Input Layer of FFN
                        VStack {
                            ForEach(0..<10) { _ in
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                                    .overlay {
                                        GeometryReader { geo in
                                            ZStack {
                                                Circle().fill(Color.white)

                                                Circle().fill(Color(white: 0.5, opacity: 1.0))
                                                    .mask(
                                                        Rectangle()
                                                            .frame(width: fillWidth, height: 30)
                                                            .offset(x: -15 + fillWidth / 2)
                                                    )
                                                    .animation(
                                                        .easeInOut(duration: 1), value: fillWidth)
                                            }
                                            .onAppear {
                                                DispatchQueue.main.async {
                                                    inputLayerPositions.append(
                                                        CGPoint(
                                                            x: geo.frame(
                                                                in: .named("ffnRootView")
                                                            ).midX,
                                                            y: geo.frame(
                                                                in: .named("ffnRootView")
                                                            ).midY
                                                        ))
                                                }
                                            }
                                        }
                                    }
                            }
                        }

                        // Hidden Layer of FFN
                        VStack {
                            ForEach(0..<7) { _ in
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        GeometryReader { geo in
                                            ZStack {
                                                Circle().fill(Color.white)

                                                Circle().fill(Color(white: 0.5, opacity: 1.0))
                                                    .mask(
                                                        Rectangle()
                                                            .frame(width: fillWidth, height: 30)
                                                            .offset(x: -15 + fillWidth / 2)
                                                    )
                                                    .animation(
                                                        .easeInOut(duration: 1), value: fillWidth)
                                            }
                                            .onAppear {
                                                DispatchQueue.main.async {
                                                    hiddenLayerPositions.append(
                                                        CGPoint(
                                                            x: geo.frame(
                                                                in: .named("ffnRootView")
                                                            ).midX,
                                                            y: geo.frame(
                                                                in: .named("ffnRootView")
                                                            ).midY
                                                        ))
                                                }
                                            }
                                        }
                                    }
                            }
                            Text("⋮")
                            ForEach(0..<7) { _ in
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        GeometryReader { geo in
                                            ZStack {
                                                Circle().fill(Color.white)

                                                Circle().fill(Color(white: 0.5, opacity: 1.0))
                                                    .mask(
                                                        Rectangle()
                                                            .frame(width: fillWidth, height: 30)
                                                            .offset(x: -15 + fillWidth / 2)
                                                    )
                                                    .animation(
                                                        .easeInOut(duration: 1), value: fillWidth)
                                            }
                                            .onAppear {
                                                DispatchQueue.main.async {
                                                    hiddenLayerPositions.append(
                                                        CGPoint(
                                                            x: geo.frame(
                                                                in: .named("ffnRootView")
                                                            ).midX,
                                                            y: geo.frame(
                                                                in: .named("ffnRootView")
                                                            ).midY
                                                        ))
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                        // Output Layer of FFN
                        VStack {
                            ForEach(0..<10) { _ in
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        GeometryReader { geo in
                                            ZStack {
                                                Circle().fill(Color.white)

                                                Circle().fill(Color(white: 0.5, opacity: 1.0))
                                                    .mask(
                                                        Rectangle()
                                                            .frame(width: fillWidth, height: 30)
                                                            .offset(x: -15 + fillWidth / 2)
                                                    )
                                                    .animation(
                                                        .easeInOut(duration: 1), value: fillWidth)
                                            }
                                            .onAppear {
                                                DispatchQueue.main.async {
                                                    finalLayerPosistions.append(
                                                        CGPoint(
                                                            x: geo.frame(
                                                                in: .named("ffnRootView")
                                                            ).midX,
                                                            y: geo.frame(
                                                                in: .named("ffnRootView")
                                                            ).midY
                                                        ))
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding()

                // Represent of FFN Output
                VectorList(
                    dimention: 10,
                    vectors: feedforwardOutputMatrix,
                    color: .gray,
                    defaultWidth: 12,
                    defaultHeight: 13,
                    spacing: 2,
                    title: "Feed-Forward Output",
                    matrixMode: true
                )
                .matchedGeometryEffect(id: "Feed-Forward Output", in: animationNamespace)
                .background {
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                feedforwardOutputPosition = CGPoint(
                                    x: geo.frame(in: .named("ffnRootView")).maxX,
                                    y: geo.frame(in: .named("ffnRootView")).midY
                                )
                            }
                    }
                }

                // Represent of Residential Sign
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 25, height: 25)
                    Image(systemName: "plus")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .background {
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        plusSignPosition = CGPoint(
                                            x: geo.frame(in: .named("ffnRootView")).midX,
                                            y: geo.frame(in: .named("ffnRootView")).midY
                                        )
                                    }
                            }
                        }
                }

                // Transformer output plus residual and Norm
                VectorList(
                    dimention: 10,
                    vectors: finalOutputMatrix,
                    color: .gray,
                    defaultWidth: 12,
                    defaultHeight: 13,
                    spacing: 2,
                    title: "Final Output",
                    matrixMode: true
                )
                .matchedGeometryEffect(id: "Final Output", in: animationNamespace)
            }
        }
        .coordinateSpace(name: "ffnRootView")
        .background {
            if finalLayerPosistions.count == 10 {
                ForEach(0..<inputLayerPositions.count) { inIdx in
                    ForEach(0..<hiddenLayerPositions.count) { hidIdx in
                        Path { path in 
                            path.move(to: inputLayerPositions[inIdx])
                            path.addLine(to: hiddenLayerPositions[hidIdx])
                        }
                        .trim(from: 0, to: ffnHiddenConnectProgress[hidIdx])
                        .stroke(ffnHiddenConnectProgress[hidIdx]==1.0 ? Color.gray : Color.yellow, lineWidth: ffnHiddenConnectProgress[hidIdx]==1.0 ? 1 : 2)
                    }
                }

                ForEach(0..<hiddenLayerPositions.count) { hidIdx in
                    ForEach(0..<finalLayerPosistions.count) { outIdx in
                        Path { path in 
                            path.move(to: hiddenLayerPositions[hidIdx])
                            path.addLine(to: finalLayerPosistions[outIdx])
                        }
                        .trim(from: 0, to: ffnFinalConnectProgress[outIdx])
                        .stroke(ffnFinalConnectProgress[outIdx]==1.0 ? Color.gray : Color.yellow, lineWidth: 1)
                    }
                }
            }
        }
        .onAppear {
            for index in 0..<ffnHiddenConnectProgress.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1 + Double(index)) {
                    ffnHiddenConnectProgress[13-index] = 0
                    withAnimation(.easeInOut(duration: 0.5)) {
                        ffnHiddenConnectProgress[13-index] = 1
                    }
                }
            }
        }
    }
}

// Helper view to represent the "bracelet" connection for residuals
struct BraceletView: View {
    var body: some View {
        Capsule()
            .fill(Color.gray.opacity(0.5))
            .frame(width: 100, height: 10)
    }
}

// Helper view to represent arrows
struct ArrowView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 100, y: 0))
            path.addLine(to: CGPoint(x: 90, y: -10))
            path.move(to: CGPoint(x: 100, y: 0))
            path.addLine(to: CGPoint(x: 90, y: 10))
        }
        .stroke(Color.gray, lineWidth: 2)
    }
}

// Helper view to represent a layer in the FFN
struct FFNLayerView: View {
    let dimensions: Int
    let color: Color

    var body: some View {
        VStack(spacing: 5) {
            ForEach(0..<dimensions, id: \.self) { _ in
                Circle()
                    .fill(color.opacity(0.8))
                    .frame(width: 30, height: 30)
            }
        }
    }
}
