//
//  SFIcons.swift
//  Tetris
//
//  Created by Willie Liwa Johnson on 10/25/22.
//  Copyright © 2022 Hanzhou Shi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

extension SKTexture {
  static let arrowClockwiseTexture = getSFIcon(SFIStrings.arrowClockwise).asSKTexture()
  static let arrowLeftTexture = getSFIcon(SFIStrings.arrowLeft).asSKTexture()
  static let arrowRightTexture = getSFIcon(SFIStrings.arrowRight).asSKTexture()
  static let arrowDownTexture = getSFIcon(SFIStrings.arrowDown).asSKTexture()
  static let playFillTexture = getSFIcon(SFIStrings.playFill).asSKTexture()
  static let playTexture = getSFIcon(SFIStrings.play).asSKTexture()
}

struct SFIStrings {
  static let arrowClockwise = "arrow.clockwise"
  static let arrowLeft = "arrow.left"
  static let arrowRight = "arrow.right"
  static let arrowDown = "arrow.down"
  static let play = "play"
  static let playFill = "play.fill"
}

func getSFIcon(_ name: String, color: UIColor = .white) -> UIImage {
  let config = UIImage.SymbolConfiguration(pointSize: 300)
  let image = UIImage(systemName: name, withConfiguration: config)!.withTintColor(color)
  let data = image.pngData()!
  let newImage = UIImage(data:data)!
  return newImage
}

extension UIImage {
  public func asSKTexture() -> SKTexture {
    return SKTexture(image: self)
  }
}
