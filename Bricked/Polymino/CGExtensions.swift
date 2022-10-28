import CoreGraphics

// MARK: - CGSize
extension CGSize {
  static func * (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width * right.width, height: left.height * right.height)
  }
  
  static func * (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
  }
}

// MARK: - Convenience methods for CGPoint.
extension CGPoint {
    
    /// Get the translation from another `CGPoint` to this point.
    ///
    /// - Parameter point: origin `CGPoint`
    /// - Returns: the translation moves origin to this point
    func translation(from point: CGPoint) -> CGPoint {
        return CGPoint(x: x - point.x, y: y - point.y)
    }
    
    /// Get the translation from this point to another `CGPoint`.
    ///
    /// - Parameter point: destination `CGPoint`
    /// - Returns: the translation moves this point to the destination
    func translation(to point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - x, y: point.y - y)
    }
    
    /// Translate this point by the given translation.
    ///
    /// - Parameter translation: the translation applied to this point
    /// - Returns: the destination `CGPoint`
    func translate(by translation: CGPoint) -> CGPoint {
        return CGPoint(x: x + translation.x, y: y + translation.y)
    }
    
    /// Clockwise rotate a point around a pivot.
    ///
    /// - Parameter pivot: the pivot to rotate around
    /// - Returns: the clockwise rotated point
    func clockwiseRotated(around pivot: CGPoint) -> CGPoint {
        let translatedPoint = translation(from: pivot)
        let rotatedPoint = CGPoint(x: translatedPoint.y, y: -translatedPoint.x)
        return rotatedPoint.translate(by: pivot)
    }
    
    /// Counter-clockwise rotate a point around a pivot.
    ///
    /// - Parameter pivot: the pivot to rotate around
    /// - Returns: the counter-clockwise rotated point
    func counterClockwiseRotated(around pivot: CGPoint) -> CGPoint {
        let translatedPoint = translation(from: pivot)
        let rotatedPoint = CGPoint(x: -translatedPoint.y, y: translatedPoint.x)
        return rotatedPoint.translate(by: pivot)
    }
    
    /// Generates all "neighbor" points vertically or horizontally.
    ///
    /// - Parameter distance: distance to this point
    /// - Returns: a list of "neighbor" points
    func adjacentPoints(with distance: CGFloat) -> [CGPoint] {
        var neighbors = [CGPoint]()
        neighbors.append(self.translate(by: CGPoint(x: distance, y: 0)))
        neighbors.append(self.translate(by: CGPoint(x: 0, y: distance)))
        neighbors.append(self.translate(by: CGPoint(x: -distance, y: 0)))
        neighbors.append(self.translate(by: CGPoint(x: 0, y: -distance)))
        return neighbors
    }
}
