import GameplayKit
import SpriteKit

protocol Block {
  var scale: CGFloat { get set }
  var anchorPoint: CGPoint { get }
}

extension Block {
  var anchorPoint: CGPoint { return .zero }
}


/// Special case of a `CompositeSpriteComponent`.
/// Some of the polyomino-specific fields (for e.g.: scale, prototype)
/// should just fit into PolyominoEntity, but instead I put them into
/// a component for better reusability.
class PolyominoComponent: CompositeSpriteComponent, Block {
  /// Scale of each cell in the instantiated polyomino.
  var scale: CGFloat
  
  /// The prototype from which this component is built.
  var prototype: Polyomino
  
  /// The point around which we rotate.
  var anchorPoint: CGPoint {
    let protoAnchorPointX = prototype.anchorPoint.x
    let protoAnchorPointY = prototype.anchorPoint.y
    var initialMidPoint = CGPoint(x: protoAnchorPointX * scale, y: protoAnchorPointY * scale)
    
    /// The anchor point could be moved because dropping and horizontal movement.
    if let fixedMoveComponent = entity?.component(ofType: FixedMoveComponent.self) {
      initialMidPoint = initialMidPoint.translate(by: fixedMoveComponent.accumulatedTranslation)
    }
    
    return initialMidPoint
  }
  
  
  /// Initializes a `PolyominoComponent` with the given texture (if any), scale and prototype.
  /// A prototype should be a `Polyomino` with unit scale.
  ///
  /// - Parameters:
  ///   - texture: Texture for cells in the polyomino
  ///   - scale: length of the side in the cells
  ///   - prototype: a `Polyomino` object serve as prototype
  init(withScale scale: CGFloat, withPrototype prototype: Polyomino) {
    self.scale = scale
    self.prototype = prototype
    super.init()
    _ = prototype.points.map {
      self.spriteComponents.append(SpriteComponent(withSpriteNode: PolyominoComponent.createPolyminoBlock(scale: scale, position: $0, color: prototype.color)))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func createPolyminoBlock(scale: CGFloat, position: CGPoint, color: UIColor) -> SKSpriteNode {
    let size = CGSize(width: scale, height: scale)
    let skNode = SKSpriteNode(color: .black, size: size)
    skNode.position = CGPoint(x: position.x * scale, y: position.y * scale)
    skNode.anchorPoint = CGPoint(x: 0, y: 0)
    skNode.color = .black
    
    let backNode = SKShapeNode(rectOf: size)
    backNode.fillColor = color
    backNode.strokeColor = color
    backNode.lineWidth = 3
    backNode.position = CGPoint(x: scale/2, y: scale/2)
    skNode.addChild(backNode)
    return skNode
  }
}

class BlockComponent: SpriteComponent, Block {
  var scale: CGFloat = 0.0
  
  var color: UIColor
  
  var anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
  
  init(scale: CGFloat, color: UIColor, position: CGPoint) {
    self.scale = scale
    self.color = color
    super.init(withSpriteNode: PolyominoComponent.createPolyminoBlock(scale: scale, position: position, color: color))
  }
  
  convenience init(polymino: PolyominoComponent) {
    self.init(scale: polymino.scale, color: polymino.prototype.color, position: polymino.position)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
