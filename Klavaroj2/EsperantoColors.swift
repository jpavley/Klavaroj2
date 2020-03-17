//
//  EsperantoColors.swift
//  Klavaroj
//
//  Created by John Pavley on 3/9/20.
//  Copyright © 2020 John Pavley. All rights reserved.
//

import UIKit

enum EsperantoColorScheme {
  case dark
  case light
}

struct EsperantoColors {
  let buttonTextColor: UIColor
  let buttonBackgroundColor: UIColor
  let buttonHighlightColor: UIColor
  let backgroundColor: UIColor

  init(colorScheme: EsperantoColorScheme) {
    switch colorScheme {
    case .light:
      buttonTextColor = .systemGreen
      buttonBackgroundColor = .systemBackground
      buttonHighlightColor = .systemBackground
      backgroundColor = .systemBackground
    case .dark:
      buttonTextColor = .systemGreen
      buttonBackgroundColor = .systemBackground
      buttonHighlightColor = .systemBackground
      backgroundColor = .systemBackground
    }
  }
}
