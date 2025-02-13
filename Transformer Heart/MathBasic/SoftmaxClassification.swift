//
//  VectorMatrix.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//

import SwiftUI

struct SoftmaxClassificationView: View {
    // MARK: - State Properties
    @State private var preValues: [Double] = [2.0, 1.0, 0.1]  // Raw logits
    @State private var postValues: [Double] = [2.0, 1.0, 0.1]  // Softmax probabilities
    @State private var isShowingSoftmax: Bool = false
    @State private var selectedClass: Int? = nil
    @State private var classLabels = ["Cat", "Dog", "Bird"]
    
    // MARK: - Computed Properties
    private var softmaxExampleView: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                HStack(spacing: 40) {
                    // Input logits
                    VStack {
                        Text("Logits")
                            .font(.caption)
                            .foregroundColor(.gray)
                        VerticalVectorView(
                            dimention: 3,
                            vector: VectorViewModel(weight: preValues),
                            labels: preValues,
                            color: .yellow,
                            zoom: 1.0,
                            defaultWidth: 35,
                            defaultHeight: 40,
                            spacing: 2,
                            cornerRadius: 4,
                            withLabel: true
                        )
                        .cornerRadius(10)
                    }
                    
                    // Softmax transformation
                    VStack {
                        Text("Softmax")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isShowingSoftmax ? .blue : .gray)
                        Image(systemName: "arrow.right")
                            .foregroundColor(isShowingSoftmax ? .blue : .gray)
                    }
                    
                    // Probabilities
                    VStack {
                        Text("Probabilities")
                            .font(.caption)
                            .foregroundColor(.gray)
                        VerticalVectorView(
                            dimention: 3,
                            vector: VectorViewModel(weight: postValues),
                            labels: postValues,
                            color: .blue,
                            zoom: 1.0,
                            defaultWidth: 35,
                            defaultHeight: 40,
                            spacing: 2,
                            cornerRadius: 4,
                            withLabel: true
                        )
                        .cornerRadius(10)
                    }
                    
                    // Class labels
                    VStack(spacing: 12) {
                        Text("Classes")
                            .font(.caption)
                            .foregroundColor(.gray)
                        ForEach(0..<3) { i in
                            Text(classLabels[i])
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(selectedClass == i ? Color.green.opacity(0.3) : Color.clear)
                                )
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                )
                
                // Animation control
                Button(action: {
                    animateSoftmax()
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text(isShowingSoftmax ? "Reset" : "Apply Softmax")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            Spacer()
        }
        .padding()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("Softmax & Classification")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.gray.opacity(0.3))
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                // Main content
                VStack(alignment: .leading, spacing: 20) {
                    Text("1. What is Softmax?")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("Softmax is a special activation function commonly used in classification tasks. It converts a vector of numbers (logits) into probabilities that sum to 1.")
                        .font(.body)
                        .lineSpacing(8)
                    
                    Text("The softmax formula for each component is:")
                        .font(.body)
                    
                    HStack {
                        Spacer()
                        Text("softmax(x_i) = e^(x_i) / Σ(e^(x_j))")
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        Spacer()
                    }
                    
                    Text("Softmax is perfect for multi-class classification: suppose we have a vector with each dimension represent the 'score' of each class, apply softmax would give us the probability of each class.")
                        .font(.body)
                        .lineSpacing(8)

                    Text("Let's see how it works with an example:")
                        .font(.body)
                    
                    softmaxExampleView
                    
                    Text("2. How softmax and multi-classification is related to LLM")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    Text("In Language Models, the task of predicting the next word can be seen as a massive multi-class classification problem. Each word in the vocabulary is a potential class.")
                        .font(.body)
                        .lineSpacing(8)
                    
                    Text("For example, if a model has a vocabulary of 50,000 words, at each prediction step:")
                        .font(.body)
                        .lineSpacing(8)
                        .padding(.top, 4)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("1. The model outputs a vector of 50,000 'scores' (logits)")
                        Text("2. Softmax converts these scores into probabilities")
                        Text("3. Each probability represents how likely that word is to come next")
                        Text("4. The word with highest probability is chosen (or sampled from)")
                    }
                    .font(.body)
                    .padding(.leading)
                    
                    Text("When you see an LLM generating text, it's repeatedly performing this classification process, using softmax to decide which word comes next based on the context.")
                        .font(.body)
                        .lineSpacing(8)
                        .padding(.top, 4)
                }
                .padding()
            }
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.1))
    }
    
    // MARK: - Animation Functions
    private func animateSoftmax() {
        if isShowingSoftmax {
            // Reset
            withAnimation(.easeInOut(duration: 0.5)) {
                postValues = preValues
                isShowingSoftmax = false
                selectedClass = nil
            }
        } else {
            // Apply Softmax
            withAnimation(.easeInOut(duration: 0.5)) {
                // Calculate e^x for each value
                let expValues = preValues.map { exp($0) }
                // Calculate sum of e^x
                let sum = expValues.reduce(0, +)
                // Calculate softmax probabilities
                postValues = expValues.map { $0 / sum }
                isShowingSoftmax = true
                // Find the class with highest probability
                selectedClass = postValues.firstIndex(of: postValues.max()!)
            }
        }
    }
}
