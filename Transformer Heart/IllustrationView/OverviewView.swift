//
//  OverviewView.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//


import SwiftUI

struct EmbeddingSubView: View {

    @Binding var embeddingOutputPosition: CGPoint
    @State private var embeddingMatrix: VectorListViewModel = VectorListViewModel(matrixWeight: embeddingMatrixWeight)

    var body: some View {
        HStack(spacing: 15) {
            // Input Tokens to embedding process
            VStack(alignment: .trailing, spacing: 20) {
                Text("Tokens")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                VStack(alignment: .trailing, spacing: 8) {
                    ForEach(tokens, id: \.self) { token in
                        Text(token)
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .padding(.horizontal, 8)
                            .frame(height: 16)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.blue.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .frame(width: 120)
            
            // Embedding Output
            VStack(alignment: .leading, spacing: 20) {
                Text("Embeddings")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                VectorList(
                    dimention: 10,
                    vectors: embeddingMatrix,
                    labels: embeddingMatrixWeight,
                    color: .gray,
                    defaultWidth: 6,
                    defaultHeight: 16,
                    spacing: 8,
                    title: "",
                    matrixMode: false
                )
                .background {
                    GeometryReader { geo in
                        Color.clear
                        .onAppear {
                            embeddingOutputPosition = CGPoint(
                                x: geo.frame(in: .named("contentRootView")).maxX+5,
                                y: geo.frame(in: .named("contentRootView")).maxY-8
                            )
                        }
                    }
                }
            }
        }
        .padding(20)
    }
}

struct AttentionKQVSubView: View {

    @Binding var keyInputPosition: CGPoint
    @Binding var queryInputPosition: CGPoint
    @Binding var valueInputPosition: CGPoint
    @Binding var attentionOutputPosition: CGPoint
    @Binding var headConnectionProgress: CGFloat
    @Binding var headOutputConnectionProgress: CGFloat
    @Binding var currentView: String
    @Binding var selectedComponent: ModelComponent

    @State private var headScale: CGFloat = 1.0

    @State private var qMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: qMatrix)
    @State private var kMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: kMatrix)
    @State private var vMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: vMatrix)
    @State private var softmaxHeadView: AttentionHeadViewModel = AttentionHeadViewModel(headWeight: softHeadWeight)

    @State private var kPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var qPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var vPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var attentionHeadPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var kPositions: [CGPoint] = []
    @State private var qPositions: [CGPoint] = []
    @State private var horizontalHeadPositions: [CGPoint] = []
    @State private var verticalHeadPositions: [CGPoint] = []
    @State private var highlightRow: Int = -1
    @State private var highlightCol: Int = -1

