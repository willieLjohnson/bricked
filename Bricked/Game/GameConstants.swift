import CoreGraphics

struct GameConstants {
  static let HorizontalCellNum: Int = 14
  static let VerticalCellNum: Int = 28
  
  static let DefaultDropInterval = 0.5
  static let MinimumDropInterval = 0.1
  static let HorizontalMovingInterval = 0.1
  static let HurriedUpDropInterval = 0.04
  
  // MARK: - Sprites
  static let SpawnAreaKey = "SpawnArea"
  static let TetrisArenaKey = "TetrisArena"
  static let ScoreLabelKey = "ScoreLabel"
  static let GameScene = "GameScene"
  static let GameOverScene = "GameOverScene"
  static let GameStartScene = "GameStartScene"
  static let EndgameScoreLabelKey = "EndgameScoreLabel"
  static let PauseAreaKey = "PauseArea"
  
  // MARK: - Buttons
  static let LeftButtonKey = "LeftButton"
  static let RightButtonKey = "RightButton"
  static let GameStartButtonKey = "GameStartButton"
  static let RestartButton = "RestartButton"
  static let MenuButton = "MenuButton"
  static let DownButtonKey = "DownButton"
  static let RotateButtonKey = "RotateButton"
  static let PauseButtonKey = "PauseButton"
  
  /// Interval for a piece to drop by one cell in second.
  static let DefaultComplexity = 4
  
  static let HitSoundFileName = "hollow_thud.mp3"
  static let MoveSoundFileName = "soft-light.mp3"
  static let AdjustSoundFileName = "soft.mp3"
  static let GameStartSceneMusic = "background_music"
  static let GameSceneMusic = "game_music"
  
  static let TetrisCellTextureAtlasName = "TetrisCellTextures"
  static let TetrisCellTextureBaseName = "tetris_cell_texture_"
  
  static let GameStartButtonTappedTextureName = "triangle_tapped"
  
  static let ArenaMaskImageName = "arena_mask"
  
  /// Rules
  static let CurrentScoreKey = "CurrentScore"
  static let ProceedToNextLevelFact = "ProceedToNextLevel"
  static let NumScoreBeforeProceeding = 20
}
