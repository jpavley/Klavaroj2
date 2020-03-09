//
//  EsperantoDecoderTests.swift
//  KlavarojTests
//
//  Created by John Pavley on 3/8/20.
//  Copyright © 2020 John Pavley. All rights reserved.
//

import XCTest

class EsperantoDecoderTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testLetterFromSignal() {
    XCTAssertEqual("ĉ", EsperantoDecoder.letter(from: [.c,.x]))
    XCTAssertEqual("ĝ", EsperantoDecoder.letter(from: [.g,.x]))
    XCTAssertEqual("ĥ", EsperantoDecoder.letter(from: [.h,.x]))
    XCTAssertEqual("ĵ", EsperantoDecoder.letter(from: [.j,.x]))
    XCTAssertEqual("ŝ", EsperantoDecoder.letter(from: [.s,.x]))
    XCTAssertEqual("û", EsperantoDecoder.letter(from: [.u,.x]))
  }
  
}