    var body: some View {
        // KQV section
        ZStack {
            HStack(alignment: .center) {
                // KQV vectors
                VStack(spacing: 20) {
                    // Key Vector
                    VectorList(
                        dimention: 10,
                        vectors: kMatrixView,
                        labels: kMatrix,
                        color: .green,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "key",
                        matrixMode: false
                    )
                    .background {
                        GeometryReader { geo in
                            Color.clear
                            .onAppear {
                                kPosition = CGPoint(
                                    x: geo.frame(in: .named("attentionBlock")).maxX+5,
                                    y: geo.frame(in: .named("attentionBlock")).maxY-5
                                )
                                keyInputPosition = CGPoint(
                                    x: geo.frame(in: .named("contentRootView")).minX-5,
                                    y: geo.frame(in: .named("contentRootView")).maxY-5
                                )
                            }
                        }
                    }

                    // Query Vector
                    VectorList(
                        dimention: 10,
                        vectors: qMatrixView,
                        labels: qMatrix,
                        color: .orange,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "query",
                        matrixMode: false
                    )
                    .background {
                        GeometryReader { geo in
                            Color.clear
                            .onAppear {
                                qPosition = CGPoint(
                                    x: geo.frame(in: .named("attentionBlock")).maxX+5,
                                    y: geo.frame(in: .named("attentionBlock")).maxY-5
                                )
                                queryInputPosition = CGPoint(
                                    x: geo.frame(in: .named("contentRootView")).minX-5,
                                    y: geo.frame(in: .named("contentRootView")).maxY-5
                                )
                            }
                        }
                    }
                    
                    // Value Vector
                    VectorList(
                        dimention: 10,
                        vectors: vMatrixView,
                        labels: vMatrix,
                        color: .purple,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "value",
                        matrixMode: false
                    )
                    .background {
                        GeometryReader { geo in
                            Color.clear
                            .onAppear {
                                vPosition = CGPoint(
                                    x: geo.frame(in: .named("attentionBlock")).maxX+5,
                                    y: geo.frame(in: .named("attentionBlock")).maxY-5
                                )
                                valueInputPosition = CGPoint(
                                    x: geo.frame(in: .named("contentRootView")).minX-5,
                                    y: geo.frame(in: .named("contentRootView")).maxY-5
                                )
                            }
                        }
                    }
                }
                .onTapGesture {
                    currentView = "KQV Matrix Multiplication"
                }
                .padding()
                
                HStack(spacing: 25) {
                    // Attention head with title
                    VStack(alignment: .center, spacing: 8) {
                        Text("Attention Head")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        AttentionHeadView(
                            head: tokens.count,
                            headViewModel: softmaxHeadView,
                            title: "",
                            circleScale: $headScale,
                            highlightRow: $highlightRow,
                            highlightCol: $highlightCol,
                            isActive: false
                        )
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        attentionHeadPosition = CGPoint(
                                            x: geo.frame(in: .named("attentionBlock")).minX + 10,
                                            y: geo.frame(in: .named("attentionBlock")).minY + 10
                                        )
                                    }
                            }
                        )
                    }
                    .offset(y: -4)
                    .padding()
                    .onTapGesture {
                        currentView = "Single-Head Self Attention"
                    }
                    
                    VStack(alignment: .center, spacing: 8) {
                        Text("Attention Residual Output")
                            .frame(width: 60)
                            .lineLimit(3)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .underline()

                        VectorList(
                            dimention: 10,
                            vectors: kMatrixView,
                            labels: kMatrix,
                            color: .mint,
                            defaultWidth: 3,
                            defaultHeight: 10,
                            spacing: 5,
                            title: "",
                            matrixMode: false
                        )
                        .background {
                            GeometryReader { geo in
                                Color.clear
                                .onAppear {
                                    attentionOutputPosition = CGPoint(
                                        x: geo.frame(in: .named("contentRootView")).maxX+5,
                                        y: geo.frame(in: .named("contentRootView")).maxY-5
                                    )
                                }
                            }
                        }
                        .padding(.trailing, 10)
                    }
                    .offset(y: -20)
                    .onTapGesture {
                        selectedComponent = .outputConcatenation
                    }
                }
                
            }
            .background {
                if verticalHeadPositions.count == tokens.count {
                    ForEach(0..<tokens.count) { i in
                        HorizontalCurveConnection(
                            start: qPositions[i],
                            end: verticalHeadPositions[tokens.count - 1 - i],
                            color: .orange,
                            progress: headConnectionProgress
                        )
                        VerticalCurveConnection(
                            start: kPositions[i],
                            end: horizontalHeadPositions[tokens.count - 1 - i],
                            color: .green,
                            progress: headConnectionProgress
                        )
                    }
                    let vTopPosition: CGPoint = CGPoint(x: vPosition.x, y: vPosition.y - 75)
                    let smHeadPosition: CGPoint = CGPoint(
                        x: attentionHeadPosition.x+125, y: attentionHeadPosition.y)
                    let smBottomPosition: CGPoint = CGPoint(
                        x: smHeadPosition.x, y: smHeadPosition.y + 110)
                    let valueTopEndPosition: CGPoint = CGPoint(
                        x: smHeadPosition.x + 30, y: smHeadPosition.y + 22)
                    let valueBottomEndPotision: CGPoint = CGPoint(
                        x: smHeadPosition.x + 30, y: smHeadPosition.y + 88)
                    AnimatedCurveShape(
                        corner1: vTopPosition,
                        corner2: valueTopEndPosition,
                        corner3: valueBottomEndPotision,
                        corner4: vPosition,
                        progress: headOutputConnectionProgress
                    )
                    .fill(Color.purple.opacity(0.3))
                    AnimatedCurveShape(
                        corner1: smHeadPosition,
                        corner2: valueTopEndPosition,
                        corner3: valueBottomEndPotision,
                        corner4: smBottomPosition,
                        progress: headOutputConnectionProgress
                    )
                    .fill(Color.mint.opacity(0.3))
                }
            }
        }
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("1 of 12 Attention Head")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .underline()
                        .padding()
                        .onTapGesture {
                            selectedComponent = .multiheadSplitting
                        }
                }
            }
        }
        .coordinateSpace(name: "attentionBlock")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                calculatePositions()
            }
        }
    }

    private func calculatePositions() {
        for i in 0..<tokens.count {
            kPositions.append(CGPoint(x: kPosition.x, y: kPosition.y - CGFloat(i * 15)))
            qPositions.append(CGPoint(x: qPosition.x, y: qPosition.y - CGFloat(i * 15)))
            horizontalHeadPositions.append(
                CGPoint(x: attentionHeadPosition.x + CGFloat(i * 22), y: attentionHeadPosition.y))
            verticalHeadPositions.append(
                CGPoint(x: attentionHeadPosition.x, y: attentionHeadPosition.y + CGFloat(i * 22)))
        }
    }
}

