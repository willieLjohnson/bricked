import SpriteKit
import SKSpriteButton

class GameOverScene: SKScene {
  var score = 0
  
  var entityManager = EntityManager()
}

// MARK: - Lifecycles
extension GameOverScene {
  override func didMove(to view: SKView) {
    initializeGameOverScore()
    initializeRestartButton()
    initializeMenuButton()
  }
}

// MARK: - Buttons
extension GameOverScene {
  
  var restartButton: SKSpriteButton {
    return childNode(withName: GameConstants.RestartButton)! as! SKSpriteButton
  }
  
  var menuButton: SKSpriteButton {
    return childNode(withName: GameConstants.MenuButton) as! SKSpriteButton
  }
  
  func initializeRestartButton() {
    restartButton.addTouchesBeganHandler {
      [unowned self] (_, _) in
      let gameScene = SKScene(fileNamed: GameConstants.GameScene)!
      gameScene.scaleMode = .aspectFit
      let transition = SKTransition.moveIn(with: .down, duration: 0.3)
      self.view?.presentScene(gameScene, transition: transition)
    }
    restartButton.color = .systemIndigo
    restartButton.drawBorder(color: .black, width: 4, radius: 5)
  }
  
  func initializeMenuButton() {
    menuButton.addTouchesUpHandler {
      [unowned self]
      (_, _) in
      
      let gameScene = SKScene(fileNamed: GameConstants.GameStartScene)!
      gameScene.scaleMode = .aspectFit
      let transition = SKTransition.moveIn(with: .up, duration: 0.5)
      self.view?.presentScene(gameScene, transition: transition)
    }
    menuButton.color = .systemIndigo
    menuButton.drawBorder(color: .black, width: 4, radius: 5)
  }
}

// MARK: - Initializers
extension GameOverScene {
  func initializeGameOverScore() {
    guard let scoreLabel = childNode(withName: GameConstants.EndgameScoreLabelKey) as? SKLabelNode else {
      return
    }
    
    let labelComponent = LabelComponent(withLabelNode: scoreLabel)
    let scoreEntity = ScoreEntity(withComponents: [labelComponent], withEntityManager: entityManager)
    scoreEntity.score = score
  }
}
