//
//  ProbabilityExplanation.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/19.
//

import SwiftUI

struct OutputProbabilityExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Next Token Prediction")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("After the input has been processed through all Transformer blocks, the output is passed through the final linear layer to prepare it for token prediction. This layer projects the final representations into a 50,257 dimensional space, where every token in the vocabulary has a corresponding value called logit.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                // Projection process
                Text("Projection Process")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("1. Final Linear Layer")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Projects from model dimension (768) to vocabulary size (50,257), which uses Unembedding Matrix.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("2. Logits Generation")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Each token in the vocabulary receives a score (logit) indicating its likelihood of being the next token.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("3. Probability Distribution")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Softmax function converts logits into probabilities that sum to one, allowing us to sample the next token based on its likelihood.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
}

struct UnembeddingMatrixExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Unembedding Matrix")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("The unembedding matrix is the final linear transformation that converts the model's hidden states back into vocabulary space. In GPT-2, this matrix is actually shared with the input embedding matrix to save parameters and improve performance.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                // Technical details
                Text("Technical Details")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("1. Dimension Transformation")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Converts from model dimension (768) to vocabulary size (50,257)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("2. Weight Sharing")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Uses the transpose of the input embedding matrix, reducing model size and enforcing consistency between input and output spaces")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
}

struct TemperatureExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Temperature")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("Temperature is a hyperparameter that controls the randomness in the token selection process. It scales the logits before they are passed through the softmax function, affecting how 'confident' or 'creative' the model's predictions are.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                // Effects
                Text("Temperature Effects")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("1. Low Temperature (< 1.0)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Makes the model more confident and deterministic, focusing on the most likely tokens")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("2. High Temperature (> 1.0)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Makes the model more creative and diverse, giving more chances to less likely tokens")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
}

struct SoftmaxProbabilityExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Final Token Probabilities")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("After applying temperature scaling to the logits, the softmax function converts them into a probability distribution over the entire vocabulary. This distribution determines the likelihood of each token being selected as the next word in the sequence.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                // Process
                Text("Selection Process")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("1. Temperature Scaling")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Logits are divided by the temperature value to control randomness")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("2. Probability Conversion")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Softmax converts scaled logits into probabilities that sum to 1")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("3. Token Selection")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("The next token is sampled based on these probabilities, with higher probability tokens being more likely to be chosen")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
}
