//
//  AttentionQKVPipeline.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/1/11.
//

import Foundation
import SwiftUI

struct AttentionQKVView: View {
    @State private var embeddingMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: embeddingMatrixWeight)
    @State private var QKVMatrix = MatrixViewModel(matrixWeight: QKVMatrixWeight)
    @State private var qMatrixView: VectorListViewModel = VectorListViewModel(
        matrixWeight: Array(repeating: Array(repeating: 0, count: 10), count: 6))
    @State private var kMatrixView: VectorListViewModel = VectorListViewModel(
        matrixWeight: Array(repeating: Array(repeating: 0, count: 10), count: 6))
    @State private var vMatrixView: VectorListViewModel = VectorListViewModel(
        matrixWeight: Array(repeating: Array(repeating: 0, count: 10), count: 6))
    @State private var biasVector: VectorViewModel = VectorViewModel(weight: biasVectorWeight)
    let isMatrixMode = true

    @State private var QKVMatrixVisible = false
    @State private var biasVectorVisible = false
    @State private var qkvVectorVisible = false

    @Binding var currentView: String
    var animationNamespace: Namespace.ID
    @Binding var selectedComponent: ModelComponent

    let vectorListHeight: CGFloat = CGFloat(15 * tokens.count + 20)
    let vectorListWidth: CGFloat = 48
    
    var body: some View {
        ZStack {
            HStack {
                // Embedding Matrix
                VectorList(
                    dimention: 10,
                    vectors: embeddingMatrix,
                    labels: embeddingMatrixWeight,
                    color: .gray,
                    defaultWidth: 12,
                    defaultHeight: 13,
                    spacing: 2,
                    title: "Embedding Matrix",
                    matrixMode: isMatrixMode
                )
                .offset(y: -20)
                .matchedGeometryEffect(id: "EmbeddingMatrix", in: animationNamespace)

                Text("\u{00D7}")  // Multiple sign column header
                    .font(.headline)
                    .frame(width: 30, alignment: .center)
                    .opacity(QKVMatrixVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: QKVMatrixVisible)

                KQVMatrixView(
                    row: 10,
                    col: 30,
                    matrixViewModel: QKVMatrix
                )
                .offset(x: QKVMatrixVisible ? 0 : -20, y: -45)
                .opacity(QKVMatrixVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: QKVMatrixVisible)

                HStack {
                    Text("+")  // Plus sign
                        .font(.headline)
                        .frame(width: 30, alignment: .center)

                    // Bias vector
                    VerticalVectorView(dimention: 30, vector: biasVector, labels: biasVectorWeight.map{String($0)}, title: "Bias")
                        .offset(y: -13)

                    Text("=")  // Plus sign
                        .font(.headline)
                        .frame(width: 30, alignment: .center)
                }
                .offset(x: biasVectorVisible ? 0 : -20)
                .opacity(biasVectorVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: biasVectorVisible)

                // Output vectors for each token
                HStack(alignment: .center, spacing: 10) {
                    VectorList(
                        dimention: 10,
                        vectors: qMatrixView,
                        labels: qMatrix,
                        color: .orange,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "query",
                        titleWidth: 43
                    )
                    .frame(width: vectorListWidth, height: vectorListHeight)
                    .matchedGeometryEffect(id: "qMatrix", in: animationNamespace)
                    VectorList(
                        dimention: 10,
                        vectors: kMatrixView,
                        labels: kMatrix,
                        color: .green,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "key",
                        titleWidth: 43
                    )
                    .frame(width: vectorListWidth, height: vectorListHeight)
                    .matchedGeometryEffect(id: "kMatix", in: animationNamespace)
                    VectorList(
                        dimention: 10,
                        vectors: vMatrixView,
                        labels: vMatrix,
                        color: .purple,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "value",
                        titleWidth: 43
                    )
                    .frame(width: vectorListWidth, height: vectorListHeight)
                    .matchedGeometryEffect(id: "vMatrix", in: animationNamespace)
                }
                .padding(.leading, 20)
                .offset(x: qkvVectorVisible ? 0 : -20, y: -10)
                .opacity(qkvVectorVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: qkvVectorVisible)
            }
        }
        .onAppear {
            selectedComponent = .kqvMatrices
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                QKVMatrixVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                biasVectorVisible = true
                qkvVectorVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                performMatrixMultiplication()
            }
        }
    }

    @MainActor
    private func performMatrixMultiplication(duration: Double = 0.05) {
        let row = QKVMatrix.matrixWeight.count
        let col = QKVMatrix.matrixWeight[0].count
        
        @MainActor
        func executeFirstPhase() async {
            biasVector.weight[0] *= 2
            qMatrixView.vectorListWeight[0][0] = qMatrix[0][0]
            
            for rowIndex in 0..<row {
                embeddingMatrix.vectorListWeight[0][rowIndex] *= 2
                QKVMatrix.matrixWeight[rowIndex][0] *= 2
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            }
            
            embeddingMatrix.vectorListWeight[0] = embeddingMatrix.vectorListWeight[0].map { $0 / 2 }
        }
        
        @MainActor
        func executeSecondPhase() async {
            for colIndex in 1..<col {
                biasVector.weight[colIndex] *= 2
                
                if colIndex < 10 {
                    qMatrixView.vectorListWeight[0][colIndex] = qMatrix[0][colIndex]
                } else if colIndex < 20 {
                    kMatrixView.vectorListWeight[0][colIndex - 10] = kMatrix[0][colIndex - 10]
                } else {
                    vMatrixView.vectorListWeight[0][colIndex - 20] = vMatrix[0][colIndex - 20]
                }
                
                for rowIndex in 0..<row {
                    embeddingMatrix.vectorListWeight[0][rowIndex] *= 2
                    QKVMatrix.matrixWeight[rowIndex][colIndex] *= 2
                    try? await Task.sleep(nanoseconds: UInt64((duration / 3) * 1_000_000_000))
                }
                
                embeddingMatrix.vectorListWeight[0] = embeddingMatrix.vectorListWeight[0].map { $0 / 2 }
            }
            
            QKVMatrix.matrixWeight = QKVMatrix.matrixWeight.map { $0.map { $0 / 2 } }
            biasVector.weight = biasVector.weight.map { $0 / 2 }
        }
        
        @MainActor
        func executeThirdPhase() async {
            let repeatTime = tokens.count - 1
            
            for repeatCount in 0..<repeatTime {
                embeddingMatrix.vectorListWeight[repeatCount + 1] =
                    embeddingMatrix.vectorListWeight[repeatCount + 1].map { $0 * 2 }
                
                for colIndex in 0..<col {
                    biasVector.weight[colIndex] *= 2
                    
                    if colIndex < 10 {
                        qMatrixView.vectorListWeight[repeatCount + 1][colIndex] =
                            qMatrix[repeatCount + 1][colIndex]
                    } else if colIndex < 20 {
                        kMatrixView.vectorListWeight[repeatCount + 1][colIndex - 10] =
                            kMatrix[repeatCount + 1][colIndex - 10]
                    } else {
                        vMatrixView.vectorListWeight[repeatCount + 1][colIndex - 20] =
                            vMatrix[repeatCount + 1][colIndex - 20]
                    }
                    
                    for rowIndex in 0..<row {
                        QKVMatrix.matrixWeight[rowIndex][colIndex] *= 2
                    }
                    
                    try? await Task.sleep(nanoseconds: UInt64((duration / 10) * 1_000_000_000))
                }
                
                if repeatCount < repeatTime-1 {
                    embeddingMatrix.vectorListWeight[repeatCount+1] =
                    embeddingMatrix.vectorListWeight[repeatCount+1].map { $0 / 2 }
                    QKVMatrix.matrixWeight = QKVMatrix.matrixWeight.map { $0.map { $0 / 2 } }
                    biasVector.weight = biasVector.weight.map { $0 / 2 }
                }
            }
            
            // Final cleanup
            embeddingMatrix.vectorListWeight[repeatTime] =
                embeddingMatrix.vectorListWeight[repeatTime].map { $0 / 2 }
        }
        
        // 主执行序列
        Task {
            await executeFirstPhase()
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds pause
            
            await executeSecondPhase()
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds pause
            
            await executeThirdPhase()
        }
    }
}
