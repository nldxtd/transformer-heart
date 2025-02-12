//
//  VectorMatrix.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//

import SwiftUI

struct MatrixMultiplicationView: View {

    @State private var matrix: VectorListViewModel = VectorListViewModel(matrixWeight: firstMatrixWeight)

    @State private var vec: VectorViewModel = VectorViewModel(weight: vecWeight)
 
    @State private var res: VectorViewModel = VectorViewModel(weight: resWeight)

    @State private var firstMatrix: VectorListViewModel = VectorListViewModel(matrixWeight: firstMatrixWeight)

    @State private var secondMatrix: VectorListViewModel = VectorListViewModel(matrixWeight: secondMatrixWeight)

    @State private var resultMatrix: VectorListViewModel = VectorListViewModel(matrixWeight: resultMatrixWeight)

    @State private var firstAnimationEnable: Bool = true

    @State private var secondAnimationEnable: Bool = true

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("Matrix Multiplication")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.gray.opacity(0.3))
                        .padding(.horizontal)
                }
                .padding(.top, 40)

                VStack(alignment: .leading, spacing: 20) {
                    Text("1. Matrix * Vector")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(
                        "Matrix vector multiplication is a special case of matrix multiplication. You can see matrix as row vectors stack up in verticle direction and the vector as a column vector. Apply vector inner product to each row with the column vector, and the result is a new vector. The size of the new vector is the same as the number of rows in the matrix."
                    )
                    .font(.body)
                    .lineSpacing(8)

                    Text(
                        "The following animation can help you understand this process:"
                    )
                    .font(.body)
                    .lineSpacing(8)


                    VStack {
                        HStack {
                            Spacer()
                            // Display the matrix
                            VectorList(
                                dimention: 3,
                                vectors: matrix,
                                labels: firstMatrixWeight,
                                color: .green,
                                defaultWidth: 30,
                                defaultHeight: 40,
                                spacing: 2,
                                vectorSpacing: 2,
                                matrixMode: true,
                                withLabel: true
                            )
                            .padding()

                            Text("\u{00D7}")

                            // Display the vector
                            VerticalVectorView(
                                dimention: 3,
                                vector: vec,
                                labels: vecWeight,
                                color: .yellow,
                                zoom: 1.0,
                                defaultWidth: 30,
                                defaultHeight: 40,
                                spacing: 2,
                                cornerRadius: 4,
                                withLabel: true
                            )
                            .padding()


                            Text("=")

                            // Display the result vector
                            VerticalVectorView(
                                dimention: 2,
                                vector: res,
                                labels: resWeight,
                                color: .blue,
                                zoom: 1.0,
                                defaultWidth: 30,
                                defaultHeight: 40,
                                spacing: 2,
                                cornerRadius: 4,
                                withLabel: true
                            )
                            .padding()
                            Spacer()
                        }

                        Button(action: {
                            playMatVecMultiplication()
                        }) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(
                                    Circle()
                                        .fill(firstAnimationEnable ? Color.blue : Color.gray)
                                )
                                .shadow(radius: 4)
                        }
                        .disabled(!firstAnimationEnable)
                    }
                }
                .padding()

                Divider()
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 20) {
                    Text("2. Matrix * Matrix")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(
                        "Matrix multiplication is a more general case of matrix vector multiplication. The result of matrix multiplication is a new matrix. The size of the new matrix is the same as the number of rows in the first matrix and the number of columns in the second matrix. The element in the i-th row and j-th column of the new matrix is the inner product of the i-th row of the first matrix and the j-th column of the second matrix."
                    )
                    .font(.body)
                    .lineSpacing(8)

                    Text(
                        "The following animation can help you understand this process:"
                    )
                    .font(.body)
                    .lineSpacing(8)
                    
                    VStack {
                        HStack {
                            Spacer()
                            // Display the matrix
                            VectorList(
                                dimention: 3,
                                vectors: firstMatrix,
                                labels: firstMatrixWeight,
                                color: .green,
                                defaultWidth: 30,
                                defaultHeight: 40,
                                spacing: 2,
                                vectorSpacing: 2,
                                matrixMode: true,
                                withLabel: true
                            )
                            .padding()

                            Text("\u{00D7}")

                            // Display the second matrix
                            VectorList(
                                dimention: 2,
                                vectors: secondMatrix,
                                labels: secondMatrixWeight,
                                color: .yellow,
                                defaultWidth: 30,
                                defaultHeight: 40,
                                spacing: 2,
                                vectorSpacing: 2,
                                matrixMode: true,
                                withLabel: true
                            )
                            .padding()

                            Text("=")

                            // Display the result matrix
                            VectorList(
                                dimention: 2,
                                vectors: resultMatrix,
                                labels: resultMatrixWeight,
                                color: .blue,
                                defaultWidth: 30,
                                defaultHeight: 40,
                                spacing: 2,
                                vectorSpacing: 2,
                                matrixMode: true,
                                withLabel: true
                            )
                            .padding()
                            Spacer()
                        }

                        Button(action: {
                            playMatMatMultiplication()
                        }) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(
                                    Circle()
                                        .fill(secondAnimationEnable ? Color.blue : Color.gray)
                                )
                                .shadow(radius: 4)
                        }
                        .disabled(!secondAnimationEnable)
                    }
                }
                .padding()
            }
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.1))
    }

    func playMatVecMultiplication() {
        let row = 2
        let col = 3
        var rowIndex = 0
        var colIndex = 0
        firstAnimationEnable = false
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if rowIndex == row {
                timer.invalidate()
                res.weight = resWeight
                firstAnimationEnable = true
            } else {
                let currentRowIndex = rowIndex
                let currentColIndex = colIndex
                if currentColIndex == col {
                    res.weight[currentRowIndex] *= 2
                    matrix.vectorListWeight[currentRowIndex] = vecMatrixWeight[currentRowIndex]
                    print(vecMatrixWeight[currentRowIndex])
                    vec.weight = vecWeight
                    colIndex = 0
                    rowIndex += 1
                } else {
                    matrix.vectorListWeight[currentRowIndex][currentColIndex] *= 2
                    vec.weight[colIndex] *= 2
                    colIndex += 1
                }
            }
        }
    }

    func playMatMatMultiplication() {
        let row = 2
        let k = 3
        var rowIndex = 0
        var kIndex = 0
        var colIndex = 0
        secondAnimationEnable = false
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if rowIndex == row {
                timer.invalidate()
                resultMatrix.vectorListWeight = resultMatrixWeight
                secondAnimationEnable = true
            } else {
                let currentRowIndex = rowIndex
                let currentKIndex = kIndex
                let currentColIndex = colIndex
                if currentKIndex == k {
                    resultMatrix.vectorListWeight[currentRowIndex][currentColIndex] *= 2
                    firstMatrix.vectorListWeight[currentRowIndex] = firstMatrixWeight[currentRowIndex]
                    for idx in 0..<3 {
                        secondMatrix.vectorListWeight[idx][currentColIndex] = secondMatrixWeight[idx][currentColIndex]
                    }
                    rowIndex += currentColIndex
                    colIndex = 1-currentColIndex
                    kIndex = 0
                } else {
                    firstMatrix.vectorListWeight[currentRowIndex][currentKIndex] *= 2
                    secondMatrix.vectorListWeight[currentKIndex][currentColIndex] *= 2
                    kIndex += 1
                }
            }
        }
    }
}
