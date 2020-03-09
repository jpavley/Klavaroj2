//
//  EsperantoAlphabet.swift
//  Klavaroj
//
//  Created by John Pavley on 3/7/20.
//  Copyright © 2020 John Pavley. All rights reserved.
//

import Foundation

struct EsperantoAlphabet {
  
  static var letters: [String: [String]] = [
    "a": ["a"],
    "b": ["b"],
    "c": ["c", "ĉ"],
    "d": ["d"],
    "e": ["e"],
    "f": ["f"],
    "g": ["g", "ĝ"],
    "h": ["h", "ĥ"],
    "i": ["i"],
    "j": ["j", "ĵ"],
    "k": ["k"],
    "l": ["l"],
    "m": ["m"],
    "n": ["n"],
    "o": ["o"],
    "p": ["p"],
    "r": ["r"],
    "s": ["s", "ŝ"],
    "t": ["t"],
    "u": ["u", "û"],
    "v": ["v"],
    "z": ["z"],
    "cx": ["ĉ"],
    "gx": ["ĝ"],
    "hx": ["ĥ"],
    "jx": ["ĵ"],
    "sx": ["ŝ"],
    "ux": ["û"]
  ]
  
  static var lowerCaseLetters: String {
    var list = [String]()
    for letter in EsperantoAlphabet.letters {
      for value in letter.value {
        list.append(value)
      }
    }
    
    let listDeduped = Array(Set(list))
    
    let sortedList = listDeduped.sorted {
      $0.localizedStandardCompare($1) == .orderedAscending
    }
    
    return sortedList.joined()
  }
  
  static func lookup(_ key: String) -> [String]? {
    return EsperantoAlphabet.letters[key]
  }
  
  
}


