//
//  DetailViewController.swift
//  AnimationDemo
//
//  Created by uwei on 28/10/2016.
//  Copyright © 2016 Tencent. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, CAAnimationDelegate{

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        animationWith(propterty: self.detailDescriptionLabel.text!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


    func animationWith(propterty:String) -> Void {
        if propterty == "bounds" {
            let basicAnimation = CABasicAnimation(keyPath: propterty)
            basicAnimation.delegate = self
            basicAnimation.fromValue = NSValue.init(cgRect: CGRect(x: self.detailDescriptionLabel.frame.origin.x, y: self.detailDescriptionLabel.frame.origin.y, width: self.detailDescriptionLabel.bounds.size.width, height: 100))
            basicAnimation.byValue  = NSValue.init(cgRect: self.detailDescriptionLabel.frame)
            basicAnimation.toValue  = NSValue.init(cgRect: CGRect(x: self.detailDescriptionLabel.frame.origin.x, y: self.detailDescriptionLabel.frame.origin.y, width: self.detailDescriptionLabel.bounds.size.width, height: 50))
            basicAnimation.duration = 1
            basicAnimation.repeatCount = 5
            basicAnimation.autoreverses = true
            basicAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
            // 决定代理方法的stop方法会不会被调用
            basicAnimation.isRemovedOnCompletion = false
            
            // 决定layer的represent是不是被保留， 当动画结束的时候
            basicAnimation.fillMode = kCAFillModeBackwards
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: propterty)
        } else if propterty == "position" {
            let keyframeAnimation = CAKeyframeAnimation(keyPath: propterty)
            keyframeAnimation.values = [NSValue.init(cgPoint:CGPoint(x:0, y:64)), NSValue.init(cgPoint:CGPoint(x:60, y:100)), NSValue.init(cgPoint:CGPoint(x:100, y:150)), NSValue.init(cgPoint:CGPoint(x:150, y:200)), NSValue.init(cgPoint:CGPoint(x:200, y:250)), NSValue.init(cgPoint:CGPoint(x:300, y:300))]
            if #available(iOS 8.0, *) {
                // Usually, the number of elements in the array should match the number of elements in the values property or the number of control points in the path property. If they do not, the timing of your animation might not be what you expect.
                keyframeAnimation.keyTimes = [NSNumber.init(value: 0.1), NSNumber.init(value: 0.3), NSNumber.init(value: 0.5), NSNumber.init(value: 0.7), NSNumber.init(value: 0.9), NSNumber.init(value: 1.0)]
            }
            keyframeAnimation.delegate = self
            keyframeAnimation.isRemovedOnCompletion = false
            keyframeAnimation.duration = 2
            keyframeAnimation.repeatCount = 2
            keyframeAnimation.autoreverses = true
            keyframeAnimation.timingFunctions = [CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)]
            self.detailDescriptionLabel.layer.add(keyframeAnimation, forKey: propterty)
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print(animationDidStart)
        if self.detailDescriptionLabel.layer.animation(forKey: "bounds") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.red
        } else if self.detailDescriptionLabel.layer.animation(forKey: "position") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.brown
        }
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.detailDescriptionLabel.layer.animation(forKey: "bounds") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "position") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        }
    }
}