struct FFNSubView: View {

    @Binding var hiddenInputPosition: CGPoint
    @Binding var ffnOutputPosition: CGPoint
    @Binding var ffnOutputConnectionProgress: CGFloat

    @State private var outputVectors: VectorListViewModel = VectorListViewModel(matrixWeight: feedForwardMatrixWeight)
    @State private var hiddenVectors: [VectorViewModel] = (0..<6).map { idx in 
        VectorViewModel(weight: hiddenLayerMatrixWeight[idx])
    }
    @State private var hiddenVectorPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var outputVectorPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var hiddenVectorPositions: [CGPoint] = []
    @State private var outputVectorPositions: [CGPoint] = []
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 20) { 
                // Hidden layer (up-dimensioned)
                VStack(spacing: 15) {
                    Text("Hidden layer")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 8) {
                        ForEach(0..<hiddenVectors.count, id: \.self) { i in
                            VerticalVectorView(
                                dimention: 15,
                                vector: hiddenVectors[i],
                                labels: hiddenLayerMatrixWeight[i].map{String($0)},
                                color: .teal,
                                defaultWidth: 10,
                                defaultHeight: 5,
                                spacing: 0
                            )
                        }
                    }
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    hiddenVectorPosition = CGPoint(x: geo.frame(in: .named("ffnBlock")).maxX, y: geo.frame(in: .named("ffnBlock")).maxY)
                                    hiddenInputPosition = CGPoint(
                                        x: geo.frame(in: .named("contentRootView")).minX-5,
                                        y: geo.frame(in: .named("contentRootView")).maxY
                                    )
                                }
                        }
                    }
                }

                VStack(alignment: .center, spacing: 8) {
                    Text("FFN Residual Output")
                        .frame(width: 60)
                        .lineLimit(3)
                        .font(.caption)
                        .foregroundColor(.gray)
                    // Output vectors
                    VectorList(
                        dimention: 10,
                        vectors: outputVectors,
                        labels: feedForwardMatrixWeight,
                        color: .cyan,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "",
                        matrixMode: false
                    )
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    outputVectorPosition = CGPoint(x: geo.frame(in: .named("ffnBlock")).minX, y: geo.frame(in: .named("ffnBlock")).maxY)
                                    ffnOutputPosition = CGPoint(
                                        x: geo.frame(in: .named("contentRootView")).maxX+8,
                                        y: geo.frame(in: .named("contentRootView")).maxY
                                    )
                                }
                        }
                    }
                }
                .offset(y: -20)
            }
            .background {
                if hiddenVectorPositions.count == 2*hiddenVectors.count {
                    ForEach(0..<hiddenVectors.count) { i in
                        AnimatedCurveShape(
                            corner1: hiddenVectorPositions[2*i],
                            corner2: outputVectorPositions[2*i],
                            corner3: outputVectorPositions[2*i+1],
                            corner4: hiddenVectorPositions[2*i+1],
                            progress: ffnOutputConnectionProgress
                        )
                        .fill(Color.cyan.opacity(0.3))
                    }
                }
            }
            .padding(.trailing, 40)
        }
        .coordinateSpace(name: "ffnBlock")
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Feed-Forward Network")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                calculatePositions()
            }
        }
    }
    
    private func calculatePositions() {
        for i in 0..<hiddenVectors.count {
            hiddenVectorPositions.append(CGPoint(x: hiddenVectorPosition.x+2, y: hiddenVectorPosition.y - CGFloat(i * 83)))
            hiddenVectorPositions.append(CGPoint(x: hiddenVectorPosition.x+2, y: hiddenVectorPosition.y - 75 - CGFloat(i * 83)))
            outputVectorPositions.append(CGPoint(x: outputVectorPosition.x-2, y: outputVectorPosition.y - CGFloat(i * 15)))
            outputVectorPositions.append(CGPoint(x: outputVectorPosition.x-2, y: outputVectorPosition.y - 10 - CGFloat(i * 15)))
        }
    }
}

