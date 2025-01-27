import SwiftUI

struct HorizontalCurveConnection: View {
    var start: CGPoint
    var end: CGPoint
    var color: Color = .gray
    var progress: CGFloat
    var extend: Bool = true
    
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
            if extend {
                path.addLine(to: CGPoint(x: end.x + 132, y: end.y))
            }
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

struct AnimatedCurveShape: Shape {
    var corner1: CGPoint
    var corner2: CGPoint
    var corner3: CGPoint
    var corner4: CGPoint
    var progress: CGFloat // Progress for the animation (0 to 1)

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Interpolated points based on progress
        let animatedValueTopEnd = CGPoint(
            x: corner1.x + (corner2.x - corner1.x) * progress,
            y: corner1.y + (corner2.y - corner1.y) * progress
        )
        let animatedValueBottomEnd = CGPoint(
            x: corner4.x + (corner3.x - corner4.x) * progress,
            y: corner4.y + (corner3.y - corner4.y) * progress
        )
        
        // First curve
        path.move(to: corner1)
        path.addCurve(
            to: animatedValueTopEnd,
            control1: CGPoint(x: corner1.x + (animatedValueTopEnd.x - corner1.x) / 2, y: corner1.y),
            control2: CGPoint(x: corner1.x + (animatedValueTopEnd.x - corner1.x) / 2, y: animatedValueTopEnd.y)
        )
        
        // Line to bottom
        path.addLine(to: animatedValueBottomEnd)
        
        // Second curve
        path.addCurve(
            to: corner4,
            control1: CGPoint(x: corner4.x + (animatedValueBottomEnd.x - corner4.x) / 2, y: animatedValueBottomEnd.y),
            control2: CGPoint(x: corner4.x + (animatedValueBottomEnd.x - corner4.x) / 2, y: corner4.y)
        )
        
        path.closeSubpath()
        return path
    }
}
