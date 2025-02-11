//
//  VectorMatrix.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//

import SwiftUI

struct VectorMatrixView: View {

    @State private var xValue = 1.3
    @State private var yValue = 0.7
    @State private var matrix: VectorListViewModel = VectorListViewModel(matrixWeight: [
        [0.67, 0.47, 0.3, 0.41, 0.67, 0.62, 0.59, 0.66],
        [0.34, 0.6, 0.38, 0.35, 0.59, 0.63, 0.44, 0.63],
        [0.37, 0.41, 0.41, 0.68, 0.51, 0.64, 0.69, 0.48],
        [0.66, 0.51, 0.55, 0.56, 0.44, 0.58, 0.63, 0.57],
    ])

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 标题部分
                VStack(spacing: 10) {
                    Text("Vector and Matrix")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.gray.opacity(0.3))
                        .padding(.horizontal)
                }
                .padding(.top, 40)

                // 向量部分
                VStack(alignment: .leading, spacing: 20) {
                    Text("1. Vector")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(
                        "In machine learning, we represent a vector using an array of numbers. The numbers in the array are called components of the vector. The size of a vector is defined by the number of components it contains. For example, a vector with 3 components is called a 3D vector. We can use the following coordinate system to represent a 2D vector which has x coordinate and y coordinate."
                    )
                    .font(.body)
                    .lineSpacing(8)

                    HStack {
                        // 坐标系统部分
                        VStack {
                            GeometryReader { geometry in
                                let width = geometry.size.width
                                let height = geometry.size.height
                                let pointX = width / 2 + CGFloat(xValue) * (width / 4)
                                let pointY = height - CGFloat(yValue) * (height / 2)

                                ZStack {
                                    // 绘制坐标轴
                                    Path { path in
                                        // Draw x-axis
                                        path.move(to: CGPoint(x: 0, y: height))
                                        path.addLine(to: CGPoint(x: width, y: height))

                                        // Draw y-axis
                                        path.move(to: CGPoint(x: width / 2, y: 0))
                                        path.addLine(to: CGPoint(x: width / 2, y: height))
                                    }
                                    .stroke(Color.black, lineWidth: 2)

                                    // 添加坐标轴标签
                                    Text("x")
                                        .position(x: width, y: height - 15)
                                    Text("y")
                                        .position(x: width / 2 - 15, y: 5)

                                    // 添加原点标签
                                    Text("O")
                                        .position(x: width / 2 - 10, y: height + 10)

                                    // 绘制点
                                    Path { path in
                                        path.addEllipse(
                                            in: CGRect(
                                                x: pointX - 5, y: pointY - 5, width: 10, height: 10)
                                        )
                                    }
                                    .fill(Color.red)

                                    // 添加坐标点标注
                                    Text(
                                        "[\(xValue, specifier: "%.1f"), \(yValue, specifier: "%.1f")]"
                                    )
                                    .font(.caption)
                                    .position(x: pointX + 30, y: pointY - 10)

                                    // 绘制箭头
                                    Path { path in
                                        path.move(to: CGPoint(x: width / 2, y: height))
                                        path.addLine(to: CGPoint(x: pointX, y: pointY))
                                    }
                                    .stroke(Color.blue, lineWidth: 2)
                                }
                            }
                            .frame(width: 300, height: 150)
                            .padding()
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .padding()

                        // 滑块控制部分
                        VStack(spacing: 15) {

                            HStack {
                                Text("x coordinate:")
                                    .frame(width: 100, alignment: .leading)
                                Text("\(xValue, specifier: "%.1f")")
                                    .frame(width: 50)
                                Slider(value: $xValue, in: -2...2, step: 0.1)
                            }

                            HStack {
                                Text("y coordinate:")
                                    .frame(width: 100, alignment: .leading)
                                Text("\(yValue, specifier: "%.1f")")
                                    .frame(width: 50)
                                Slider(value: $yValue, in: 0...2, step: 0.1)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    .padding()
                }
                .padding()

                Divider()
                    .padding(.horizontal)

                // 矩阵部分
                VStack(alignment: .leading, spacing: 20) {
                    Text("2. Matrix")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(
                        "A matrix is a rectangular array of numbers arranged in rows and columns. You can see matrix as row vectors stack up in verticle direction or column vectors in horizontal direction. The numbers in the matrix are called elements. The size of a matrix is defined by the number of rows and columns it contains. A matrix with 4 rows and 8 columns can look like this:"
                    )
                    .font(.body)
                    .lineSpacing(8)

                    HStack {
                        Spacer()
                        VectorList(
                            dimention: 8,
                            vectors: matrix,
                            color: .green,
                            defaultWidth: 30,
                            defaultHeight: 40,
                            spacing: 2,
                            vectorSpacing: 2,
                            title: "Matrix Example",
                            matrixMode: true,
                            withLabel: true
                        )
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        Spacer()
                    }
                }
                .padding()
            }
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.1))
    }
}