struct PredictionSubView: View {
    // Calculate softmax probabilities from logits
    static let probabilities: [Double] = {
        let logits = [-0.5, -0.8, -1.0, -1.2, -1.5, -2.0, -2.5, -15]
        let expValues = logits.map { exp($0) }
        let sum = expValues.reduce(0, +)
        return expValues.map { $0 / sum }
    }()
    
    static let tokenLabels = ["visualize", "understand", "see", "explore", "create", "easily", "build", "⋮"]

    // Create a 25-dimension vector with probabilities distributed randomly
    static let mockLogitVector: [Double] = {
        var probVector = Array(repeating: 0.0, count: 25)
        for (idx, prob) in zip(indices, probabilities) {
            probVector[idx] = prob
        }
        return probVector
    }()

    static let mockLabelVector: [String] = {
        var labelVector = Array(repeating: "", count: 25)
        for (idx, label) in zip(indices, tokenLabels) {
            labelVector[idx] = label
        }
        return labelVector
    }()

    @State private var outputVectors: VectorListViewModel = VectorListViewModel(matrixWeight: feedForwardMatrixWeight)
    @State private var logitVector: VectorViewModel = VectorViewModel(weight: mockLogitVector.map { $0+0.1 })
    @State private var labelVector: [String] = mockLabelVector
    @State private var showProbabilities = false
    @State private var lastOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var logisPosition: CGPoint = CGPoint(x: 0, y: 0)

    @Binding var indexSelected: Int
    @Binding var logitsInputPosition: CGPoint
    @Binding var outputLogitsConnectionProgress: CGFloat
    
    var body: some View {
        HStack(spacing: 30) {

            VStack(alignment: .leading, spacing: 8) {
                Text("Final Transformer Output")
                        .frame(width: 70)
                        .lineLimit(3)
                        .font(.caption)
                        .foregroundColor(.gray)

                // Output vectors
                VectorList(
                    dimention: 10,
                    vectors: outputVectors,
                    labels: feedForwardMatrixWeight,
                    color: .blue,
                    defaultWidth: 3,
                    defaultHeight: 10,
                    spacing: 5,
                    title: "",
                    matrixMode: false
                )
                .background {
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                lastOutputPosition = CGPoint(x: geo.frame(in: .named("outputBlock")).maxX+5, y: geo.frame(in: .named("outputBlock")).maxY)
                                logitsInputPosition = CGPoint(
                                    x: geo.frame(in: .named("contentRootView")).minX-8,
                                    y: geo.frame(in: .named("contentRootView")).maxY
                                )
                            }
                    }
                }
            }
            .offset(y: -20)

