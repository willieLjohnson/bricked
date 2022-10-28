import GameplayKit


class SpawnAreaEntity: TetrisEntity {
  let tetrisCellTexturesAtlas = SKTextureAtlas(named: GameConstants.TetrisCellTextureAtlasName)
  
  let creator = PolyominoCreator<Tetris>()
  
  var preparingPolyomino: PolyominoEntity?
  
  func spawnPolyominoEntity(withDelegate delegate: GameScene) {
    guard preparingPolyomino == nil else {
      return
    }
    
    guard let spawnAreaComponent = component(ofType: SpawnAreaComponent.self) else {
      return
    }
    
    let arena = entityManager.arena
    let scale = arena.scale
    let prototypes = creator.allPossible
    
    let randomIndex = Int.random(in: 0..<prototypes.count)
    let chosenPrototype = prototypes[randomIndex]
//    let chosenPrototype = prototypes.last!
    
    let polyominoComponent = PolyominoComponent(withScale: scale, withPrototype: chosenPrototype)
    let rotationComponent = RotationComponent()
    let collisionCheckingComponent = CollisionCheckingComponent()
    let moveComponent = FixedMoveComponent()
    moveComponent.delegate = delegate
    
    let newPolyominoEntity = PolyominoEntity(withComponents: [polyominoComponent,
                                                              moveComponent,
                                                              collisionCheckingComponent,
                                                              rotationComponent],
                                             withEntityManager: entityManager)
    newPolyominoEntity.eventDelegate = delegate
    preparingPolyomino = newPolyominoEntity
    
    polyominoComponent.reparent(toNewParent: spawnAreaComponent.sprite)
    let midPointX = polyominoComponent.prototype.centerPoint.x
    let midPointY = polyominoComponent.prototype.centerPoint.y
    let midPoint = CGPoint(x: midPointX * scale, y: midPointY * scale)
    polyominoComponent.position = polyominoComponent.position.translate(by: midPoint.translation(to: CGPoint.zero))
  }
  
  func stagePolyomino() {
    guard preparingPolyomino != nil else {
      return
    }
    
    entityManager.arena.droppingPolyomino = preparingPolyomino
    
    guard let droppingPolyomino = entityManager.arena.droppingPolyomino else {
      return
    }
    
    entityManager.entities.insert(droppingPolyomino)
    preparingPolyomino = nil
    
    guard let polyominoComponent = droppingPolyomino.component(ofType: PolyominoComponent.self) else {
      return
    }
    let arena = entityManager.arena
    let scale = arena.scale
    polyominoComponent.reparent(toNewParent: arena.arenaComponent.sprite)
    polyominoComponent.position = CGPoint.zero
    guard let fixedMoveComponent = droppingPolyomino.component(ofType: FixedMoveComponent.self) else {
      return
    }
    let arenaNode = arena.arenaComponent.sprite
    fixedMoveComponent.move(by: polyominoComponent.position.translation(to: CGPoint(x: -scale, y: arenaNode.frame.height / 2)))
  }
  
}

