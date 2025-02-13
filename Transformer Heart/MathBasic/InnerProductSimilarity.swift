//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//

import SwiftUI

struct InnerProductSimilarityView: View {

    
    var matrixWeight : [[Double]] = [
        [1, 2, 3, 1],
        [2, 3, 1, 2],
        [1, 2, 1, 1]
    ]

    var formattedEquation: AttributedString {
        var string = AttributedString("a · b = ")
        string.append(AttributedString("a₁b₁ + a₂b₂ + … + aₙbₙ"))
        return string
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 标题部分
                VStack(spacing: 10) {
                    Text("Inner Product and Similarity")
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
                    Text("1. Inner Product")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(
                        "The inner product (also called the dot product) is a fundamental operation in linear algebra. Given two vectors of the same dimension, the inner product is computed as the sum of the element-wise products of their components:"
                    )
                    .font(.body)
                    .lineSpacing(8)

                    HStack {
                        Spacer()
                        Text(formattedEquation)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.1))
                            )
                        Spacer()
                    }

                    Text(
                        "You can use the following coordinate system to see how the inner product with (1, 1) changes with the vector. You will notice when the vector is orthogonal to (1, 1), the inner product is 0. And this divide the plane into positive and negative regions."
                    )
                    .lineSpacing(8)

                    InnerProductPlayground()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(
                                    color: Color.black.opacity(0.1),
                                    radius: 10,
                                    x: 0,
                                    y: 5
                                )
                        )
                }
                .padding()


                Divider()
                    .padding(.horizontal)

                // 矩阵部分
                VStack(alignment: .leading, spacing: 20) {
                    Text("2. Similarity")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(
                        "The inner product can be used to measure the similarity between two vectors. If the inner product of two vectors is positive, it means the vectors are pointing in the same direction. We can use the cosine similarity (dividing the inner product by the product of the vector lengths) to normalize the inner product to the range [-1, 1]."
                    )
                    .font(.body)
                    .lineSpacing(8)

                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Text("Cosine Similarity: ")
                                .font(.body)
                                .fontWeight(.semibold)
                            Text("cos(θ) = (a · b) / (|a| |b|)")
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        )
                        Spacer()
                    }

                    Text(
                        "Similarity can be used to compare likeness between vectors, the larger, the more similar. For example:"
                    )
                    .font(.body)
                    .lineSpacing(8)

                    VStack(spacing: 20) {
                        Text("Examples:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 15) {
                            Text("Sim([1, 2, 3], [2, 3, 1]) = (1×2 + 2×3 + 3×1)/14 = 11/14 ≈ 0.79")
                                .font(.system(.body, design: .monospaced))
                            Text("Sim([1, 2, 3], [1, 3, 2]) = (1×1 + 2×3 + 3×2)/14 = 13/14 ≈ 0.93")
                                .font(.system(.body, design: .monospaced))
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(
                                    color: Color.black.opacity(0.1),
                                    radius: 10,
                                    x: 0,
                                    y: 5
                                )
                        )
                    }

                    Text("Which means [1,3,2] is more similar to [1,2,3].")
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
