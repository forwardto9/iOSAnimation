//
//  TiledView.swift
//  AnimationDemo
//
//  Created by uwei on 2018/10/24.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit
import QuartzCore

class TiledView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override class var layerClass : AnyClass {
        return CATiledLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clear;
        (self.layer as! CATiledLayer).tileSize = CGSize(width: 100 * self.contentScaleFactor, height: 100 * self.contentScaleFactor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        let rect = ctx.boundingBoxOfClipPath
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.addRect(CGRect(x: rect.origin.x + 2, y: rect.origin.y + 2, width: rect.size.width - 4, height: rect.size.height - 4))
        ctx.fillPath()
    }
    
}
