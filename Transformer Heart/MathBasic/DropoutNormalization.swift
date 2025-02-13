//
//  VectorMatrix.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//

import SwiftUI

struct DropoutNormalizationView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("Dropout & Normalization")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.gray.opacity(0.3))
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                // Main content
                VStack(alignment: .leading, spacing: 30) {
                    // Dropout section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("1. Dropout")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Dropout is a regularization technique used in neural networks to prevent overfitting. During training, it randomly 'drops out' (sets to zero) a fraction of neurons in each layer at each training step. This forces the network to learn redundant representations of the data, making it more robust.")
                            .font(.body)
                            .lineSpacing(8)

                        Text("Dropout effectively prevents the model from becoming overly reliant on specific neurons and promotes better generalization to new data. The dropout rate (commonly between 0.2 and 0.5) determines the fraction of neurons to be dropped. During inference (testing), dropout is turned off, and the full network is used, typically with scaled-down weights to account for the training phase's neuron removals.")
                            .font(.body)
                            .lineSpacing(8)
                    }
                    .padding()
                    
                    Divider()

                    // Normalization section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("2. Normalization")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Normalization is a crucial technique in deep learning that standardizes the values flowing through a neural network. It transforms the data to have consistent statistical properties, typically zero mean and unit variance, which helps stabilize and accelerate the training process.")
                            .font(.body)
                            .lineSpacing(8)
                        
                        Text("In modern neural networks, two main types of normalization are commonly used: Batch Normalization, which normalizes across examples in a mini-batch, and Layer Normalization, which normalizes across features in a layer. Both methods help reduce the internal covariate shift problem, where the distribution of each layer's inputs changes during training as the parameters of the previous layers change.")
                            .font(.body)
                            .lineSpacing(8)
                        
                        Text("By normalizing the data, we can use higher learning rates without the risk of divergence, train deeper networks more effectively, and reduce the sensitivity to parameter initialization. This makes normalization particularly important in transformer architectures, where it's applied after self-attention and feed-forward layers to maintain stable gradients throughout the network.")
                            .font(.body)
                            .lineSpacing(8)
                    }
                    .padding()
                }
                .padding()
            }
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.1))
    }
}
