//
//  DetailViewController.swift
//  AnimationDemo
//
//  Created by uwei on 28/10/2016.
//  Copyright © 2016 Tencent. All rights reserved.
//

import UIKit
import CoreGraphics

class DetailViewController: UIViewController, CAAnimationDelegate{

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    fileprivate var tipsLabel:UILabel!


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
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationWith(propterty: self.detailDescriptionLabel.text!)
        // anchorPoint 公式
        // frame.orign.x = position.x - anchorPoint.x * bounds.size.width
        // frmae.orign.y = position.y - anchorPoint.y * bounds.size.height
//        UIView.animate(withDuration: 3, delay: 2, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            self.detailDescriptionLabel.layer.anchorPoint = CGPoint(x: 1, y: 1)
//        }) { (result) in
            //
//            print(result)
//        }
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
            // 对于CABasicAnimation类来说，是一个简单的最多3帧的动画，即fromValue，byValue，toValue
            basicAnimation.fromValue = NSValue.init(cgRect: CGRect(x: self.detailDescriptionLabel.frame.origin.x, y: self.detailDescriptionLabel.frame.origin.y, width: self.detailDescriptionLabel.bounds.size.width, height: 100))
            basicAnimation.byValue  = NSValue.init(cgRect: self.detailDescriptionLabel.frame)
            basicAnimation.toValue  = NSValue.init(cgRect: CGRect(x: self.detailDescriptionLabel.frame.origin.x, y: self.detailDescriptionLabel.frame.origin.y, width: self.detailDescriptionLabel.bounds.size.width, height: 50))
            
            // CAMediaTiming协议，决定动画的时长，单位是s
            basicAnimation.duration = 10
            // CAMediaTiming协议, 决定动画对象相对于它的父节点开始的时间,动画的总时长是duration + beginTime
            basicAnimation.beginTime = CACurrentMediaTime() + 1
            // CAMediaTiming协议, 指定额外的时间偏移，相对于激活的本地时间，设置了这个值之后，动画的声誉时间是duration - timeOffset,并且，动画执行了duration，但是动画效果是先从duration - timeOffset开始，最后才会播放timeOffset部分的动画
            basicAnimation.timeOffset = 3.5
            // CAMediaTiming 协议，决定动画重复的次数
            basicAnimation.repeatCount = 5
            // CAMediaTiming协议，决定动画的重复播放的时间,单位是s，如果同时指定了repeatCount的话，动画的行为就尴尬了
//            basicAnimation.repeatDuration = 0.5
            
            // CAMediaTiming协议，决定动画的完成时，是不是平滑的回放
            basicAnimation.autoreverses = true
            // CAMediaTiming协议，决定layer的represent是不是被保留， 当动画结束的时候
            basicAnimation.fillMode = kCAFillModeBackwards
            
            // CAMediaTiming协议，决定动画结束之后，动画接收者的representation是不是被冻结或者是被清除
            basicAnimation.fillMode = kCAFillModeBackwards
            // CAMediaTiming 协议， 指定动画时间如何从接收者时间空间到它的父节点的时间空间的映射,default 1.0,速度有相对的参照物，父节点就是这个意思
            basicAnimation.speed = 10
            /**********以上关于time的解释，http://www.cocoachina.com/programmer/20131218/7569.html 这篇文章挺好**********/
            
