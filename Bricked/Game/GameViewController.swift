import UIKit
import AVFAudio
import SpriteKit
import GameplayKit


var gen = RNG(seed: 333)

class GameViewController: UIViewController {
  


  override func viewDidLoad() {
    super.viewDidLoad()
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(
        AVAudioSession.Category.playback,
        options: AVAudioSession.CategoryOptions.mixWithOthers
      )
    } catch {
      print("Can't set audio session to mixWithOthers")
    }
    
    if let view = self.view as! SKView? {
      if let scene = SKScene(fileNamed: GameConstants.GameStartScene) {
        scene.scaleMode = .aspectFit
        view.presentScene(scene)
      }
      
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
    }
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
