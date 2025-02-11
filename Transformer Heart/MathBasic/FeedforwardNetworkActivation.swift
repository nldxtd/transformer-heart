//
//  VectorMatrix.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//

import SwiftUI

struct FeedforwardNetworkActivationView: View {

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 标题部分
                VStack(spacing: 10) {
                    Text("Feed-Forward Network & Activation")
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
                    Text("1. Feed-Forward network")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(
                        "In machine learning, we represent a vector using an array of numbers. The numbers in the array are called components of the vector. The size of a vector is defined by the number of components it contains. For example, a vector with 3 components is called a 3D vector. We can use the following coordinate system to represent a 2D vector which has x coordinate and y coordinate."
                    )
                    .font(.body)
                    .lineSpacing(8)
                }
                .padding()

                Divider()
                    .padding(.horizontal)

                // 矩阵部分
                VStack(alignment: .leading, spacing: 20) {
                    Text("2. Activation Function")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(
                        "A matrix is a rectangular array of numbers arranged in rows and columns. You can see matrix as row vectors stack up in verticle direction or column vectors in horizontal direction. The numbers in the matrix are called elements. The size of a matrix is defined by the number of rows and columns it contains. A matrix with 4 rows and 8 columns can look like this:"
                    )
                    .font(.body)
                    .lineSpacing(8)
                }
                .padding()
            }
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.1))
    }
}