            // CAAnimation类的属性，指定动画的pace
            basicAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
            // CAAnimation类的属性，决定代理方法的stop方法会不会被调用
            basicAnimation.isRemovedOnCompletion = false
            
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: propterty)
        } else if propterty == "position" {
            let keyframeAnimation = CAKeyframeAnimation(keyPath: propterty)
            
            keyframeAnimation.delegate = self
            keyframeAnimation.isRemovedOnCompletion = false
            keyframeAnimation.duration = 2
            keyframeAnimation.repeatCount = 2
            keyframeAnimation.autoreverses = true
            
            // CAKeyframeAnimation类的属性，用来指定动画中要显示的keyframe的值
            keyframeAnimation.values = [NSValue.init(cgPoint:CGPoint(x:0, y:64)),
                                        NSValue.init(cgPoint:CGPoint(x:60, y:100)),
                                        NSValue.init(cgPoint:CGPoint(x:100, y:150)),
                                        NSValue.init(cgPoint:CGPoint(x:150, y:200)),
                                        NSValue.init(cgPoint:CGPoint(x:200, y:250)),
                                        NSValue.init(cgPoint:CGPoint(x:300, y:300))]
            
            // CAKeyframeAnimation类的属性，指定如何计算中间的keyframe
            keyframeAnimation.calculationMode = kCAAnimationDiscrete
            if #available(iOS 8.0, *) {
                // CAKeyframeAnimation类的属性，用来指定keyframe的segment的时间点，取值0-1，calculationMode影响着这个属性的有效性，且keyTimes.count >= values.count + 1
                // Usually, the number of elements in the array should match the number of elements in the values property or the number of control points in the path property. If they do not, the timing of your animation might not be what you expect.
                let v0 = NSNumber.init(value: 0.0)
                let v1 = NSNumber.init(value: 0.1)
                let v2 = NSNumber.init(value: 0.3)
                let v3 = NSNumber.init(value: 0.5)
                let v4 = NSNumber.init(value: 0.7)
                let v5 = NSNumber.init(value: 0.9)
                let v6 = NSNumber.init(value: 1.0)
                // XCode8.0编译器报错
//                keyframeAnimation.keyTimes = [NSNumber.init(value: 0.0),
//                                              NSNumber.init(value: 0.1),
//                                              NSNumber.init(value: 0.3),
//                                              NSNumber.init(value: 0.5),
//                                              NSNumber.init(value: 0.7),
//                                              NSNumber.init(value: 0.9),
//                                              NSNumber.init(value: 1.0)]
                keyframeAnimation.keyTimes = [v0, v1, v2, v3, v4, v5, v6]
            }
            // CAKeyframeAnimation类的属性，用来指定每个segment的pace
            //  If the number of keyframes in the values property is n, then this property should contain n-1 objects.
            // 如果设置了timingFunction属性，那么会首先执行，然后紧接着才会执行这个数组中的时间函数
            keyframeAnimation.timingFunctions = [CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)]
            self.detailDescriptionLabel.layer.add(keyframeAnimation, forKey: propterty)
        } else if propterty == "frame" {
            let basicAnimation = CABasicAnimation(keyPath: propterty)
            basicAnimation.delegate = self
            basicAnimation.fromValue = NSValue.init(cgRect: CGRect(x: 10, y: 100, width: self.detailDescriptionLabel.bounds.size.width, height: 100))
            basicAnimation.byValue  = NSValue.init(cgRect: self.detailDescriptionLabel.frame)
            basicAnimation.toValue  = NSValue.init(cgRect: CGRect(x: 10, y: 200, width: self.detailDescriptionLabel.bounds.size.width, height: 50))
            basicAnimation.duration = 5
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: propterty)
            tips(info: (propterty + " " + "computed from the bounds and position, so it is not animatable"))
        } else if propterty == "anchorPoint" {
            let basicAnimation = CABasicAnimation(keyPath: propterty)
            basicAnimation.delegate = self
            basicAnimation.duration = 3
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            basicAnimation.fromValue = NSValue.init(cgPoint: CGPoint(x: 0, y: 0))
            basicAnimation.byValue   = NSValue.init(cgPoint: CGPoint(x: 0.5, y: 0.5))
            basicAnimation.toValue   = NSValue.init(cgPoint: CGPoint(x: 1, y: 1))
            
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey:propterty)
            
            tips(info: (propterty + " " + "is used to compute frame.orign, so it is not animatable"))
        } else if propterty == "cornerRadius" {
            let basicAnimation = CABasicAnimation(keyPath: propterty)
            basicAnimation.delegate = self
            basicAnimation.duration = 3
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            basicAnimation.fromValue = NSNumber(value: 0)
            basicAnimation.byValue   = NSNumber(value: Float(self.detailDescriptionLabel.bounds.size.height/2))
            basicAnimation.toValue   = NSNumber(value: Float(self.detailDescriptionLabel.bounds.size.height/2 + 20))
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: propterty)
        } else if propterty == "transform" { // MARK:- anchorPoint property is crutail to transform
            
            let translationXButton = UIButton(type: .custom)
            translationXButton.frame = CGRect(x: 0, y: 64, width: 200, height: 44)
            translationXButton.backgroundColor = UIColor.darkText
            translationXButton.setTitle((propterty + "." + "translation.x"), for: .normal)
            translationXButton.addTarget(self, action: #selector(DetailViewController.translationXAnimation), for: .touchUpInside)
            self.view.addSubview(translationXButton)
            
            let rotationYButton = UIButton(type: .custom)
            rotationYButton.frame = CGRect(x: 0, y: 108, width: 200, height: 44)
            rotationYButton.backgroundColor = UIColor.darkText
            rotationYButton.setTitle((propterty + "." + "rotation.y"), for: .normal)
            rotationYButton.addTarget(self, action: #selector(DetailViewController.rotationYAnimation), for: .touchUpInside)
            self.view.addSubview(rotationYButton)
            
            let scaleXButton = UIButton(type: .custom)
            scaleXButton.frame = CGRect(x: 0, y: 152, width: 200, height: 44)
            scaleXButton.backgroundColor = UIColor.darkText
            scaleXButton.setTitle((propterty + "." + "scale.x"), for: .normal)
            scaleXButton.addTarget(self, action: #selector(DetailViewController.scaleXAnimation), for: .touchUpInside)
            self.view.addSubview(scaleXButton)
            
            // MARK: - CAAnimationGroup allows multiple animations to be grouped and run concurrently
//            let animationGroup = CAAnimationGroup()
        } else if propterty == "zPosition" {
            
            let layer1 = CAShapeLayer()
            let path = CGMutablePath()
            path.addEllipse(in: CGRect(x: 0, y: 64, width: 100, height: 300))
            layer1.path = path
            layer1.fillColor = UIColor.purple.cgColor
            layer1.zPosition = 100
            
            
            let layer2 = CAShapeLayer()
            let path2 = CGMutablePath()
            path2.addEllipse(in: CGRect(x: 0, y: 64, width: 100, height: 300))
            layer2.path = path
            layer2.fillColor = UIColor.cyan.cgColor
            layer2.zPosition = -100
            
            self.view.layer.addSublayer(layer1)
            self.view.layer.addSublayer(layer2)
            
            var transformIdentity = CATransform3DIdentity
            transformIdentity.m34 = -1/700
            transformIdentity = CATransform3DRotate(transformIdentity, CGFloat(M_PI/3), 0, 1, 0)
            self.view.layer.sublayerTransform = transformIdentity
            
            let keyframeAnimation = CAKeyframeAnimation(keyPath: propterty)
            keyframeAnimation.delegate = self
            keyframeAnimation.duration = 2
            keyframeAnimation.repeatCount = 3
            keyframeAnimation.isRemovedOnCompletion = false
            keyframeAnimation.autoreverses = true
            keyframeAnimation.values = [NSNumber.init(value: -100), NSNumber.init(value: 0), NSNumber.init(value: 50), NSNumber.init(value: 150)]
            keyframeAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
            
            self.detailDescriptionLabel.layer.add(keyframeAnimation, forKey: propterty)
            layer2.add(keyframeAnimation, forKey: propterty)
            
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print(animationDidStart)
        if self.detailDescriptionLabel.layer.animation(forKey: "bounds") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.red
        } else if self.detailDescriptionLabel.layer.animation(forKey: "position") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.brown
        } else if self.detailDescriptionLabel.layer.animation(forKey: "frame") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.yellow
        } else if self.detailDescriptionLabel.layer.animation(forKey: "anchorPoint") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.brown
        } else if self.detailDescriptionLabel.layer.animation(forKey: "cornerRadius") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.gray
        } else if self.detailDescriptionLabel.layer.animation(forKey: "transform") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.orange
        } else if self.detailDescriptionLabel.layer.animation(forKey: "zPosition") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.lightGray
        }
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.detailDescriptionLabel.layer.animation(forKey: "bounds") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "position") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "frame") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
            removeTips()
        } else if self.detailDescriptionLabel.layer.animation(forKey: "anchorPoint") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "cornerRadius") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "transform") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "zPosition") == anim { // TODO:- why not call?
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        }
        self.detailDescriptionLabel.layer.removeAllAnimations()
    }
    
    func tips(info:String) -> Void {
        tipsLabel = UILabel()
        tipsLabel.backgroundColor = UIColor.lightGray
        tipsLabel.textColor = UIColor.red
        tipsLabel.numberOfLines = 10
        tipsLabel.lineBreakMode = .byWordWrapping
        tipsLabel.textAlignment = .center
        tipsLabel.text          = info
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tipsLabel)
        let constraintWidth = NSLayoutConstraint.init(item: tipsLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute:NSLayoutAttribute.init(rawValue: 0)!, multiplier: 1.0, constant: 300)
        let constaintHeight = NSLayoutConstraint.init(item: tipsLabel, attribute: .height, relatedBy: .equal, toItem: nil
            , attribute: NSLayoutAttribute.init(rawValue: 0)!, multiplier: 1.0, constant: 100)
        
        tipsLabel.addConstraints([constraintWidth, constaintHeight])
        let constraintX = NSLayoutConstraint.init(item: tipsLabel, attribute: .centerX, relatedBy: .equal, toItem: tipsLabel.superview, attribute: .centerX, multiplier: 1.0, constant: 0)
        let constraintY = NSLayoutConstraint.init(item: tipsLabel, attribute: .top, relatedBy: .equal, toItem: detailDescriptionLabel, attribute: .bottom, multiplier: 1.0, constant: 20)
        self.view.addConstraints([constraintX, constraintY])
    }
    func removeTips() -> Void {
        tipsLabel.removeFromSuperview()
    }
    
    func translationXAnimation() -> Void { // "translation" must be nsvalue with NSSize or CGSize,it indicate x and y axis
        self.detailDescriptionLabel.layer.removeAllAnimations()
        let animationTranslationX = CABasicAnimation(keyPath: "transform.translation.x")
        animationTranslationX.delegate = self
        animationTranslationX.duration = 3
        animationTranslationX.repeatCount = 2
        animationTranslationX.autoreverses = true
        animationTranslationX.isRemovedOnCompletion = false
        
        animationTranslationX.fromValue = NSNumber(value: -50)
        animationTranslationX.byValue   = NSNumber(value: 0)
        animationTranslationX.toValue   = NSNumber(value: 50)
        
        self.detailDescriptionLabel.layer.add(animationTranslationX, forKey: "transform")
    }
    
    func rotationYAnimation() -> Void { //  "rotation" is identical to setting "rotation.z"
        self.detailDescriptionLabel.layer.removeAllAnimations()
        let animationRotationX = CABasicAnimation(keyPath: "transform.rotation.y")
        animationRotationX.delegate = self
        animationRotationX.duration = 3
        animationRotationX.repeatCount = 2
        animationRotationX.isRemovedOnCompletion = false
        animationRotationX.autoreverses = true
        animationRotationX.fromValue = NSNumber(value: 0)
        animationRotationX.byValue   = NSNumber(value: M_PI_4)
        animationRotationX.toValue   = NSNumber(value: M_PI/3)
        self.detailDescriptionLabel.layer.add(animationRotationX, forKey: "transform")
    }
    
    func scaleXAnimation() -> Void { // "scale" is the average for all three(x,y,z) scale factors
        self.detailDescriptionLabel.layer.removeAllAnimations()
        let animationScaleX = CABasicAnimation(keyPath: "transform.scale.x")
        animationScaleX.delegate = self
        animationScaleX.duration = 3
        animationScaleX.repeatCount = 2
        animationScaleX.isRemovedOnCompletion = false
        animationScaleX.autoreverses = true
        
        animationScaleX.fromValue = NSNumber(value: 1)
        animationScaleX.toValue   = NSNumber(value: 5)
        self.detailDescriptionLabel.layer.add(animationScaleX, forKey: "transform")
    }
}

