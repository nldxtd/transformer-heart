import SwiftUI

struct TransformerFFNView: View {
    @State private var attentionOutputMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: embeddingMatrixWeight)
    @State private var feedforwardOutputMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: feedForwardMatrixWeight)
    @State private var finalOutputMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: feedForwardOutputMatrixWeight)
    @State private var attentionOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var feedforwardOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var plusSignPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var inputLayerPositions: [CGPoint] = []
    @State private var hiddenLayerPositions: [CGPoint] = []
    @State private var outputLayerPosistions: [CGPoint] = []
    // Control the progress line between layers
    @State private var hiddenConnectProgress: [CGFloat] = Array(repeating: 1.0, count: 14)
    @State private var outputConnectProgress: [CGFloat] = Array(repeating: 1.0, count: 10)
    // Input mask and grayer
    @State private var inputLayerMask: [CGFloat] = Array(repeating: 0, count: 10)
    @State private var inputLayerGrayer: [CGFloat] = Array(repeating: 0, count: 10)
    // Upper Hidden mask and grayer
    @State private var hiddenLayerUpperMask: [CGFloat] = Array(repeating: 0, count: 7)
    @State private var hiddenLayerUpperGrayer: [CGFloat] = Array(repeating: 0, count: 7)
    // Bottom hidden mask and grayer
    @State private var hiddenLayerBottomMask: [CGFloat] = Array(repeating: 0, count: 7)
    @State private var hiddenLayerBottomGrayer: [CGFloat] = Array(repeating: 0, count: 7)
    // Output mask and grayer
    @State private var outputLayerMask: [CGFloat] = Array(repeating: 0, count: 10)
    @State private var outputLayerGrayer: [CGFloat] = Array(repeating: 0, count: 10)

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
                            ForEach(0..<10) { idx in
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        GeometryReader { geo in
                                            ZStack {
                                                Circle().fill(Color.white)

                                                let grayValue = max(
                                                    0, min(1, 1 - inputLayerGrayer[idx]))
                                                let maskWidth = max(0, inputLayerMask[idx])

                                                Circle().fill(Color(white: grayValue, opacity: 1.0))
                                                    .mask(
                                                        Rectangle()
                                                            .frame(width: maskWidth, height: 30)
                                                            .offset(x: -15 + maskWidth / 2)
                                                    )
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
                            ForEach(0..<7) { idx in
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        GeometryReader { geo in
                                            ZStack {
                                                Circle().fill(Color.white)

                                                let grayValue = max(
                                                    0, min(1, 1 - hiddenLayerUpperGrayer[idx]))
                                                let maskWidth = max(0, hiddenLayerUpperMask[idx])

                                                Circle().fill(Color(white: grayValue, opacity: 1.0))
                                                    .mask(
                                                        Rectangle()
                                                            .frame(width: maskWidth, height: 30)
                                                            .offset(x: -15 + maskWidth / 2)
                                                    )
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
                            ForEach(0..<7) { idx in
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        GeometryReader { geo in
                                            ZStack {
                                                Circle().fill(Color.white)

                                                let grayValue = max(
                                                    0, min(1, 1 - hiddenLayerBottomGrayer[idx]))
                                                let maskWidth = max(0, hiddenLayerBottomMask[idx])

                                                Circle().fill(Color(white: grayValue, opacity: 1.0))
                                                    .mask(
                                                        Rectangle()
                                                            .frame(width: maskWidth, height: 30)
                                                            .offset(x: -15 + maskWidth / 2)
                                                    )
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
                            ForEach(0..<10) { idx in
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        GeometryReader { geo in
                                            ZStack {
                                                Circle().fill(Color.white)

                                                let grayValue = max(
                                                    0, min(1, 1 - outputLayerGrayer[idx]))
                                                let maskWidth = max(0, outputLayerMask[idx])

                                                Circle().fill(Color(white: grayValue, opacity: 1.0))
                                                    .mask(
                                                        Rectangle()
                                                            .frame(width: maskWidth, height: 30)
                                                            .offset(x: -15 + maskWidth / 2)
                                                    )
                                            }
                                            .onAppear {
                                                DispatchQueue.main.async {
                                                    outputLayerPosistions.append(
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
            if outputLayerPosistions.count == 10 {
                ForEach(0..<inputLayerPositions.count) { inIdx in
                    ForEach(0..<hiddenLayerPositions.count) { hidIdx in
                        Path { path in
                            path.move(to: inputLayerPositions[inIdx])
                            path.addLine(to: hiddenLayerPositions[hidIdx])
                        }
                        .trim(from: 0, to: hiddenConnectProgress[hidIdx])
                        .stroke(
                            hiddenConnectProgress[hidIdx] == 1.0 ? Color.gray : Color.yellow,
                            lineWidth: hiddenConnectProgress[hidIdx] == 1.0 ? 1 : 2)
                    }
                }

                ForEach(0..<hiddenLayerPositions.count) { hidIdx in
                    ForEach(0..<outputLayerPosistions.count) { outIdx in
                        Path { path in
                            path.move(to: hiddenLayerPositions[hidIdx])
                            path.addLine(to: outputLayerPosistions[outIdx])
                        }
                        .trim(from: 0, to: finalConnectProgress[outIdx])
                        .stroke(
                            finalConnectProgress[outIdx] == 1.0 ? Color.gray : Color.yellow,
                            lineWidth: finalConnectProgress[outIdx] == 1.0 ? 1 : 2)
                    }
                }
            }
        }
        .onAppear {
            // animation of load input into ffn
            let startTime = DispatchTime.now()
            animateLoadingInputIntoFFN(rowIdx: 0, baseDelay: 1.0, startTime: startTime)
            animateFeedForwardToHiddenLayer(rowIdx: 0, baseDelay: 2.0, startTime: startTime)
            animateFinalConnection(baseDelay: 8.0, startTime: startTime)
            animateFeedForwardToOutputLayer(rowIdx: 0, baseDelay: 9.0, startTime: startTime)
            // animation of the rest lines performing feed-forward
            for rowIdx in 1..<tokens.count {
                animateFeedForwardOnRow(rowIdx: rowIdx, baseDelay: 10.5+3*Double(rowIdx-1), startTime: startTime)
            }
        }
    }

    /// Animate loading input into FFN
    func animateLoadingInputIntoFFN(rowIdx: Int, baseDelay: Double, startTime: DispatchTime) {
        let interval: Double = 0.1
        for idx in 0..<10 {
            DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay + interval * Double(idx)) {
                inputLayerGrayer[idx] = embeddingMatrixWeight[rowIdx][idx]
                withAnimation(.easeInOut(duration: interval)) {
                    attentionOutputMatrix.vectorListWeight[rowIdx][idx] *= 2
                    inputLayerMask[idx] = 30
                }
            }
        }
    }

    /// Animate feedforward from first layer to hidden layer
    func animateFeedForwardToHiddenLayer(rowIdx: Int, baseDelay: Double, startTime: DispatchTime) {
        let interval: Double = 0.4

        for idx in 0..<14 {
            DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay + interval * Double(idx)) {
                hiddenConnectProgress[13 - idx] = 0
                withAnimation(.easeInOut(duration: 0.2)) {
                    hiddenConnectProgress[13 - idx] = 1
                }
            }

            DispatchQueue.main.asyncAfter(
                deadline: startTime + baseDelay + 0.2 + interval * Double(idx)
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if idx < 7 {
                        hiddenLayerUpperGrayer[idx] = hiddenLayerMatrixWeight[rowIdx][idx]
                        hiddenLayerUpperMask[idx] = 30
                    } else {
                        hiddenLayerBottomGrayer[idx - 7] = hiddenLayerMatrixWeight[rowIdx][idx-7]
                        hiddenLayerBottomMask[idx - 7] = 30
                    }
                }
            }
        }
    }

    /// Animate hidden connection lines
    func animateHiddenConnection(rowIdx: Int, baseDelay: Double, startTime: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay) {
            for idx in 0..<14 {
                hiddenConnectProgress[idx] = 0
            }
            withAnimation(.easeInOut(duration: 1)) {
                for idx in 0..<14 {
                    hiddenConnectProgress[idx] = 1
                }
            }
            withAnimation(.easeInOut(duration: 1)) {
                for idx in 0..<7 {
                    hiddenLayerUpperGrayer[idx] = feedforwardOutputMatrix.vectorListWeight[rowIdx][idx]
                    hiddenLayerUpperMask[idx] = 30
                    hiddenLayerBottomGrayer[idx] = feedforwardOutputMatrix.vectorListWeight[rowIdx][idx]
                    hiddenLayerBottomMask[idx] = 30
                }
            }
        }
    }

    /// Animate final connection lines
    func animateFinalConnection(baseDelay: Double, startTime: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay) {
            for idx in 0..<10 {
                finalConnectProgress[idx] = 0
            }
            withAnimation(.easeInOut(duration: 1)) {
                for idx in 0..<10 {
                    finalConnectProgress[idx] = 1
                }
            }
        }
    }

    /// Animate feedforward to output layer
    func animateFeedForwardToOutputLayer(rowIdx: Int, baseDelay: Double, startTime: DispatchTime) {
        let interval: Double = 0.1

        for idx in 0..<10 {
            DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay + interval * Double(idx)) {
                outputLayerGrayer[idx] = feedforwardOutputMatrix.vectorListWeight[rowIdx][idx]
                withAnimation(.easeInOut(duration: interval)) {
                    outputLayerMask[idx] = 30
                    feedforwardOutputMatrix.vectorListWeight[rowIdx][idx] *= 2
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay + 1) {
            withAnimation(.easeInOut(duration: 0.5)) {
                clearFFNGrayerStatus()
            }
        }
    }

    /// Clear grayer Status
    func clearFFNGrayerStatus() {
        inputLayerMask = Array(repeating: 0, count: 10)
        hiddenLayerUpperMask = Array(repeating: 0, count: 7)
        hiddenLayerBottomMask = Array(repeating: 0, count: 7)
        outputLayerMask = Array(repeating: 0, count: 10)
    }

    /// Animate feedforward on row
    func animateFeedForwardOnRow(rowIdx: Int, baseDelay: Double, startTime: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay) {
            for idx in 0..<10 {
                inputLayerGrayer[idx] = embeddingMatrixWeight[rowIdx][idx]
            }
            withAnimation(.easeInOut(duration: 0.5)) {
                for idx in 0..<10 {
                    attentionOutputMatrix.vectorListWeight[rowIdx][idx] *= 2
                    inputLayerMask[idx] = 30
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay + 0.5) {
            for idx in 0..<14 {
                hiddenConnectProgress[idx] = 0
            }
            withAnimation(.easeInOut(duration: 0.5)) {
                for idx in 0..<14 {
                    hiddenConnectProgress[idx] = 1
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay + 1) {
            for idx in 0..<14 {
                inputLayerGrayer[idx] = embeddingMatrixWeight[rowIdx][idx]
            }
            withAnimation(.easeInOut(duration: 0.5)) {
                for idx in 0..<14 {
                    if idx < 7 {
                        hiddenLayerUpperGrayer[idx] = hiddenLayerMatrixWeight[rowIdx][idx]
                        hiddenLayerUpperMask[idx] = 30
                    } else {
                        hiddenLayerBottomGrayer[idx - 7] = hiddenLayerMatrixWeight[rowIdx][idx-7]
                        hiddenLayerBottomMask[idx - 7] = 30
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: startTime + baseDelay + 1.5) {
            for idx in 0..<10 {
                outputConnectProgress[idx] = 0
            }
            withAnimation(.easeInOut(duration: 0.5)) {
                for idx in 0..<10 {
                    outputConnectProgress[idx] = 1
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: startTime + 2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                for idx in 0..<10 {
                    outputLayerGrayer[idx] = feedforwardOutputMatrix.vectorListWeight[rowIdx][idx]
                    outputLayerMask[idx] = 30
                    feedforwardOutputMatrix.vectorListWeight[rowIdx][idx] *= 2
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: startTime + 2.5) {
            withAnimation(.easeInOut(duration: 0.2)) {
                clearFFNGrayerStatus()
            }
        }
    }
}
