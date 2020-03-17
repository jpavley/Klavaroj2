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
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    let minY = bounds.minY + 4.0
    let maxY = bounds.maxY - 4.0

    let minX = bounds.minX + 3.0
    let maxX = bounds.maxX - 3.0
    
    context.setStrokeColor(UIColor.systemGreen.cgColor)
    context.setLineWidth(0.5)
    context.move(to: CGPoint(x: minX, y: maxY))
    context.addLine(to: CGPoint(x: maxX, y: maxY))
    context.addLine(to: CGPoint(x: maxX, y: minY))
    context.addLine(to: CGPoint(x: minX, y: minY))
    context.addLine(to: CGPoint(x: minX, y: maxY))

    context.strokePath()
    
    let y2 = bounds.maxY - 8.0
    context.setStrokeColor(UIColor.systemGreen.cgColor)
    context.setLineWidth(0.5)
    context.move(to: CGPoint(x: minX, y: y2))
    context.addLine(to: CGPoint(x: maxX, y: y2))
    context.strokePath()

  }
}

// MARK: - Private Methods
private extension EsperantoKeyButton {
  func commonInit() {
//    print("\(titleLabel!.text!)\(self.frame)")
//    frame = frame.insetBy(dx: 6, dy: 6)
//    print("\(titleLabel!.text!)\(self.frame)")
  
//    layer.cornerRadius = 5.0
//    layer.masksToBounds = false
//    layer.shadowOffset = CGSize(width: 0, height: 1.0)
//    layer.shadowRadius = 0.0
//    layer.shadowOpacity = 0.35
  }
}
