//
//  ViewController.swift
//  Klavaroj2
//
//  Created by John Pavley on 3/9/20.
//  Copyright © 2020 John Pavley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var textField: UITextField!
  @IBOutlet var instructionsTextView: UITextView!
  @IBOutlet var textFieldBottomConstraint: NSLayoutConstraint!
  
  var esperantoKeyboardView: EsperantoKeyboardView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
        
    // Add an observer so that we can adjust the UI when the keyboard is showing
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    // Add an observer to know when app comes to foreground to update UI
    NotificationCenter.default.addObserver(self, selector: #selector(reloadViews), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    // Add KVO for textfield to determine when cursor moves
    textField.addObserver(self, forKeyPath: "selectedTextRange", options: .new, context: nil)

    //esperantoKeyboardView.setNextKeyboardVisible(false)
  }
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      
    // Set keyboard view to input view of text field
    let nib = UINib(nibName: "EsperantoKeyboardView", bundle: nil)
    let objects = nib.instantiate(withOwner: nil, options: nil)
    esperantoKeyboardView = objects.first as? EsperantoKeyboardView
    esperantoKeyboardView.delegate = self
    
    let bottomPadding = view.safeAreaInsets.bottom
    let keyboardFrameHeight = esperantoKeyboardView.frame.height
    let keyboardFrameWidth = esperantoKeyboardView.frame.width
    esperantoKeyboardView.frame = CGRect(x: 0.0, y: 0.0, width: keyboardFrameWidth, height: keyboardFrameHeight + bottomPadding)
    
    // Add the keyboard to a container view so that it's sized correctly
    let keyboardContainerView = UIView(frame: esperantoKeyboardView.frame)
    keyboardContainerView.addSubview(esperantoKeyboardView)
    textField.inputView = keyboardContainerView
    textField.becomeFirstResponder()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    textField.removeObserver(self, forKeyPath: "selectedTextRange")
  }
}

// MARK: - Observers
extension ViewController {
  @objc func reloadViews() {
    // Start the app with the keyboard showing
    //textField.becomeFirstResponder()
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    
    guard
      let userInfo = notification.userInfo,
      let keyboardHeight = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height,
      let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
      else {
        return
    }
    
    let bottomPadding = view.safeAreaInsets.bottom
    
    textFieldBottomConstraint.constant = -(keyboardHeight - bottomPadding + 4)
    UIView.animate(withDuration: animationDurarion) {
      self.view.layoutIfNeeded()
    }
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "selectedTextRange" {
      // Clear out the current signal as the cursor placement changed
      // esperantoKeyboardView.signalCache = []
      esperantoKeyboardView.localTextCache = [String]()
    }
  }
}

// MARK: - Private Methods
private extension ViewController {
  
}

// MARK: - EsperantroKeyboardViewDelegate
extension ViewController: EsperantroKeyboardViewDelegate  {
  
  func text() -> String? {
    return textField.text
  }
  
  /// Insert character after the textfield cursor
  func insertCharacter(_ newCharacter: String) {
    textField.insertText(newCharacter)
  }
  
  /// Delete character before textfield cursor
  func deleteCharacterBeforeCursor() {
    textField.deleteBackward()
  }
  
  /// Provide the delegate with the character before the cursor
  func characterBeforeCursor() -> String? {
    // get the cursor position
    if let cursorRange = textField.selectedTextRange {
      // get the position one character before the cursor start position
      if let newPosition = textField.position(from: cursorRange.start, offset: -1), let range = textField.textRange(from: newPosition, to: cursorRange.start) {
        return textField.text(in: range)
      }
    }
    return nil
  }
}


