//
//  EsperantoAlphabetTests.swift
//  KlavarojTests
//
//  Created by John Pavley on 3/7/20.
//  Copyright © 2020 John Pavley. All rights reserved.
//

import XCTest

class EsperantoAlphabetTests: XCTestCase {
  
  let esperantoAlphabetUpperCase = "ABCĈDEFGĜHĤIJĴKLMNOPRSŜTUÛVZ"
  let esperantoAlphabetLowerCase = "abcĉdefgĝhĥijĵklmnoprsŝtuûvz"
  let letterCount = 28

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testLetterCount() {
    XCTAssertEqual(letterCount, EsperantoAlphabet.lowerCaseLetters.count)
  }
  
  func testLettersLowerCase() {
    
    print("===")
    print(EsperantoAlphabet.lowerCaseLetters)
    print("===")
    XCTAssertEqual(esperantoAlphabetLowerCase, EsperantoAlphabet.lowerCaseLetters)
  }
  
  func testLettersUpperCase() {
    
    print("===")
    print(EsperantoAlphabet.lowerCaseLetters.uppercased())
    print("===")
    XCTAssertEqual(esperantoAlphabetUpperCase, EsperantoAlphabet.lowerCaseLetters.uppercased())
  }
  
  func testLookupEachLetter() {
    XCTAssertEqual(["a"], EsperantoAlphabet.lookup("a"))
    XCTAssertEqual(["b"], EsperantoAlphabet.lookup("b"))
    XCTAssertEqual(["c", "ĉ"], EsperantoAlphabet.lookup("c"))
    XCTAssertEqual(["d"], EsperantoAlphabet.lookup("d"))
    XCTAssertEqual(["e"], EsperantoAlphabet.lookup("e"))
    XCTAssertEqual(["f"], EsperantoAlphabet.lookup("f"))
    XCTAssertEqual(["g", "ĝ"], EsperantoAlphabet.lookup("g"))
    XCTAssertEqual(["h", "ĥ"], EsperantoAlphabet.lookup("h"))
    XCTAssertEqual(["i"], EsperantoAlphabet.lookup("i"))
    XCTAssertEqual(["j", "ĵ"], EsperantoAlphabet.lookup("j"))
    XCTAssertEqual(["k"], EsperantoAlphabet.lookup("k"))
    XCTAssertEqual(["l"], EsperantoAlphabet.lookup("l"))
    XCTAssertEqual(["m"], EsperantoAlphabet.lookup("m"))
    XCTAssertEqual(["n"], EsperantoAlphabet.lookup("n"))
    XCTAssertEqual(["o"], EsperantoAlphabet.lookup("o"))
    XCTAssertEqual(["p"], EsperantoAlphabet.lookup("p"))
    XCTAssertEqual(["r"], EsperantoAlphabet.lookup("r"))
    XCTAssertEqual(["s", "ŝ"], EsperantoAlphabet.lookup("s"))
    XCTAssertEqual(["t"], EsperantoAlphabet.lookup("t"))
    XCTAssertEqual(["u", "û"], EsperantoAlphabet.lookup("u"))
    XCTAssertEqual(["v"], EsperantoAlphabet.lookup("v"))
    XCTAssertEqual(["z"], EsperantoAlphabet.lookup("z"))
  }
  
  func testLookupLettersByX() {
    XCTAssertEqual(["ĉ"], EsperantoAlphabet.lookup("cx"))
    XCTAssertEqual(["ĝ"], EsperantoAlphabet.lookup("gx"))
    XCTAssertEqual(["ĥ"], EsperantoAlphabet.lookup("hx"))
    XCTAssertEqual(["ĵ"], EsperantoAlphabet.lookup("jx"))
    XCTAssertEqual(["ŝ"], EsperantoAlphabet.lookup("sx"))
    XCTAssertEqual(["û"], EsperantoAlphabet.lookup("ux"))

    
  }

  
}
