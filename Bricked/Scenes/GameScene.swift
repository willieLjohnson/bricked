import SpriteKit
import UIKit
import GameplayKit
import SKSpriteButton

class GameScene: SKScene {
  
  let entityManager = EntityManager()
  
  lazy var stateMachine: GKStateMachine = {
    let playState = PlayState(withGame: self)
    let pauseState = PauseState(withGame: self)
    return GKStateMachine(states: [playState, pauseState])
  }()
  
  var hitSound = SKAction.playSoundFileNamed(GameConstants.HitSoundFileName, waitForCompletion: false)
  
  var audioNode: SKAudioNode {
    return childNode(withName: GameConstants.GameStartSceneMusic) as! SKAudioNode
  }
  
  var pauseNode: SKSpriteNode {
    return childNode(withName: GameConstants.PauseAreaKey) as! SKSpriteNode
  }
  
  // Buttons
  private var leftButton: SKSpriteButton!
  private var rightButton: SKSpriteButton!
  private var downButton: SKSpriteButton!
  private var pauseButton: SKSpriteButton!
  private var rotateButton: SKSpriteButton!
 
  var lastUpdateTime: TimeInterval = 0
}

// MARK: - Lifecycle methods
extension GameScene {
  override func update(_ currentTime: TimeInterval) {
    let deltaTime = currentTime - lastUpdateTime
    lastUpdateTime = currentTime
    stateMachine.update(deltaTime: deltaTime)
  }
  
  override func didMove(to view: SKView) {
    initializeSpawnArea()
    initializeArena()
    initializeButtons()
    initializeScore()
    
    entityManager.spawnArea.spawnPolyominoEntity(withDelegate: self)
    entityManager.spawnArea.stagePolyomino()
    entityManager.spawnArea.spawnPolyominoEntity(withDelegate: self)
    
    stateMachine.enter(PauseState.self)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard stateMachine.currentState is PauseState else {
      return
    }
    for touch in touches {
      if pauseNode.frame.contains(touch.location(in: self)) {
        stateMachine.enter(PlayState.self)
      }
    }
  }
}

// MARK: - FixedMoveComponentDelegate
extension GameScene: FixedMoveComponentDelegate {
  func didStablize() {
    entityManager.polyomino?.pourIntoArena()
    entityManager.remove(entity: entityManager.arena.droppingPolyomino!)
    entityManager.spawnArea.stagePolyomino()
    entityManager.spawnArea.spawnPolyominoEntity(withDelegate: self)
    entityManager.arena.clearIfFull()
    run(hitSound)
  }
}

extension GameScene: PolyominoEventDelegate {
  func didOverflow() {
    guard let gameOverScene = SKScene(fileNamed: GameConstants.GameOverScene) as? GameOverScene else {
      return
    }
    gameOverScene.score = entityManager.scoreLabel.score
    gameOverScene.scaleMode = .aspectFit
    let transition = SKTransition.moveIn(with: .right, duration: 0.5)
    self.view?.presentScene(gameOverScene, transition: transition)
  }
}

// MARK: - Initializations
private extension GameScene {
  
  func playBackgroundMusic() {
    audioNode.run(SKAction.play())
  }
  
  func initializeSpawnArea() {
    guard let spawnAreaSprite = childNode(withName: GameConstants.SpawnAreaKey) as? SKSpriteNode else {
      return
    }
    
    let spawnAreaComponent = SpawnAreaComponent(withSpriteNode: spawnAreaSprite)
    let spawnAreaEntity = SpawnAreaEntity(withComponents: [spawnAreaComponent], withEntityManager: entityManager)
    entityManager.add(entity: spawnAreaEntity)
  }
  
  func initializeArena() {
    guard let arenaSprite = childNode(withName: GameConstants.TetrisArenaKey) as? SKSpriteNode else {
      return
    }
    arenaSprite.drawBorder(color: .gray, width: 4, radius: 4)
    let arenaComponent = ArenaComponent(withSpriteNode: arenaSprite)
    let rules = [
      GKRule(predicate: NSPredicate {
        (obj, _) in
        guard let score = (obj as! GKRuleSystem).state[GameConstants.CurrentScoreKey] as? Int else {
          return false
        }
        return score % GameConstants.NumScoreBeforeProceeding == 0
      }, assertingFact: GameConstants.ProceedToNextLevelFact as NSObjectProtocol, grade: 1.0)
    ]
    let ruleComponent = RuleComponent(withRules: rules)
    let arenaEntity = ArenaEntity(withComponents: [arenaComponent,
                                                   ruleComponent], withEntityManager: entityManager)
    entityManager.add(entity: arenaEntity)
  }
  
  func initializeScore() {
    guard let scoreLabelNode = childNode(withName: GameConstants.ScoreLabelKey) as? SKLabelNode else {
      return
    }
    let scoreComponent = LabelComponent(withLabelNode: scoreLabelNode)
    let scoreEntity = ScoreEntity(withComponents: [scoreComponent], withEntityManager: entityManager)
    entityManager.add(entity: scoreEntity)
  }
  
