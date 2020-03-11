//
//  EsperantoKeyboardView.swift
//  Klavaroj
//
//  Created by John Pavley on 3/9/20.
//  Copyright © 2020 John Pavley. All rights reserved.
//

import UIKit

protocol EsperantroKeyboardViewDelegate: class {
  func insertCharacter(_ newCharacter: String)
  func deleteCharacterBeforeCursor()
  func characterBeforeCursor() -> String?
}

class EsperantoKeyboardView: UIView {
  
  // top text label
  @IBOutlet var previewLabel: UILabel!
  
  // popup keys for accented letters
  @IBOutlet var LetterCButton: UIButton!
  @IBOutlet var LetterGButton: UIButton!
  @IBOutlet var LetterHButton: UIButton!
  @IBOutlet var LetterJButton: UIButton!
  @IBOutlet var LetterSButton: UIButton!
  @IBOutlet var LetterUButton: UIButton!
  
  // function keys
  @IBOutlet var shiftButton: UIButton!
  @IBOutlet var deleteButton: UIButton!
  @IBOutlet var nextKeyboardButton: UIButton!
  @IBOutlet var numberButton: UIButton!
  @IBOutlet var returnButton: UIButton!
  
  // button constraints
  @IBOutlet var nextButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet var mainStackLeadingConstraint: NSLayoutConstraint!
  @IBOutlet var mainStackTrailingConstraint: NSLayoutConstraint!
  @IBOutlet var keyButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet var leftOfZSpaceConstraint: NSLayoutConstraint!
  @IBOutlet var rightOfMSpaceConstraint: NSLayoutConstraint!

  
  weak var delegate: EsperantroKeyboardViewDelegate?
  
  var cacheLetter: String {
    return EsperantoDecoder.letter(from: signalCache) ?? "?"
  }
  
  var signalCache: [EsperantoDecoder.Signal] = [] {
    didSet {
      var text = ""
      if signalCache.count > 0 {
        text = signalCache.reduce("") {
          return $0 + $1.rawValue;
        }
        text += "= \(cacheLetter)"
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setColorScheme(.light)
    setNextKeyboardVisible(false)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setColorScheme(.light)
    setNextKeyboardVisible(false)
  }
  
  func setNextKeyboardVisible(_ visible: Bool) {
    nextKeyboardButton.isHidden = !visible
    
    // on an iPhone SE make as much room for the buttons as possible
    if UIDevice().name == "iPhone SE" {
      mainStackLeadingConstraint.constant = 0.0
      mainStackTrailingConstraint.constant = 0.0
    }
    
    // on a an iPhone 11 Pro Max make the buttons a bit wider
    if UIDevice().name == "iPhone 11 Pro Max" {
      keyButtonWidthConstraint.constant = 34
      leftOfZSpaceConstraint.constant = 3
      rightOfMSpaceConstraint.constant = 3
    }
  }
  
  func setColorScheme(_ colorScheme: EsperantoColorScheme) {
    let colorScheme = EsperantoColors(colorScheme: colorScheme)
    previewLabel.backgroundColor = colorScheme.previewBackgroundColor
    previewLabel.textColor = colorScheme.previewTextColor
    backgroundColor = colorScheme.backgroundColor
    
    for view in subviews {
      if let button = view as? EsperantoKeyButton {
        button.setTitleColor(colorScheme.buttonTextColor, for: [])
        button.tintColor = colorScheme.buttonTextColor
        
        if button == nextKeyboardButton || button == deleteButton
        || button == numberButton || button == returnButton {
          button.defaultBackgroundColor = colorScheme.buttonHighlightColor
          button.highlightBackgroundColor = colorScheme.buttonBackgroundColor
        } else {
          button.defaultBackgroundColor = colorScheme.buttonBackgroundColor
          button.highlightBackgroundColor = colorScheme.buttonHighlightColor
        }
      }
    }
  }
}

// MARK: - Actions
extension EsperantoKeyboardView {
  @IBAction func dotPressed(button: UIButton) {
    addSignal(.c)
  }

  @IBAction func dashPressed() {
    addSignal(.x)
  }

  @IBAction func deletePressed() {
    if signalCache.count > 0 {
      // Remove last signal
      signalCache.removeLast()
    } else {
      // Already didn't have a signal
      if let previousCharacter = delegate?.characterBeforeCursor() {
        if let previousSignals = EsperantoDecoder.code["\(previousCharacter)"] {
          signalCache = previousSignals
        }
      }
    }

    if signalCache.count == 0 {
      // Delete because no more signal
      delegate?.deleteCharacterBeforeCursor()
    } else {
      // Building on existing letter by deleting current
      delegate?.deleteCharacterBeforeCursor()
      delegate?.insertCharacter(cacheLetter)
    }
  }

  @IBAction func spacePressed() {
    if signalCache.count > 0 {
      // Clear our the signal cache
      signalCache = []
    } else {
      delegate?.insertCharacter(" ")
    }
  }
}

// MARK: - Private Methods
private extension EsperantoKeyboardView {
  func addSignal(_ signal: EsperantoDecoder.Signal) {
    if signalCache.count == 0 {
      // Have an empty cache
      signalCache.append(signal)
      delegate?.insertCharacter(cacheLetter)
    } else {
      // Building on existing letter
      signalCache.append(signal)
      delegate?.deleteCharacterBeforeCursor()
      delegate?.insertCharacter(cacheLetter)
    }
  }
}

