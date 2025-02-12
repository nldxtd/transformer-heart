//
//  Constant.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/3.
//

let tokens: [String] = ["Transformer", "visualization", "em", "powers", "user", "to"]
let embeddingMatrixWeight: [[Double]] = [
    [0.67, 0.47, 0.3, 0.41, 0.67, 0.62, 0.59, 0.66, 0.49, 0.49],
    [0.34, 0.6, 0.38, 0.35, 0.59, 0.63, 0.44, 0.63, 0.42, 0.64],
    [0.37, 0.41, 0.41, 0.68, 0.51, 0.64, 0.69, 0.48, 0.41, 0.34],
    [0.66, 0.51, 0.55, 0.56, 0.44, 0.58, 0.63, 0.57, 0.65, 0.6],
    [0.47, 0.48, 0.7, 0.32, 0.56, 0.4, 0.54, 0.36, 0.39, 0.5],
    [0.31, 0.54, 0.59, 0.7, 0.37, 0.49, 0.39, 0.34, 0.53, 0.37]
]
let QKVMatrixWeight: [[Double]] = [
    [0.24, 0.16, 0.38, 0.2, 0.28, 0.25, 0.2, 0.28, 0.25, 0.31, 0.33, 0.31, 0.27, 0.18, 0.21, 0.17, 0.32, 0.18, 0.33, 0.2, 0.34, 0.29, 0.18, 0.2, 0.37, 0.28, 0.35, 0.39, 0.21, 0.27],
    [0.25, 0.26, 0.31, 0.23, 0.17, 0.17, 0.28, 0.33, 0.33, 0.15, 0.35, 0.33, 0.25, 0.27, 0.36, 0.4, 0.17, 0.29, 0.38, 0.3, 0.2, 0.34, 0.28, 0.39, 0.18, 0.2, 0.38, 0.29, 0.4, 0.32],
    [0.24, 0.17, 0.37, 0.23, 0.27, 0.21, 0.37, 0.4, 0.15, 0.18, 0.27, 0.17, 0.23, 0.3, 0.3, 0.38, 0.23, 0.35, 0.37, 0.37, 0.29, 0.27, 0.28, 0.32, 0.3, 0.28, 0.23, 0.37, 0.4, 0.34],
    [0.18, 0.17, 0.4, 0.37, 0.4, 0.23, 0.36, 0.29, 0.36, 0.32, 0.15, 0.23, 0.16, 0.21, 0.21, 0.36, 0.36, 0.34, 0.2, 0.2, 0.38, 0.34, 0.26, 0.23, 0.19, 0.26, 0.2, 0.25, 0.2, 0.24],
    [0.2, 0.3, 0.18, 0.18, 0.31, 0.34, 0.31, 0.28, 0.16, 0.29, 0.16, 0.23, 0.2, 0.31, 0.2, 0.18, 0.24, 0.26, 0.31, 0.33, 0.23, 0.28, 0.27, 0.38, 0.17, 0.4, 0.22, 0.34, 0.39, 0.34],
    [0.25, 0.38, 0.28, 0.4, 0.39, 0.17, 0.18, 0.39, 0.3, 0.21, 0.23, 0.36, 0.24, 0.4, 0.35, 0.29, 0.27, 0.18, 0.38, 0.3, 0.28, 0.34, 0.15, 0.32, 0.34, 0.18, 0.36, 0.28, 0.34, 0.28],
    [0.38, 0.4, 0.18, 0.33, 0.34, 0.24, 0.34, 0.39, 0.17, 0.34, 0.39, 0.19, 0.2, 0.17, 0.23, 0.3, 0.38, 0.26, 0.23, 0.31, 0.36, 0.3, 0.23, 0.26, 0.38, 0.2, 0.36, 0.18, 0.19, 0.34],
    [0.2, 0.18, 0.21, 0.16, 0.23, 0.17, 0.17, 0.35, 0.35, 0.26, 0.25, 0.33, 0.15, 0.38, 0.4, 0.16, 0.19, 0.17, 0.32, 0.28, 0.28, 0.34, 0.21, 0.21, 0.19, 0.4, 0.34, 0.23, 0.36, 0.24],
    [0.35, 0.35, 0.19, 0.23, 0.35, 0.18, 0.34, 0.35, 0.38, 0.23, 0.31, 0.32, 0.22, 0.34, 0.36, 0.2, 0.23, 0.36, 0.23, 0.26, 0.34, 0.23, 0.34, 0.15, 0.33, 0.35, 0.37, 0.28, 0.38, 0.18],
    [0.34, 0.27, 0.24, 0.24, 0.21, 0.39, 0.19, 0.28, 0.4, 0.23, 0.32, 0.2, 0.33, 0.18, 0.27, 0.34, 0.34, 0.28, 0.32, 0.25, 0.21, 0.27, 0.34, 0.3, 0.35, 0.28, 0.23, 0.3, 0.35, 0.36]
]
let qMatrix: [[Double]] = [
    [0.88, 0.54, 0.75, 0.67, 0.81, 0.49, 0.42, 0.63, 0.63, 0.83],
    [0.45, 0.46, 0.52, 0.46, 0.89, 0.44, 0.72, 0.45, 0.66, 0.44],
    [0.7, 0.77, 0.59, 0.72, 0.48, 0.51, 0.99, 0.99, 0.73, 0.7],
    [0.68, 0.83, 0.79, 0.99, 0.74, 0.65, 0.43, 0.91, 0.91, 0.71],
    [0.73, 0.47, 0.82, 0.76, 0.47, 0.59, 0.4, 0.41, 0.96, 0.41],
    [0.53, 0.58, 0.85, 0.41, 0.94, 0.94, 0.59, 0.63, 0.42, 0.95]
]
let kMatrix: [[Double]] = [
    [0.57, 0.48, 0.98, 0.56, 0.62, 0.6, 0.63, 0.7, 0.71, 0.88],
    [0.77, 0.57, 0.99, 0.53, 0.47, 0.74, 0.55, 0.9, 0.66, 0.49],
    [0.65, 0.54, 0.52, 0.52, 0.78, 0.93, 0.81, 0.82, 0.81, 0.69],
    [0.96, 0.59, 0.85, 0.57, 0.52, 0.99, 0.53, 0.7, 0.4, 0.97],
    [0.56, 0.48, 0.63, 0.47, 0.53, 0.58, 0.48, 0.51, 0.93, 0.97],
    [0.72, 0.77, 0.62, 0.85, 0.74, 0.45, 0.56, 0.74, 0.46, 0.66]
]
let vMatrix: [[Double]] = [
    [0.91, 0.88, 0.58, 0.42, 0.47, 0.96, 0.76, 0.49, 0.46, 0.64],
    [0.98, 0.45, 0.74, 0.5, 0.68, 0.52, 0.57, 0.68, 0.75, 0.92],
    [0.75, 0.9, 0.71, 0.99, 0.57, 0.42, 0.79, 0.57, 0.72, 0.74],
    [0.77, 0.56, 0.88, 0.41, 0.87, 0.61, 0.56, 0.93, 0.77, 0.66],
    [0.64, 0.8, 0.96, 0.69, 0.61, 0.44, 0.68, 0.67, 0.88, 0.63],
    [0.55, 0.44, 0.97, 0.58, 0.47, 0.78, 0.7, 0.75, 0.57, 0.49]
]
let biasVectorWeight: [Double] = [0.18, 0.17, 0.4, 0.37, 0.4, 0.23, 0.36, 0.29, 0.36, 0.32, 0.15, 0.23, 0.16, 0.21, 0.21, 0.36, 0.36, 0.34, 0.2, 0.2, 0.38, 0.34, 0.26, 0.23, 0.19, 0.26, 0.2, 0.25, 0.2, 0.24]
let dotHeadWeight: [[Double]] = [
    [7.32, 7.3, 1.8, 4.8, 5.04, 12.86],
    [11.89, 10.92, 1.26, 8.38, 7.37, 16.02],
    [17.07, 19.68, 12.7, 17.06, 18.64, 7.85],
    [11.99, 3.79, 19.56, 5.82, 10.51, 10.73],
    [10.41, 11.39, 11.14, 2.6, 1.8, 18.58],
    [17.49, 17.47, 11.96, 18.56, 8.21, 8.68]
]
let maskHeadWeight: [[Double]] = [
    [7.32, 7.3, 1.8, 4.8, 5.04, 12.86],
    [11.89, 10.92, 1.26, 8.38, 7.37, 16.02],
    [17.07, 19.68, 12.7, 17.06, 18.64, 7.85],
    [11.99, 3.79, 19.56, 5.82, 10.51, 10.73],
    [10.41, 11.39, 11.14, 2.6, 1.8, 18.58],
    [17.49, 17.47, 11.96, 18.56, 8.21, 8.68]
]
let softHeadWeight: [[Double]] = [
    [7.32, 7.3, 1.8, 4.8, 5.04, 12.86],
    [11.89, 10.92, 1.26, 8.38, 7.37, 16.02],
    [17.07, 19.68, 12.7, 17.06, 18.64, 7.85],
    [11.99, 3.79, 19.56, 5.82, 10.51, 10.73],
    [10.41, 11.39, 11.14, 2.6, 1.8, 18.53],
    [17.49, 17.47, 11.96, 18.56, 8.21, 8.68]
]
let feedForwardMatrixWeight: [[Double]] = [
    [0.67, 0.47, 0.3, 0.41, 0.67, 0.62, 0.59, 0.66, 0.49, 0.49],
    [0.34, 0.6, 0.38, 0.35, 0.59, 0.63, 0.44, 0.63, 0.42, 0.64],
    [0.37, 0.41, 0.41, 0.68, 0.51, 0.64, 0.69, 0.48, 0.41, 0.34],
    [0.66, 0.51, 0.55, 0.56, 0.44, 0.58, 0.63, 0.57, 0.65, 0.6],
    [0.47, 0.48, 0.7, 0.32, 0.56, 0.4, 0.54, 0.36, 0.39, 0.5],
    [0.31, 0.54, 0.59, 0.7, 0.37, 0.49, 0.39, 0.34, 0.53, 0.37]
]
let feedForwardOutputMatrixWeight: [[Double]] = [
    [0.67, 0.47, 0.3, 0.41, 0.67, 0.62, 0.59, 0.66, 0.49, 0.49],
    [0.34, 0.6, 0.38, 0.35, 0.59, 0.63, 0.44, 0.63, 0.42, 0.64],
    [0.37, 0.41, 0.41, 0.68, 0.51, 0.64, 0.69, 0.48, 0.41, 0.34],
    [0.66, 0.51, 0.55, 0.56, 0.44, 0.58, 0.63, 0.57, 0.65, 0.6],
    [0.47, 0.48, 0.7, 0.32, 0.56, 0.4, 0.54, 0.36, 0.39, 0.5],
    [0.31, 0.54, 0.59, 0.7, 0.37, 0.49, 0.39, 0.34, 0.53, 0.37]
]