  func initializeButtons() {
    initializeLeftButton()
    initializeRightButton()
    initializeDownButton()
    initializeRotateButton()
    initializePauseButton()
  }
  
}

// MARK: - Buttons
private extension GameScene {
  func getLeftButton() -> SKSpriteButton{
    return childNode(withName: GameConstants.LeftButtonKey) as! SKSpriteButton
  }
  
  func getRightButton() -> SKSpriteButton {
    return childNode(withName: GameConstants.RightButtonKey) as! SKSpriteButton
  }
  
  func getDownButton() -> SKSpriteButton {
    return childNode(withName: GameConstants.DownButtonKey) as! SKSpriteButton
  }
  
  func getRotateButton() -> SKSpriteButton{
    return childNode(withName: GameConstants.RotateButtonKey) as! SKSpriteButton
  }
  
  func getPauseButton() -> SKSpriteButton {
    return childNode(withName: GameConstants.PauseButtonKey) as! SKSpriteButton
  }
  
  func initializeLeftButton() {
    leftButton = getLeftButton()
    leftButton.texture = .arrowLeftTexture
    leftButton.addTouchesBeganHandler {
      [unowned self]
      (_, _) in
      leftButton.tapFeedback(intensity: 1)

      guard self.stateMachine.currentState is PlayState else {
        return
      }
      
      let droppingPolyomino = self.entityManager.arena.droppingPolyomino
      guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
        return
      }
      
      moveComponent.direction = .left
      moveComponent.waitForMoveTime = 0.0
      moveComponent.moveHorizontally()
    }
    
    leftButton.addTouchesUpHandler {
      [unowned self]
      (_, _) in
      leftButton.tapFeedback()

      let droppingPolyomino = self.entityManager.arena.droppingPolyomino
      guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
        return
      }
      
      moveComponent.direction = self.rightButton.status == .tapped ? .right : .none
    }
  }
  
  func initializeRightButton() {
    rightButton = getRightButton()
    rightButton.texture = .arrowRightTexture
    rightButton.addTouchesBeganHandler {
      [unowned self]
      (_, _) in
      
      rightButton.tapFeedback(intensity: 1)

      guard self.stateMachine.currentState is PlayState else {
        return
      }
      
      let droppingPolyomino = self.entityManager.arena.droppingPolyomino
      guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
        return
      }
      
      moveComponent.direction = .right
      moveComponent.waitForMoveTime = 0.0
      moveComponent.moveHorizontally()
    }
    rightButton.addTouchesUpHandler {
      [unowned self]
      (_, _) in
      
      rightButton.tapFeedback()

      let droppingPolyomino = self.entityManager.arena.droppingPolyomino
      guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
        return
      }
      
      switch self.stateMachine.currentState {
      case is PlayState:
        moveComponent.direction = self.leftButton.status == .tapped ? .left : .none
      default: break
      }
    }
  }
  
  func initializeDownButton() {
    downButton = getDownButton()
    downButton.texture = .arrowDownTexture
    downButton.addTouchesBeganHandler {
      [unowned self]
      (_, _) in
      
      downButton.tapFeedback(intensity: 1)
      
      let droppingPolyomino = self.entityManager.arena.droppingPolyomino
      guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
        return
      }
      
      moveComponent.currentDropInterval = GameConstants.HurriedUpDropInterval
    }
    
    downButton.addTouchesUpHandler {
      [unowned self]
      (_, _) in
      
      downButton.tapFeedback()
      
      let droppingPolyomino = self.entityManager.arena.droppingPolyomino
      guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
        return
      }
      
      moveComponent.currentDropInterval = self.entityManager.arena.currentDropInterval
    }
  }
  
  func initializeRotateButton() {
    rotateButton = getRotateButton()
    rotateButton.texture = .arrowClockwiseTexture
    rotateButton.color = .white
    rotateButton.addTouchesBeganHandler {
      [unowned self]
      (_, _) in
      
      rotateButton.tapFeedback(intensity: 1)
      
      let droppingPolyomino = self.entityManager.arena.droppingPolyomino
      guard let rotationComponent = droppingPolyomino?.component(ofType: RotationComponent.self) else {
        return
      }
      
      guard let collider = droppingPolyomino?.component(ofType: CollisionCheckingComponent.self) else {
        return
      }
      
      if collider.canTurnClockwise() {
        rotationComponent.turnClockwise()
      }
    }
  }
  
  func initializePauseButton() {
    pauseButton = getPauseButton()
    pauseButton.texture = getSFIcon("pause.circle.fill").asSKTexture()
    pauseButton.addTouchesBeganHandler {
      [unowned self]
      (_, _) in
      pauseButton.tapFeedback(intensity: 5)
      self.stateMachine.enter(PauseState.self)
    }
  }
}
