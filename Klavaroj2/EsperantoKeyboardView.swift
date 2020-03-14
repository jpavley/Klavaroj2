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
  @IBOutlet var nextButtonWidthConstraint: NSLayoutConstraint! // unused
  @IBOutlet var mainStackLeadingConstraint: NSLayoutConstraint!
  @IBOutlet var mainStackTrailingConstraint: NSLayoutConstraint!
  @IBOutlet var keyButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet var leftOfZSpaceConstraint: NSLayoutConstraint!
  @IBOutlet var rightOfMSpaceConstraint: NSLayoutConstraint!
  
  weak var delegate: EsperantroKeyboardViewDelegate?
  var localTextCache = [String]()
  
  @IBAction func letterKeyTapped(_ sender: EsperantoKeyButton) {
    
    /// Return if label or letter is not available
    guard
      let label = sender.titleLabel,
      let letter = label.text?.lowercased()
      else { return }
    
    var secondToLastIndex = 0

    /// Returns true if letter is member of the special set (cghjsu)
    /// - Parameter letter: The character to be tested
    func isSpecial(_ letter: String) -> Bool {
      return "cghjsu".contains(letter)
    }
    
    /// Dictionary of specical characters and their replacements
    var subsitutes: [String: String] = [
      "c" : "ĉ",
      "g" : "ĝ",
      "h" : "ĥ",
      "j" : "ĵ",
      "s" : "ŝ",
      "u" : "û"
    ]
    
    /// Replaces a special sequence, like cx, with an accented character, like ĉ
    /// - Parameter letter: The special character to be subsituted
    /// - NOTE: Don't pass the whole sequence (cx), just the special charater (c)
    func subsitute(_ letter: String) {
      localTextCache = [String]()
      print("transformation", localTextCache)
      delegate?.deleteCharacterBeforeCursor()
      delegate?.deleteCharacterBeforeCursor()
      delegate?.insertCharacter(subsitutes[letter]!)
    }
    
    /// Inserts letter into `localTextCache` and `EsperantroKeyboardViewDelegate`
    /// - Parameter letter: The character represented by the keypress
    func processKeyPress(_ letter: String) {
      localTextCache.append(letter)
      print("insertion", localTextCache)
      delegate?.insertCharacter(letter)
      
      /// The index of the special character will always be the index before the "x"
      secondToLastIndex = localTextCache.count - 2
      
      if letter == "x" {
        /// The "x" is a signal that we might need to subsitute a special character...
        /// but only if there are at least 2 characters in the `localTextCache` and if
        /// the character before the "x" is a special character!
        if localTextCache.count >= 2 && isSpecial(localTextCache[secondToLastIndex]) {
          subsitute(localTextCache[secondToLastIndex])
        }
      }
    }
        
    processKeyPress(letter)
  }
    
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
      previewLabel.text = text
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setColorScheme(.dark)
    adjustKeyboard(false)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setColorScheme(.dark)
    adjustKeyboard(true)
  }
  
  func adjustKeyboard(_ visible: Bool) {
    nextKeyboardButton.isHidden = !visible
    
    let screenWidth = UIScreen.main.bounds.width
    
    // iPhone SE or smaller
    if screenWidth <= 320 {
      mainStackLeadingConstraint.constant = 0.0
      mainStackTrailingConstraint.constant = 0.0
    }
    
    // iPhone 8, 11 Pro
    if screenWidth == 375 {
      // don't do anything
    }
    
    // iPhone 11 Pro Max, 11 Pro, 11, 8 Plus
    if screenWidth >= 414 {
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
    
    for tag in 100...131 {
      if let button = viewWithTag(tag) as? EsperantoKeyButton {
        button.setTitleColor(colorScheme.buttonTextColor, for: [])
        button.tintColor = colorScheme.buttonTextColor
        
        if button == nextKeyboardButton || button == deleteButton
        || button == numberButton || button == returnButton
        || button == shiftButton {
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
  
  // TODO: func letterKeyLongPress()

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
    delegate?.insertCharacter(" ")
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