            // Logit vector
            VStack(spacing: 15) {
                Text("logits")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                VerticalVectorView(
                    dimention: 25,
                    vector: logitVector,
                    labels: labelVector,
                    color: .blue,
                    defaultWidth: 70,
                    defaultHeight: 25,
                    spacing: 1,
                    withLabel: true
                )
                .background {
                    GeometryReader { geo in
                        Color.clear
                        .onAppear {
                            logisPosition = CGPoint(
                                x: geo.frame(in: .named("outputBlock")).minX-5,
                                y: geo.frame(in: .named("outputBlock")).maxY
                            )
                        }
                    }
                }
            }

            // Token probabilities
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .trailing) {
                    Text("Tokens")
                        .font(.subheadline)
                    VStack(alignment: .trailing, spacing: 8) {
                        ForEach(Self.tokenLabels.indices, id: \.self) { index in
                            Text(Self.tokenLabels[index])
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .padding(.horizontal, 8)
                                .frame(height: 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(index == indexSelected ? Color.purple.opacity(0.1) : Color.gray.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(index == indexSelected ? Color.purple.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text("Probability")
                        .font(.subheadline)
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Self.probabilities.indices, id: \.self) { index in
                            HStack(spacing: 4) {
                                Rectangle()
                                    .frame(width: CGFloat(Self.probabilities[index] * 150), height: 6)
                                    .foregroundColor(.blue)
                                Text(String(format: "%.2f%%", Self.probabilities[index]))
                                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                                    .padding(.horizontal, 4)
                                    .frame(height: 15)
                            }
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(index == indexSelected ? Color.purple.opacity(0.1) : Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(index == indexSelected ? Color.purple.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
            }
        }
        .coordinateSpace(name: "outputBlock")
        .background {
            AnimatedCurveShape(
                corner1: CGPoint(x: lastOutputPosition.x, y: lastOutputPosition.y-10),
                corner2: CGPoint(x: logisPosition.x, y: logisPosition.y-649),
                corner3: CGPoint(x: logisPosition.x, y: logisPosition.y),
                corner4: CGPoint(x: lastOutputPosition.x, y: lastOutputPosition.y),
                progress: outputLogitsConnectionProgress
            )
            .fill(Color.blue.opacity(0.3))
        }
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Last Token Prediction")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                showProbabilities = true
            }
        }
    }
}

struct StackedBackground: View {

    var body: some View {
        ZStack {
            // Bottom layer (5th)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .offset(x: 20, y: 20)
            
            // 4th layer
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .offset(x: 15, y: 15)
            
            // 3rd layer
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                )
                .offset(x: 10, y: 10)
            
            // 2nd layer
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                )
                .offset(x: 5, y: 5)
            
            // Top layer (main)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .shadow(radius: 5)
        }
    }
}

struct OverviewView: View {
    @Binding var currentView: String
    var animationNamespace: Namespace.ID
    
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    @Binding var lastOffset: CGSize
    @State private var lastScale: CGFloat = 1.0
    @Binding var indexSelected: Int
    @Binding var selectedComponent: ModelComponent

    // Position of the Embedding Layer
    @State var embeddingOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State var embeddingOutputPositions: [CGPoint] = []
    // Position of the Attention Head
    @State var keyInputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State var keyInputPositions: [CGPoint] = []
    @State var queryInputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State var queryInputPositions: [CGPoint] = []
    @State var valueInputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State var valueInputPositions: [CGPoint] = []
    @State var attentionOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State var attentionOutputPositions: [CGPoint] = []
    // Position of the FFN Layer
    @State var hiddenInputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State var hiddenInputPositions: [CGPoint] = []
    @State var ffnOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    // Position of the Prediction Layer
    @State var logitsInputPosition: CGPoint = CGPoint(x: 0, y: 0)

