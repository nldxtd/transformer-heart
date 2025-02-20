import SwiftUI

// First, create an enum to track which component is selected
enum ModelComponent: String {

    case transformer = "Transformer"

    case embedding = "Embedding Layer"
    case tokenization = "Tokenization"
    case tokenEmbedding = "Token Embedding"
    case positionEncoding = "Position Encoding"
    case finalEmbedding = "Final Embedding"
    
    case kqvMatrices = "KQV Matrices"
    case multiheadSplitting = "Multihead Splitting"
    
    // tag
    case maskedSelfAttention = "Masked Self Attention"
    case attentionScore = "Attention Score"
    case masking = "Masking"
    case softmax = "Softmax"
    case outputConcatenation = "Output and Concatenation"
    // tag
    case residualConnection = "Residual Connection"
    
    case ffn = "Feed Forward Network"
    
    case outputProbability = "Next Token Probability"
    case unembeddingMatrix = "Unembedding Matrix"
    case temperature = "Temperature"
    case softmaxProbability = "Softmax Probability"
    
    case none = ""
    
    var description: String {
        switch self {
        case .transformer:
            return "The overall architecture of Transformer"
        
        case .embedding:
            return "The Embedding Layer converts input text into numerical vectors that the model can process, including tokenization and position information."
            
        case .tokenization:
            return "Process of breaking down input text into smaller units (tokens) that can be processed by the model."
            
        case .tokenEmbedding:
            return "Converting each token into a dense vector representation that captures semantic meaning."
            
        case .positionEncoding:
            return "Adding positional information to token embeddings maintain sequence order."
            
        case .finalEmbedding:
            return "The final vector representation combining token embeddings and positional information."
            
        case .kqvMatrices:
            return "Three matrices (Key, Query, Value) that transform input embeddings for attention calculation."
            
        case .multiheadSplitting:
            return "Dividing attention computation into multiple heads to capture different types of relationships."
            
        case .maskedSelfAttention:
            return "Self-attention mechanism that prevents tokens from attending to future positions during training."
            
        case .attentionScore:
            return "Computed similarity scores between queries and keys to determine token relationships."
            
        case .masking:
            return "Process of hiding future tokens during training to prevent information leakage."
            
        case .softmax:
            return "Normalizing attention scores into probabilities that sum to 1."
            
        case .outputConcatenation:
            return "Combining outputs from multiple attention heads into a single representation."            
        case .residualConnection:
            return "Adding input directly to the output to help with gradient flow and preserve information."
            
        case .ffn:
            return "Feed-forward neural network that processes each position independently after attention."
            
        case .outputProbability:
            return "Final layer that converts model output into token probabilities."
            
        case .unembeddingMatrix:
            return "Matrix that converts model's hidden states back into vocabulary space."
            
        case .temperature:
            return "Parameter that controls randomness in the model's token selection process."
            
        case .softmaxProbability:
            return "Final probability distribution over vocabulary for next token prediction."
        case .none:
            return ""
        }
    }
}

struct ExpandableBottomSheet: View {
    @Binding var selectedComponent: ModelComponent
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            if selectedComponent != .none {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        // Component title
                        if !isExpanded {
                            Text(selectedComponent.rawValue)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }

                        Spacer()
                        Button(action: {
                            withAnimation(.spring()) {
                                isExpanded.toggle()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text(isExpanded ? "Show Less" : "Learn More")
                                Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                            }
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.indigo)
                            .cornerRadius(8)
                        }
                    }
                    
                    if !isExpanded {
                        // Brief description
                        Text(selectedComponent.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(isExpanded ? nil : 2)
                    }
                    
                    // Expanded content
                    if isExpanded {
                        ScrollView {
                            DetailedExplanation(component: selectedComponent)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(radius: 10, x: 0, y: -5)
        )
        .frame(width: isExpanded ? 
               min(UIScreen.main.bounds.width * 0.8, 600) : // when expanded
               min(UIScreen.main.bounds.width * 0.4, 400))  // when collapsed
        .frame(height: isExpanded ? 
               UIScreen.main.bounds.height * 0.55 : 
               UIScreen.main.bounds.height * 0.2)
    }
}

struct DetailedExplanation: View {
    let component: ModelComponent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch component {
            case .transformer:
                TransformerExplanation()
            case .embedding:
                EmbeddingExplanation()
            case .tokenization:
                TokenizationExplanation()
            case .tokenEmbedding:
                TokenEmbeddingExplanation()
            case .positionEncoding:
                PositionalEncodingExplanation()
            case .finalEmbedding:
                FinalEmbeddingExplanation()
            case .kqvMatrices:
                KQVMatricesExplanation()
            case .multiheadSplitting:
                MultiheadSplittingExplanation()
            case .maskedSelfAttention:
                MaskedSelfAttentionExplanation()
            case .attentionScore:
                AttentionScoreExplanation()
            case .masking:
                MaskingExplanation()
            case .softmax:
                SoftmaxExplanation()
            case .outputConcatenation:
                OutputConcatenationExplanation()
            case .residualConnection:
                ResidualConnectionExplanation()
            case .ffn:
                MLPExplanation()
            case .outputProbability:
                OutputProbabilityExplanation()
            case .unembeddingMatrix:
                UnembeddingMatrixExplanation()
            case .temperature:
                TemperatureExplanation()
            case .softmaxProbability:
                SoftmaxProbabilityExplanation()
            case .none:
                Text("")
            }
        }
    }
}

struct TransformerExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Transformer Architecture")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Introduction
            Text("Every text-generative Transformer consists of these three key components:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Components explanation
            VStack(alignment: .leading, spacing: 24) {
                // Embedding component
                ComponentExplanationView(
                    title: "1. Embedding Layer",
                    icon: "doc.text.fill",
                    description: "Text input is divided into smaller units called tokens, which can be words or subwords. These tokens are converted into numerical vectors called embeddings, which capture the semantic meaning of words."
                )
                
                // Transformer block component
                ComponentExplanationView(
                    title: "2. Transformer Block",
                    icon: "cube.fill",
                    description: "The fundamental building block that processes and transforms the input data. Each block includes:"
                )
                
                // Sub-components of transformer block
                VStack(alignment: .leading, spacing: 16) {
                    SubComponentView(
                        title: "Attention Mechanism",
                        description: "The core component that allows tokens to communicate with other tokens, capturing contextual information and relationships between words."
                    )
                    
                    SubComponentView(
                        title: "FFN Layer",
                        description: "A feed-forward network that operates on each token independently. While the goal of the attention layer is to route information between tokens, the goal of the FFN is to refine each token's representation."
                    )
                }
                .padding(.leading, 32)
                
                // Output component
                ComponentExplanationView(
                    title: "3. Output Layer",
                    icon: "arrow.right.square.fill",
                    description: "Converts the processed token representations back into vocabulary space to predict the next most likely token in the sequence."
                )
            }
            .padding(.top, 8)
        }
    }
}

struct ComponentExplanationView: View {
    let title: String
    let icon: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.indigo)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.leading, 32)
        }
    }
}

struct SubComponentView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("• " + title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.leading, 12)
        }
    }
}
