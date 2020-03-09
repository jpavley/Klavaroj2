//
//  EperantoKeyButton.swift
//  Klavaroj
//
//  Created by John Pavley on 3/9/20.
//  Copyright © 2020 John Pavley. All rights reserved.
//

import Foundation

import UIKit

class EsperantoKeyButton: UIButton {
  var defaultBackgroundColor: UIColor = .white
  var highlightBackgroundColor: UIColor = .lightGray

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
  }
}

// MARK: - Private Methods
private extension EsperantoKeyButton {
  func commonInit() {
    layer.cornerRadius = 5.0
    layer.masksToBounds = false
    layer.shadowOffset = CGSize(width: 0, height: 1.0)
    layer.shadowRadius = 0.0
    layer.shadowOpacity = 0.35
  }
}
