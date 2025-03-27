//
//  AttentionHeadPipeline.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/1/12.
//

import SwiftUI

struct SingleAttentionHeadView: View {
    @State private var embeddingMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: embeddingMatrixWeight)
    @State private var qMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: qMatrix)
    @State private var kMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: kMatrix)
    @State private var vMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: vMatrix)
    @State private var dotHeadView: AttentionHeadViewModel = AttentionHeadViewModel(
        headWeight: dotHeadWeight)
    @State private var maskHeadView: AttentionHeadViewModel = AttentionHeadViewModel(
        headWeight: dotHeadWeight)
    @State private var softHeadView: AttentionHeadViewModel = AttentionHeadViewModel(
        headWeight: softHeadWeight)
    @State private var kPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var qPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var vPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var dpHeadPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var smHeadPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var kPositions: [CGPoint] = []
    @State private var qPositions: [CGPoint] = []
    @State private var horizontalHeadPositions: [CGPoint] = []
    @State private var verticalHeadPositions: [CGPoint] = []
    @State private var embeddingMatrixPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var plusSignPosition: CGPoint = CGPoint(x: 0, y: 0)

    @State private var scale: CGFloat = 0
    @State private var maskVisible: Bool = false
    @State private var softmaxVisible: Bool = false
    @State private var dotProductProgress: CGFloat = 0
    @State private var finalMultipleProgress: CGFloat = 0
    @State private var plusSignVisible: Bool = false
    @State private var attentionOutputVisible: Bool = false
    
    // state for attention head
    @State private var highlightRow: Int = -1
    @State private var highlightCol: Int = -1

    @Binding var currentView: String
    var animationNamespace: Namespace.ID
    @Binding var selectedComponent: ModelComponent

    var body: some View {

        let vectorListHeight: CGFloat = CGFloat(15 * tokens.count + 20)
        let vectorListWidth: CGFloat = 48

        // The z-axis view
        ZStack {
            // Over all is a horizontal view
            HStack(spacing: 60) {
                // Represent of KQV vectors
                VStack(spacing: 100) {
                    GeometryReader { geo in
                        // Perform the side-effect (append points) in onAppear
                        VectorList(
                            dimention: 10,
                            vectors: kMatrixView,
                            labels: kMatrix,
                            color: .green,
                            defaultWidth: 3,
                            defaultHeight: 10,
                            spacing: 5,
                            vectorSpacing: 0,
                            title: "key",
                            titleWidth: 43,
                            titleHeight: 20,
                            highlightRowIndex: highlightCol
                        )
                        .matchedGeometryEffect(id: "kMatix", in: animationNamespace)
                        .frame(width: vectorListWidth, height: vectorListHeight)
                        .onAppear {
                            // Append the initial right-top point to the positions array
                            kPosition = CGPoint(
                                x: geo.frame(in: .named("rootView")).maxX + 5,
                                y: geo.frame(in: .named("rootView")).maxY - 5
                            )
                        }
                    }
                    .frame(width: vectorListWidth, height: vectorListHeight)

                    GeometryReader { geo in
                        // Perform the side-effect (append points) in onAppear
                        VectorList(
                            dimention: 10,
                            vectors: qMatrixView,
                            labels: qMatrix,
                            color: .orange,
                            defaultWidth: 3,
                            defaultHeight: 10,
                            spacing: 5,
                            vectorSpacing: 0,
                            title: "query",
                            titleWidth: 48,
                            titleHeight: 20,
                            highlightRowIndex: highlightRow
                        )
                        .matchedGeometryEffect(id: "qMatix", in: animationNamespace)
                        .frame(width: vectorListWidth, height: vectorListHeight)
                        .onAppear {
                            // Append the initial right-top point to the positions array
                            qPosition = CGPoint(
                                x: geo.frame(in: .named("rootView")).maxX + 5,
                                y: geo.frame(in: .named("rootView")).maxY - 5
                            )
                        }
                    }
                    .frame(width: vectorListWidth, height: vectorListHeight)

                    GeometryReader { geo in
                        // Perform the side-effect (append points) in onAppear
                        VectorList(
                            dimention: 10,
                            vectors: vMatrixView,
                            labels: vMatrix,
                            color: .purple,
                            defaultWidth: 3,
                            defaultHeight: 10,
                            spacing: 5,
                            vectorSpacing: 0,
                            title: "value",
                            titleWidth: 43,
                            titleHeight: 20,
                            highlightRowIndex: highlightCol
                        )
                        .matchedGeometryEffect(id: "vMatix", in: animationNamespace)
                        .frame(width: vectorListWidth, height: vectorListHeight)
                        .onAppear {
                            // Append the initial right-top point to the positions array
                            vPosition = CGPoint(
                                x: geo.frame(in: .named("rootView")).maxX + 5,
                                y: geo.frame(in: .named("rootView")).maxY - 5
                            )
                        }
                    }
                    .frame(width: vectorListWidth, height: vectorListHeight)
                }

                // Attention head block
                HStack {

                    // Represent of attention head stack
                    HStack {
                        VStack {
                            // Represent of dot-product calculation
                            AttentionHeadView(
                                head: tokens.count,
                                headViewModel: dotHeadView,
                                title: "Dot Product",
                                circleScale: $scale,
                                highlightRow: $highlightRow,
                                highlightCol: $highlightCol
                            )
                            .overlay(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            dpHeadPosition = CGPoint(
                                                x: geo.frame(in: .named("rootView")).minX + 10,
                                                y: geo.frame(in: .named("rootView")).minY + 10
                                            )
                                        }
                                }
                            )

                            Text("Dot product")
                                .frame(width: 130)
                                .lineLimit(1)
                                .font(.subheadline)
                                .underline()
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            selectedComponent = .attentionScore
                        }

                        // Represent of scaling and mask
                        HStack {
                            // Right arrow
                            Image(systemName: "arrow.right")
                                .offset(y: -12)

                            VStack {
                                // Represent of scaling and mask
                                AttentionHeadView(
                                    head: tokens.count,
                                    headViewModel: maskHeadView,
                                    title: "Masking",
                                    circleScale: $scale,
                                    highlightRow: $highlightRow,
                                    highlightCol: $highlightCol,
                                    isActive: false
                                )

                                Text("Masking")
                                    .frame(width: 130)
                                    .lineLimit(1)
                                    .font(.subheadline)
                                    .underline()
                                    .foregroundColor(.gray)
                            }
                        }
                        .opacity(maskVisible ? 1 : 0)
                        .offset(x: maskVisible ? 0 : -30)
                        .onTapGesture {
                            selectedComponent = .masking
                        }

                        // Represent of Softmax
                        HStack {
                            // Right arrow
                            Image(systemName: "arrow.right")
                                .offset(y: -12)

                            VStack {
                                // Represent of Softmax and dropout
                                AttentionHeadView(
                                    head: tokens.count,
                                    headViewModel: softHeadView,
                                    title: "Softmax",
                                    circleScale: $scale,
                                    highlightRow: $highlightRow,
                                    highlightCol: $highlightCol,
                                    isActive: true
                                )
                                Text("Softmax")
                                    .frame(width: 130)
                                    .lineLimit(1)
                                    .font(.subheadline)
                                    .underline()
                                    .foregroundColor(.gray)
                            }
                            .overlay(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            if softmaxVisible {
                                                smHeadPosition = CGPoint(
                                                    x: geo.frame(in: .named("rootView")).maxX + 10,
                                                    y: geo.frame(in: .named("rootView")).minY + 10
                                                )
                                            } else {
                                                smHeadPosition = CGPoint(
                                                    x: geo.frame(in: .named("rootView")).maxX + 40,
                                                    y: geo.frame(in: .named("rootView")).minY + 10
                                                )
                                            }
                                        }
                                }
                            )
                        }
                        .opacity(softmaxVisible ? 1 : 0)
                        .offset(x: softmaxVisible ? 0 : -30)
                        .onTapGesture {
                            selectedComponent = .softmax
                        }
                    }
                    .padding()
                    .cornerRadius(7)

                    // Represent of final matrix calculation
                    VStack {
                        // Represent of Embedding matrix
                        VectorList(
                            dimention: 10,
                            vectors: embeddingMatrix,
                            labels: embeddingMatrixWeight,
                            color: .gray,
                            defaultWidth: 12,
                            defaultHeight: 13,
                            spacing: 2,
                            title: "Embedding Matrix",
                            matrixMode: true,
                            highlightRowIndex: highlightRow
                        )
                        .offset(x: -65, y: -70)
                        .matchedGeometryEffect(id: "Embedding Matrix", in: animationNamespace)
                        .background {
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        embeddingMatrixPosition = CGPoint(
                                            x: geo.frame(in: .named("rootView")).midX - 65,
                                            y: geo.frame(in: .named("rootView")).maxY - 63
                                        )
                                    }
                            }
                        }

                        // Represent of Softmax and final residual connection
                        HStack(spacing: 20) {
                            Text("")
                                .frame(width: 30)

                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 30, height: 30)
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .offset(y: -30)
                            .opacity(plusSignVisible ? 1 : 0)
                            .background {
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            plusSignPosition = CGPoint(
                                                x: geo.frame(in: .named("rootView")).midX,
                                                y: geo.frame(in: .named("rootView")).minY - 35
                                            )
                                        }
                                }
                            }

                            Image(systemName: "arrow.right")
                                .offset(y: -30)
                                .opacity(attentionOutputVisible ? 1 : 0)

                            VectorList(
                                dimention: 10,
                                vectors: embeddingMatrix,
                                labels: embeddingMatrixWeight,
                                color: .mint,
                                defaultWidth: 12,
                                defaultHeight: 13,
                                spacing: 2,
                                title: "Attention Output",
                                matrixMode: true,
                                highlightRowIndex: highlightRow
                            )
                            .offset(y: -45)
                            .opacity(attentionOutputVisible ? 1 : 0)
                            .matchedGeometryEffect(id: "Attention Output", in: animationNamespace)
                        }
                    }
                    .offset(y: -37.5)
                    .onTapGesture {
                        selectedComponent = .residualConnection
                    }
                }
                .offset(y: 25)
                .background {
                    Text("Matrix Multiplication")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .underline()
                        .offset(x: -300, y: 200)
                        .opacity(finalMultipleProgress)
                        .onTapGesture {
                            selectedComponent = .valueSoftmaxMul
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
                            progress: dotProductProgress
                        )
                        VerticalCurveConnection(
                            start: kPositions[i],
                            end: horizontalHeadPositions[tokens.count - 1 - i],
                            color: .green,
                            progress: dotProductProgress
                        )
                    }
                }
                if smHeadPosition != .zero {
                    let vTopPosition: CGPoint = CGPoint(x: vPosition.x, y: vPosition.y - 75)
                    let smBottomPosition: CGPoint = CGPoint(
                        x: smHeadPosition.x, y: smHeadPosition.y + 110)
                    let valueTopEndPosition: CGPoint = CGPoint(
                        x: smHeadPosition.x + 40, y: smHeadPosition.y + 22)
                    let valueBottomEndPotision: CGPoint = CGPoint(
                        x: smHeadPosition.x + 40, y: smHeadPosition.y + 88)
                    AnimatedCurveShape(
                        corner1: vTopPosition,
                        corner2: valueTopEndPosition,
                        corner3: valueBottomEndPotision,
                        corner4: vPosition,
                        progress: finalMultipleProgress
                    )
                    .fill(Color.purple.opacity(0.3))
                    AnimatedCurveShape(
                        corner1: smHeadPosition,
                        corner2: valueTopEndPosition,
                        corner3: valueBottomEndPotision,
                        corner4: smBottomPosition,
                        progress: finalMultipleProgress
                    )
                    .fill(Color.mint.opacity(0.3))
                }
                VerticleAnimatedCurveShape(
                    corner1: CGPoint(
                        x: embeddingMatrixPosition.x + 20, y: embeddingMatrixPosition.y),
                    corner2: CGPoint(x: plusSignPosition.x + 5, y: plusSignPosition.y),
                    corner3: CGPoint(x: plusSignPosition.x - 5, y: plusSignPosition.y),
                    corner4: CGPoint(
                        x: embeddingMatrixPosition.x - 20, y: embeddingMatrixPosition.y),
                    progress: finalMultipleProgress
                )
                .fill(Color.gray.opacity(0.3))
            }
        }
        .coordinateSpace(name: "rootView")
        .onAppear {
            selectedComponent = .maskedSelfAttention
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                calculatePositions()
                withAnimation(.easeInOut(duration: 1.0)) {
                    dotProductProgress = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    scale = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    maskVisible = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    for i in 0..<tokens.count {
                        for j in i + 1..<tokens.count {
                            maskHeadView.headWeight[i][j] = maskHeadWeight[i][j]
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    softmaxVisible = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                withAnimation(.easeInOut(duration: 1)) {
                    finalMultipleProgress = 1
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                withAnimation(.easeInOut(duration: 1)) {
                    plusSignVisible = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                withAnimation(.easeInOut(duration: 1)) {
                    attentionOutputVisible = true
                }
            }
        }
    }

    private func calculatePositions() {
        for i in 0..<tokens.count {
            kPositions.append(CGPoint(x: kPosition.x, y: kPosition.y - CGFloat(i * 15)))
            qPositions.append(CGPoint(x: qPosition.x, y: qPosition.y - CGFloat(i * 15)))
            horizontalHeadPositions.append(
                CGPoint(x: dpHeadPosition.x + CGFloat(i * 22), y: dpHeadPosition.y))
            verticalHeadPositions.append(
                CGPoint(x: dpHeadPosition.x, y: dpHeadPosition.y + CGFloat(i * 22)))
        }
    }
}