    @State var kqvConnectionProgress: CGFloat = 0.0
    @State var headConnectionProgress: CGFloat = 0.0
    @State var headOutputConnectionProgress: CGFloat = 0.0
    @State var hiddenConnectionProgress: CGFloat = 0.0
    @State var ffnOutputConnectionProgress: CGFloat = 0.0
    @State var logitsConnectionProgress: Double = 0.0
    @State var outputLogitsConnectionProgress: CGFloat = 0.0

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            content
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                scale = min(max(scale * delta, 0.5), 2.0)
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                            },
                        DragGesture()
                            .onChanged { value in
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var content: some View {
        VStack(alignment: .center, spacing: 20) {
            // Existing pipeline views
            HStack(alignment: .center, spacing: 20) {
                // Embedding section
                
                EmbeddingSubView(embeddingOutputPosition: $embeddingOutputPosition)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    }
                    .offset(y: -80)
                    .onTapGesture {
                        currentView = "Embedding Layer"
                    }


                HStack {
                    AttentionKQVSubView(keyInputPosition: $keyInputPosition, queryInputPosition: $queryInputPosition, valueInputPosition: $valueInputPosition, attentionOutputPosition: $attentionOutputPosition, headConnectionProgress: $headConnectionProgress, headOutputConnectionProgress: $headOutputConnectionProgress, currentView: $currentView, selectedComponent: $selectedComponent)
                        .background(StackedBackground())
                        .padding(20)

                    FFNSubView(hiddenInputPosition: $hiddenInputPosition, ffnOutputPosition: $ffnOutputPosition, ffnOutputConnectionProgress: $ffnOutputConnectionProgress)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(radius: 5)
                        }
                        .padding(20)
                        .onTapGesture {
                            currentView = "Feed-Forward Network Pipeline"
                            selectedComponent = .ffn
                        }
                }
                .background{
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        
                        VStack {
                            HStack {
                                Text("Transformer Block")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.trailing, 50)

                PredictionSubView(indexSelected: $indexSelected, logitsInputPosition: $logitsInputPosition, outputLogitsConnectionProgress: $outputLogitsConnectionProgress)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    }
                    .onTapGesture {
                        currentView = "Next Token Prediction"
                    }
            }
            .overlay {
                if hiddenInputPositions.count == 2*tokens.count {
                    ForEach(0..<tokens.count) { i in
                        AnimatedCurveShape(
                            corner1: embeddingOutputPositions[2*i],
                            corner2: keyInputPositions[2*i],
                            corner3: keyInputPositions[2*i+1],
                            corner4: embeddingOutputPositions[2*i+1],
                            progress: kqvConnectionProgress
                        )
                        .fill(Color.green.opacity(0.3))
                        AnimatedCurveShape(
                            corner1: embeddingOutputPositions[2*i],
                            corner2: queryInputPositions[2*i],
                            corner3: queryInputPositions[2*i+1],
                            corner4: embeddingOutputPositions[2*i+1],
                            progress: kqvConnectionProgress
                        )
                        .fill(Color.orange.opacity(0.3))
                        AnimatedCurveShape(
                            corner1: embeddingOutputPositions[2*i],
                            corner2: valueInputPositions[2*i],
                            corner3: valueInputPositions[2*i+1],
                            corner4: embeddingOutputPositions[2*i+1],
                            progress: kqvConnectionProgress
                        )
                        .fill(Color.purple.opacity(0.3))
                        AnimatedCurveShape(
                            corner1: attentionOutputPositions[2*i],
                            corner2: hiddenInputPositions[2*i],
                            corner3: hiddenInputPositions[2*i+1],
                            corner4: attentionOutputPositions[2*i+1],
                            progress: hiddenConnectionProgress
                        )
                        .fill(Color.teal.opacity(0.3))
                    }
                }
                if logitsInputPosition != CGPoint(x: 0, y: 0) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.cyan.opacity(0.3), Color.blue.opacity(0.3)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: abs(logitsInputPosition.x - ffnOutputPosition.x) * logitsConnectionProgress, height: 85)
                        .position(x: ffnOutputPosition.x + abs(logitsInputPosition.x - ffnOutputPosition.x) * logitsConnectionProgress / 2, y: ffnOutputPosition.y - 85 / 2)
                        .opacity(logitsConnectionProgress)

                    Text("11 more Transformer Blocks here")
                        .font(.caption)
                        .frame(width: abs(logitsInputPosition.x - ffnOutputPosition.x))
                        .position(x: ffnOutputPosition.x + abs(logitsInputPosition.x - ffnOutputPosition.x) * logitsConnectionProgress / 2, y: ffnOutputPosition.y - 85 / 2)
                        .opacity(logitsConnectionProgress)
                }
            }
        }
        
        .onAppear {
            selectedComponent = .transformer
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                calculatePositions()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                playAnimation()
            }
        }
        .coordinateSpace(name: "contentRootView")
        .padding(.horizontal, 10)
        .padding(.top, 20)
    }

    private func calculatePositions() {
        for i in 0..<tokens.count {
            embeddingOutputPositions.append(CGPoint(x: embeddingOutputPosition.x, y: embeddingOutputPosition.y+8-CGFloat(i*24)))
            embeddingOutputPositions.append(CGPoint(x: embeddingOutputPosition.x, y: embeddingOutputPosition.y-8-CGFloat(i*24)))
            keyInputPositions.append(CGPoint(x: keyInputPosition.x, y: keyInputPosition.y+5-CGFloat(i*15)))
            keyInputPositions.append(CGPoint(x: keyInputPosition.x, y: keyInputPosition.y-5-CGFloat(i*15)))
            queryInputPositions.append(CGPoint(x: queryInputPosition.x, y: queryInputPosition.y+5-CGFloat(i*15)))
            queryInputPositions.append(CGPoint(x: queryInputPosition.x, y: queryInputPosition.y-5-CGFloat(i*15)))
            valueInputPositions.append(CGPoint(x: valueInputPosition.x, y: valueInputPosition.y+5-CGFloat(i*15)))
            valueInputPositions.append(CGPoint(x: valueInputPosition.x, y: valueInputPosition.y-5-CGFloat(i*15)))
            attentionOutputPositions.append(CGPoint(x: attentionOutputPosition.x, y: attentionOutputPosition.y+5-CGFloat(i*15)))
            attentionOutputPositions.append(CGPoint(x: attentionOutputPosition.x, y: attentionOutputPosition.y-5-CGFloat(i*15)))
            hiddenInputPositions.append(CGPoint(x: hiddenInputPosition.x, y: hiddenInputPosition.y-CGFloat(i*83)))
            hiddenInputPositions.append(CGPoint(x: hiddenInputPosition.x, y: hiddenInputPosition.y-75-CGFloat(i*83)))
        }
    }

    private func playAnimation() {
        kqvConnectionProgress = 0
        headConnectionProgress = 0
        headOutputConnectionProgress = 0
        hiddenConnectionProgress = 0
        ffnOutputConnectionProgress = 0
        logitsConnectionProgress = 0
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            withAnimation(.easeInOut(duration: 0.5)) {
                kqvConnectionProgress = 1.0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                headConnectionProgress = 1.0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                headOutputConnectionProgress = 1.0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                hiddenConnectionProgress = 1.0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                ffnOutputConnectionProgress = 1.0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                logitsConnectionProgress = 1.0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+4.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                outputLogitsConnectionProgress = 1.0
            }
        }
    }
}
