//
//  EsperantoDecoder.swift
//  Klavaroj
//
//  Created by John Pavley on 3/8/20.
//  Copyright © 2020 John Pavley. All rights reserved.
//

import Foundation

struct EsperantoDecoder {
  
  enum Signal: String {
    case c = "c"
    case g = "g"
    case h = "h"
    case j = "j"
    case s = "s"
    case u = "u"
    case x = "x"
    case unknown = "?"
  }
  
  static var code: [String: [Signal]] = [
    "ĉ" : [.c,.x],
    "ĝ" : [.g,.x],
    "ĥ" : [.h,.x],
    "ĵ" : [.j,.x],
    "ŝ" : [.s,.x],
    "û" : [.u,.x],
  ]
  
  static func letter(from signals: [Signal]) -> String? {
    return code.filter { $0.value == signals }.map { $0.key }.first
  }
  
}