let hiddenLayerMatrixWeight: [[Double]] = [
    [0.67, 0.47, 0.3, 0.41, 0.67, 0.62, 0.59, 0.66, 0.49, 0.49],
    [0.34, 0.6, 0.38, 0.35, 0.59, 0.63, 0.44, 0.63, 0.42, 0.64],
    [0.37, 0.41, 0.41, 0.68, 0.51, 0.64, 0.69, 0.48, 0.41, 0.34],
    [0.66, 0.51, 0.55, 0.56, 0.44, 0.58, 0.63, 0.57, 0.65, 0.6],
    [0.47, 0.48, 0.7, 0.32, 0.56, 0.4, 0.54, 0.36, 0.39, 0.5],
    [0.31, 0.54, 0.59, 0.7, 0.37, 0.49, 0.39, 0.34, 0.53, 0.37]
]

let firstMatrixWeight: [[Double]] = [
    [0.6, 0.7, 0.3],
    [0.8, 0.1, 0.2]
]

let secondMatrixWeight: [[Double]] = [
    [0.5, 0.2],
    [0.4, 0.7],
    [0.1, 1.0]
]

let resultMatrixWeight: [[Double]] = [
    [0.61, 0.91],
    [0.46, 0.43]
]

let vecMatrixWeight: [[Double]] = [
    [0.6, 0.7, 0.3],
    [0.8, 0.1, 0.2]
]

let vecWeight: [Double] = [0.5, 0.4, 0.1]
 
let resWeight: [Double] = [0.61, 0.46]