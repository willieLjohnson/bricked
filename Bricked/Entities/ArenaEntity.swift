import GameplayKit

class ArenaEntity: TetrisEntity {
  
  /// The buckets by row, containing stable nodes.
  var nodesBuckets = [[SKNode]]()
  
  var currentLevel = 0
  
  var currentDropInterval: Double {
    return max(GameConstants.DefaultDropInterval - Double(currentLevel) / 10, GameConstants.MinimumDropInterval)
  }
  
  var croppingComponent: CroppingComponent {
    return component(ofType: CroppingComponent.self)!
  }
  
  var arenaComponent: ArenaComponent {
    return component(ofType: ArenaComponent.self)!
  }
  
  var ruleComponent: RuleComponent {
    return component(ofType: RuleComponent.self)!
  }
  
  weak var droppingPolyomino: PolyominoEntity?
  
  var fallingPolyminos = [BlockComponent]()

  
  var scale: CGFloat {
    return arenaComponent.sprite.size.width / CGFloat(GameConstants.HorizontalCellNum)
  }
  
  override init(withComponents components: [GKComponent], withEntityManager entityManager: EntityManager) {
    super.init(withComponents: components, withEntityManager: entityManager)
    initializeBuckets()
    self.arenaComponent.sprite.color = .clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func clearIfFull() {
    let fullRowNum = GameConstants.HorizontalCellNum
    var clearedRows = [Int]()
    for rowIndex in 0..<nodesBuckets.count {
      if nodesBuckets[rowIndex].count >= fullRowNum {
        clearedRows.append(rowIndex)
      }
    }
    
    let rowsCleared = clearedRows.count
    entityManager.scoreLabel.score += rowsCleared
    
    if rowsCleared > 0 {
      clear(rows: clearedRows)
      ruleComponent.ruleSystem.state[GameConstants.CurrentScoreKey] = entityManager.scoreLabel.score
      
      ruleComponent.ruleSystem.reset()
      ruleComponent.ruleSystem.evaluate()
      if ruleComponent.ruleSystem.grade(forFact: GameConstants.ProceedToNextLevelFact as NSObjectProtocol) > 0 {
        currentLevel += 1
      }
    }
  }
  
  func clear(rows: [Int]) {
    // use a container node so we can group the animation.
    let containerNode = SKNode()
    arenaComponent.sprite.addChild(containerNode)
    var highestRowIndex = 0
    var rowsCleared = rows.count
    for rowIndex in rows {
      highestRowIndex = rowIndex > highestRowIndex ? rowIndex : highestRowIndex
      _ = nodesBuckets[rowIndex].map {
        node in
        node.removeFromParent()
        containerNode.addChild(node)
      }
      nodesBuckets[rowIndex].removeAll()
    }
    
    
    let disappear = SKAction.fadeOut(withDuration: 0.1)
    let appear  = SKAction.fadeIn(withDuration: 0.1)
    let clearAnimation = SKAction.sequence([disappear, appear, disappear, appear])
    containerNode.run(clearAnimation) {
      [unowned self] in
      containerNode.removeFromParent()
      self.compress(highestRowIndex: highestRowIndex, rowsCleared: rows.count)
    }
  }
  
  func compress(highestRowIndex: Int, rowsCleared: Int) {
    for emptyRow in 0..<rowsCleared {
      let startRow = highestRowIndex + 1 - emptyRow
      if !nodesBuckets[startRow].isEmpty {
        descend(rowIndex: startRow, by: 1)
      }
    }
  }
  
  
  func descend(rowIndex index: Int, by level: Int) {
    guard index >= 0 && index < nodesBuckets.count else {
      return
    }
    let numRows = GameConstants.VerticalCellNum
    for rowIndex in index..<numRows {
      let row = nodesBuckets[rowIndex]
     
      for node in row {
        node.position = node.frame.origin.translate(by: CGPoint(x: 0, y: -scale * CGFloat(level)))
      }
      nodesBuckets[rowIndex - 1] = nodesBuckets[rowIndex]
      nodesBuckets[rowIndex].removeAll()
    }
  }
}

private extension ArenaEntity {
  
  func initializeBuckets() {
    let numRow = GameConstants.VerticalCellNum
    nodesBuckets = [[SKNode]](repeating: [SKNode](), count: numRow)
  }
}
