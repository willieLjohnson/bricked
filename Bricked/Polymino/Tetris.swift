import CoreGraphics
import UIKit.UIColor

// MARK: - Polyomino
struct Tetris: Polyomino {
  // List of all possible Tetris shapes
  static var allPossible: [Polyomino] {
    return [
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 0),
        CGPoint(x: 1, y: -1),
        CGPoint(x: 2, y: -1)
      ], anchor: CGPoint(x: 1, y: -1), color: .white), // z
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 1),
        CGPoint(x: 1, y: 0),
        CGPoint(x: 2, y: 0)
      ], anchor: CGPoint(x: 1, y: 0), color: .cyan), // T
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 1),
        CGPoint(x: 1, y: 0),
        CGPoint(x: 2, y: 1)
      ], anchor: CGPoint(x: 1, y: 0), color: .yellow), // s
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: -1),
        CGPoint(x: 0, y: -2),
        CGPoint(x: 1, y: -2)
      ], anchor: CGPoint(x: 0, y: -1), color: .orange), // L
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 2),
        CGPoint(x: 1, y: 1),
        CGPoint(x: 1, y: 0)
      ], anchor: CGPoint(x: 1, y: 1), color: .purple), // J
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: -1),
        CGPoint(x: 1, y: 0),
        CGPoint(x: 1, y: -1)
      ], anchor: CGPoint(x: 0.5, y: -0.5), color: .green), // O
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 0),
        CGPoint(x: 2, y: 0),
        CGPoint(x: 3, y: 0)
      ], anchor: CGPoint(x: 1.5, y: 0.5), color: .red), // I

      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 1),
        CGPoint(x: 1, y: 0),
      ], anchor: CGPoint(x: 0.5, y: 0.5), color: .gray), // V
      Tetris(points: [
        CGPoint(x: 0, y: 0),
      ], anchor: CGPoint(x: 0, y: 0), color: .systemIndigo), // .
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 1),
        CGPoint(x: 1, y: 0),
        CGPoint(x: 0, y: -1),
        CGPoint(x: -1, y: -1),
        CGPoint(x: 1, y: -1),
      ], anchor: CGPoint(x: 0, y: 0), color: .brown), // A
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: -1),
        CGPoint(x: -1, y: -1),
        CGPoint(x: 0, y: 1),
        CGPoint(x: 1, y: 1),
      ], anchor: CGPoint(x: 0, y: 0), color: .darkGray), // S
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: -1),
        CGPoint(x: 1, y: -1),
        CGPoint(x: 0, y: 1),
        CGPoint(x: -1, y: 1),
      ], anchor: CGPoint(x: 0, y: 0), color: .magenta), // Z
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: -1),
        CGPoint(x: 1, y: -1),
        CGPoint(x: 0, y: 1),
        CGPoint(x: 1, y: 1),
      ], anchor: CGPoint(x: 0, y: 0), color: .magenta), // C

      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 1),
        CGPoint(x: -1, y: -1),
      ], anchor: CGPoint(x: 0, y: 0), color: .systemIndigo), // /
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 1),
      ], anchor: CGPoint(x: 0, y: 0), color: .systemIndigo), // .'
      Tetris(points: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 1),
      ], anchor: CGPoint(x: 0, y: 0), color: .blue), // i
    ]
  }
  
  var points: [CGPoint]
  
  var anchorPoint: CGPoint
  
  var color: UIColor
  
  
  var centerPoint: CGPoint {
    return anchorPoint.translate(by: CGPoint(x: 0.5, y: 0.5))
  }
  
  var cellNum: Int {
    return 4
  }
  

}


// MARK: - Initialization
extension Tetris {
  
  /// Initializer takes a list of points
  ///
  /// - Parameter points: points that represents this polyomino (bottom-left corner)
  /// - Parameter point: anchor point
  init(points: [CGPoint], anchor: CGPoint, color: UIColor) {
    self.points = points
    self.anchorPoint = anchor
    self.color = color
  }
}
