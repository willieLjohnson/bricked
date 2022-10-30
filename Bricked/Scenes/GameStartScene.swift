import SpriteKit
import AVFoundation
import SKSpriteButton

class GameStartScene: SKScene {
  var audioNode: SKAudioNode {
    return childNode(withName: GameConstants.GameStartSceneMusic) as! SKAudioNode
  }
  private var gameStartButton: SKSpriteButton!
}

// MARK: - Lifecycles
extension GameStartScene {
  override func didMove(to view: SKView) {
    initializeStartButton()
    playBackgroundMusic()
    
    if let title = childNode(withName: "Title") {
      let titleLetters = title.children
      for letter in titleLetters {
        let randomColor = Tetris.allPossible[Int.random(in: 0..<Tetris.allPossible.count, using: &gen)].color
        
        for block in letter.children {
          guard let block = block as? SKSpriteNode else {
            return
          }
          let blockWidth = block.texture!.size().width
          block.texture = PolyominoComponent.createPolyminoBlock(scale: blockWidth, position: block.position, color: randomColor ).texture
          block.drawBorder(color: randomColor, width: 2)
          block.color = randomColor
        }
      }
    }
  }
}

// MARK: - Buttons
private extension GameStartScene {
  func getStartButton() -> SKSpriteButton {
    return childNode(withName: GameConstants.GameStartButtonKey)! as! SKSpriteButton
  }
  func initializeStartButton() {
    gameStartButton = getStartButton()
    gameStartButton.moveType = .alwaysHeld
    gameStartButton.tappedTexture = getSFIcon(SFIStrings.playFill, color: GameConstants.palette.primary).asSKTexture()
    gameStartButton.texture = getSFIcon(SFIStrings.playFill, color: GameConstants.palette.primary).asSKTexture()
    gameStartButton.color = GameConstants.palette.primary
    gameStartButton.addTouchesUpHandler {
      [unowned self]
      (_, _) in
  
      let gameScene = SKScene(fileNamed: GameConstants.GameScene)!
      gameScene.scaleMode = .aspectFit
      gameStartButton.tapFeedback(intensity: 3)
      let transition = SKTransition.moveIn(with: .up, duration: 0.3)
      self.view?.presentScene(gameScene, transition: transition)
    }
  }
  
}

// MARK: - Audio
private extension GameStartScene {
  func playBackgroundMusic() {
    audioNode.run(SKAction.play())
    audioNode.isPaused = true
  }
}
