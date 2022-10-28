import GameplayKit
import SpriteKit

protocol PolyominoEventDelegate {
  func didOverflow()
}


class PolyominoEntity: TetrisEntity {
  
  var eventDelegate: PolyominoEventDelegate?
  
  
  override func update(deltaTime seconds: TimeInterval) {
    _ = components.map {
      $0.update(deltaTime: seconds)
    }
  }
  
  func pourIntoArena() {
    guard let polyomino = entityManager.polyomino else {
      return
    }
    
    guard let polyominoComponent = polyomino.component(ofType: PolyominoComponent.self) else {
      return
    }
    
    let arena = entityManager.arena
    let arenaHeight = arena.arenaComponent.sprite.size.height
    let numRows = Int(GameConstants.VerticalCellNum)
    
    for spriteComponent in polyominoComponent.spriteComponents {
      let arenaBottom = -arenaHeight / 2
      let distanceToBottom = spriteComponent.sprite.position.y - arenaBottom
      let rowIndex = Int(distanceToBottom / arena.scale)
      guard rowIndex < numRows else {
        eventDelegate?.didOverflow()
        return
      }
      arena.nodesBuckets[rowIndex].append(spriteComponent.sprite)
    }
  }


}
