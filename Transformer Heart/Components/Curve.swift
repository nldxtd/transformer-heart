import SwiftUI

struct HorizontalCurveConnection: View {
    var start: CGPoint
    var end: CGPoint
    var color: Color = .gray
    var progress: CGFloat
    
    var body: some View {
        Path { path in
            let horizontalDistance = (end.x - start.x) / 4
            let verticalDistance = end.y - start.y
            
            path.move(to: start)
            // First smooth curve
            path.addCurve(
                to: CGPoint(x: start.x + horizontalDistance * 2, y: start.y + verticalDistance * 0.5),
                control1: CGPoint(
                    x: start.x + horizontalDistance * 0.5,
                    y: start.y
                ),
                control2: CGPoint(
                    x: start.x + horizontalDistance * 1.5,
                    y: start.y + verticalDistance * 0.3
                )
            )
            // Second smooth curve
            path.addCurve(
                to: end,
                control1: CGPoint(
                    x: start.x + horizontalDistance * 2.5,
                    y: start.y + verticalDistance * 0.7
                ),
                control2: CGPoint(
                    x: start.x + horizontalDistance * 3.5,
                    y: end.y
                )
            )
            path.addLine(to: CGPoint(x: end.x + 132, y: end.y))
        }
        .trim(from: 0, to: progress)
        .stroke(color, lineWidth: 2)
    }
}

struct VerticalCurveConnection: View {
    var start: CGPoint
    var end: CGPoint
    var color: Color = .gray
    var progress: CGFloat
    
    var body: some View {
        Path { path in
            let totalDistance = end.x - start.x
            let curveHeight = (end.y - start.y) / 2
            
            path.move(to: start)
            // horizontal
            path.addLine(to: CGPoint(x: start.x + totalDistance * 0.4, y: start.y))
            // curve
            path.addCurve(
                to: CGPoint(x: end.x, y: end.y - curveHeight),
                control1: CGPoint(x: start.x + totalDistance * 0.7, y: start.y),
                control2: CGPoint(x: end.x, y: start.y)
            )
            // verticle
            path.addLine(to: CGPoint(x: end.x, y: end.y + 132))
        }
        .trim(from: 0, to: progress)
        .stroke(color, lineWidth: 2)
    }
}
