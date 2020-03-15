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
  func text() -> String?
}

class EsperantoKeyboardView: UIView {
  
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
  var isShifted = false
  
  // TODO: Geet input from physical keyboard
  
  @IBAction func shiftKeyPressed(_ sender: EsperantoKeyButton) {
    isShifted = !isShifted
    updateShiftState()
  }
  
  @IBAction func letterKeyTapped(_ sender: EsperantoKeyButton) {
    
    /// Return if label or letter is not available
    guard
      let label = sender.titleLabel,
      let letter = label.text
      else { return }
    
    /// Dictionary of specical characters and their replacements
    var subsitutes: [String: String] = [
      "c" : "ĉ",
      "g" : "ĝ",
      "h" : "ĥ",
      "j" : "ĵ",
      "s" : "ŝ",
      "u" : "û",
      "C" : "Ĉ",
      "G" : "Ĝ",
      "H" : "Ĥ",
      "J" : "Ĵ",
      "S" : "Ŝ",
      "U" : "Û"
    ]
    
    /// The trigger character is used to signal a potential subsitution based on the character before the trigger
    let trigger = "x"
    
    /// Returns true if letter is member of the special set (cghjsu)
    /// - Parameter letter: The character to be tested
    func isSpecial(_ letter: String) -> Bool {
      return subsitutes.keys.contains(letter)
    }
    
    /// Replaces a special sequence, like cx, with an accented character, like ĉ
    /// - Parameter letter: The special character to be subsituted
    /// - NOTE: Don't pass the whole sequence (cx), just the special charater (c)
    func subsitute(_ letter: String) {
      localTextCache = [String]()
      delegate?.deleteCharacterBeforeCursor()
      delegate?.deleteCharacterBeforeCursor()
            
      delegate?.insertCharacter(subsitutes[letter]!)
    }
        
    /// Inserts letter into `localTextCache` and `EsperantroKeyboardViewDelegate`
    /// - Parameter letter: The character represented by the keypress
    func processKeyPress(_ letter: String) {
      localTextCache.append(letter)
      //print("insertion", localTextCache)
      let casedLetter = isShifted ? letter.uppercased() : letter.lowercased()
      delegate?.insertCharacter(casedLetter)
      
      /// The index of the special character will always be the index before the "x"
      let secondToLastIndex = localTextCache.count - 2
      
      if letter == trigger {
        /// The `trigger` is a signal that we might need to subsitute a special character...
        /// but only if there are at least 2 characters in the `localTextCache` and if
        /// the character before the `trigger` is a special character!
        if localTextCache.count >= 2 && isSpecial(localTextCache[secondToLastIndex]) {
          subsitute(localTextCache[secondToLastIndex])
        }
      }
      
      if isShifted {
        isShifted = !isShifted
        updateShiftState()
      }
    }
    
    processKeyPress(letter)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setColorScheme(.dark)
    adjustKeyboard(false)
    updateKeyCaps()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setColorScheme(.dark)
    adjustKeyboard(true)
    updateKeyCaps()
  }
  
  func updateKeyCaps() {
    for tag in 100...131 {
      
      /// Return if label or letter is not available
      guard
        let button = viewWithTag(tag) as? EsperantoKeyButton,
        let label = button.titleLabel,
        let letter = label.text
        else { return }
      
      if isShifted {
        button.setTitle(letter.uppercased(), for: .normal)
      } else {
        button.setTitle(letter.lowercased(), for: .normal)
      }
    }
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
  
  func updateShiftState() {
    let colors = EsperantoColors(colorScheme: .dark)
    setShiftKeyColor(colors)
    updateKeyCaps()
  }
  
  func setShiftKeyColor(_ colors: EsperantoColors) {
    if let button = viewWithTag(119) as? EsperantoKeyButton {
      if isShifted {
        button.defaultBackgroundColor = colors.buttonHighlightColor
        button.highlightBackgroundColor = colors.buttonBackgroundColor
      } else {
        button.defaultBackgroundColor = colors.buttonBackgroundColor
        button.highlightBackgroundColor = colors.buttonHighlightColor
      }
    }
  }
  
  func setColorScheme(_ colorScheme: EsperantoColorScheme) {
    let colorScheme = EsperantoColors(colorScheme: colorScheme)
    backgroundColor = colorScheme.backgroundColor
    
    // TODO: only modify cases of alphabetical keys
    
    for tag in 100...131 {
      if let button = viewWithTag(tag) as? EsperantoKeyButton {
        button.setTitleColor(colorScheme.buttonTextColor, for: [])
        button.tintColor = colorScheme.buttonTextColor
        
        if tag == 119 {
          setShiftKeyColor(colorScheme)
        }
        
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
  
  // TODO: func letterKeyLongPress()
  
  @IBAction func deletePressed() {
    delegate?.deleteCharacterBeforeCursor()
  }
  
  @IBAction func spacePressed() {
    delegate?.insertCharacter(" ")
  }
}
