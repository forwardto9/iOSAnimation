//
//  DetailViewController.swift
//  AnimationDemo
//
//  Created by uwei on 28/10/2016.
//  Copyright © 2016 Tencent. All rights reserved.
//

import UIKit
import CoreGraphics

class DetailViewController: UIViewController, CAAnimationDelegate, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    fileprivate var tipsLabel:UILabel!
    fileprivate var  dynamicAnimator:UIDynamicAnimator!


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
        animationWith(property: self.detailDescriptionLabel.text!)
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


    func animationWith(property:String) -> Void {
        if property == "bounds" {
            let basicAnimation = CABasicAnimation(keyPath: property)
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
            
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: property)
        } else if property == "position" {
            let keyframeAnimation = CAKeyframeAnimation(keyPath: property)
            
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
            self.detailDescriptionLabel.layer.add(keyframeAnimation, forKey: property)
        } else if property == "frame" {
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.fromValue = NSValue.init(cgRect: CGRect(x: 10, y: 100, width: self.detailDescriptionLabel.bounds.size.width, height: 100))
            basicAnimation.byValue  = NSValue.init(cgRect: self.detailDescriptionLabel.frame)
            basicAnimation.toValue  = NSValue.init(cgRect: CGRect(x: 10, y: 200, width: self.detailDescriptionLabel.bounds.size.width, height: 50))
            basicAnimation.duration = 5
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: property)
            tips(info: (property + " " + "computed from the bounds and position, so it is not animatable"))
        } else if property == "anchorPoint" {
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 3
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            basicAnimation.fromValue = NSValue.init(cgPoint: CGPoint(x: 0, y: 0))
            basicAnimation.byValue   = NSValue.init(cgPoint: CGPoint(x: 0.5, y: 0.5))
            basicAnimation.toValue   = NSValue.init(cgPoint: CGPoint(x: 1, y: 1))
            
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey:property)
            tips(info: "this is a test line")
        } else if property == "cornerRadius" {
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 3
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            basicAnimation.fromValue = NSNumber(value: 0)
            basicAnimation.byValue   = NSNumber(value: Float(self.detailDescriptionLabel.bounds.size.height/2))
            basicAnimation.toValue   = NSNumber(value: Float(self.detailDescriptionLabel.bounds.size.height/2 + 20))
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: property)
        } else if property == "transform" { // MARK:- anchorPoint property is crutail to transform
            
            self.view.backgroundColor = UIColor.lightGray
            // MARK: - CAAnimationGroup allows multiple animations to be grouped and run concurrently
//            let animationGroup = CAAnimationGroup()
            var transformIdentity = CATransform3DIdentity // 左乘矩阵
            print(transformIdentity)
            
            // m41,m42,m43用来平移
//            transformIdentity.m41 = 100
//            transformIdentity.m42 = 100
            
            // m11, m22, m33,是用来缩放的
//            transformIdentity.m11 = 0.5
//            transformIdentity.m22 = 0.5
            
            // m22, m23, m32, m33 是用来绕X轴旋转
            let delta = degreeToRadius(degree: 90)
//            transformIdentity.m22 = cos(CGFloat(delta))
//            transformIdentity.m23 = sin(CGFloat(delta))
//            transformIdentity.m32 = -sin(CGFloat(delta))
//            transformIdentity.m33 = cos(CGFloat(delta))
            
            // m11, m13, m31, m33 是用来绕Y轴旋转
//            transformIdentity.m11 = cos(CGFloat(delta))
//            transformIdentity.m13 = -sin(CGFloat(delta))
//            transformIdentity.m31 = sin(CGFloat(delta))
//            transformIdentity.m33 = cos(CGFloat(delta))
            // m11, m12, m21, m22 是用来绕Z轴旋转
            transformIdentity.m11 = cos(CGFloat(delta))
            transformIdentity.m12 = sin(CGFloat(delta))
            transformIdentity.m21 = -sin(CGFloat(delta))
            transformIdentity.m22 = cos(CGFloat(delta))
            
            print(transformIdentity)
            
//            self.view.layer.transform = transformIdentity
            
            let basciAnimation = CABasicAnimation(keyPath: property)
            basciAnimation.delegate = self
            basciAnimation.duration = 2
            basciAnimation.repeatCount = 3
            basciAnimation.isRemovedOnCompletion = false
            basciAnimation.autoreverses = true
            
            basciAnimation.fromValue = CATransform3DIdentity
            basciAnimation.toValue   = transformIdentity
            
            self.view.layer.add(basciAnimation, forKey: property)
            // 使用以下方法可以改变变换矩阵，变换矩阵是用来左乘向量，从而达到修改向量的目的
            // 使用CATransform3D函数
            // 直接修改数据结构的成员
            // 使用键-值编码改变键路径
            // 关于变换矩阵的介绍可以参照：http://blog.csdn.net/forwardto9/article/details/9468719
            
            // 以下是改变键路径的Demo
            let translationXButton = UIButton(type: .custom)
            translationXButton.frame = CGRect(x: self.view.bounds.size.width/2 - 100, y: 64, width: 200, height: 44)
            translationXButton.backgroundColor = UIColor.darkText
            translationXButton.setTitle((property + "." + "translation.x"), for: .normal)
            translationXButton.addTarget(self, action: #selector(DetailViewController.translationXAnimation), for: .touchUpInside)
            self.view.addSubview(translationXButton)
            
            let rotationYButton = UIButton(type: .custom)
            rotationYButton.frame = CGRect(x: self.view.bounds.size.width/2 - 100, y: 108, width: 200, height: 44)
            rotationYButton.backgroundColor = UIColor.darkText
            rotationYButton.setTitle((property + "." + "rotation.y"), for: .normal)
            rotationYButton.addTarget(self, action: #selector(DetailViewController.rotationYAnimation), for: .touchUpInside)
            self.view.addSubview(rotationYButton)
            
            let scaleXButton = UIButton(type: .custom)
            scaleXButton.frame = CGRect(x: self.view.bounds.size.width/2 - 100, y: 152, width: 200, height: 44)
            scaleXButton.backgroundColor = UIColor.darkText
            scaleXButton.setTitle((property + "." + "scale.x"), for: .normal)
            scaleXButton.addTarget(self, action: #selector(DetailViewController.scaleXAnimation), for: .touchUpInside)
            self.view.addSubview(scaleXButton)
            
        } else if property == "zPosition" {
            
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
            
            let keyframeAnimation = CAKeyframeAnimation(keyPath: property)
            keyframeAnimation.delegate = self
            keyframeAnimation.duration = 2
            keyframeAnimation.repeatCount = 3
            keyframeAnimation.isRemovedOnCompletion = false
            keyframeAnimation.autoreverses = true
            keyframeAnimation.values = [NSNumber.init(value: -100), NSNumber.init(value: 0), NSNumber.init(value: 50), NSNumber.init(value: 150)]
            keyframeAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
            
            self.detailDescriptionLabel.layer.add(keyframeAnimation, forKey: property)
            layer2.add(keyframeAnimation, forKey: property)
            
        } else if property == "backgroundColor" {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear // this set is first necessary, otherwise, backgroundColor's animation will does not working
            let keyframeAnimation = CAKeyframeAnimation(keyPath: property)
            keyframeAnimation.delegate = self
            keyframeAnimation.duration = 2
            keyframeAnimation.repeatCount = 3
            keyframeAnimation.isRemovedOnCompletion = false
            keyframeAnimation.autoreverses = true
            keyframeAnimation.values = [UIColor.clear.cgColor, UIColor.brown.cgColor, UIColor.red.cgColor]
            self.detailDescriptionLabel.layer.add(keyframeAnimation, forKey: property)
        } else if property == "backgroundFilters" {
            tips(info: "This property is not supported on layers in iOS.")
        } else if property == "contents" {
            
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 2
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            // below code does not working because of image
//            let ciColor = CIColor.init(red: 1, green: 0, blue: 0)
//            let ciImage = CIImage.init(color: ciColor).cropping(to: CGRect(x: 0, y: 0, width: 100, height: 100))
//            let image1 = UIImage.init(ciImage: ciImage)
//            let ciImage2 = CIImage.init(color: CIColor(red: 0, green: 1, blue: 0)).cropping(to: CGRect(x: 0, y: 0, width: 100, height: 100))
//            let image2 = UIImage(ciImage: ciImage2)
            let image1 = UIImage(named: "black")
            let image2 = UIImage(named: "white")
            
            
            basicAnimation.fromValue = image1?.cgImage
            basicAnimation.toValue   = image2?.cgImage
            
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: property)
        } else if property == "contentsGravity" {
            let v = CALayer()
            v.frame = CGRect(x: self.view.bounds.size.width/2 - 50, y: 80, width: 100, height: 100)
            v.backgroundColor = UIColor.lightGray.cgColor
            v.contentsGravity = kCAGravityTopLeft
            let image = UIImage(named: "contentsGravity")
            v.contents = image?.cgImage
            self.view.layer.addSublayer(v)
            
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 2
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false

            basicAnimation.fromValue = kCAGravityTopLeft
            basicAnimation.toValue   = kCAGravityBottomRight
            
            v.add(basicAnimation, forKey: property)
            UIView.animate(withDuration: 3, delay: 2, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                v.contentsGravity = kCAGravityCenter
                }, completion: { (result) in
                    //
            })
            
            tips(info: "contentsGravity is similar to the contentMode of the view class, and is not animatable")
        } else if property == "masksToBounds" {
            let v = CALayer()
            v.frame = CGRect(x: self.view.bounds.size.width/2 - 100, y: 80, width: 200, height: 30)
            v.backgroundColor = UIColor.lightGray.cgColor
            v.contentsGravity = kCAGravityCenter
            v.masksToBounds = true
            let image = UIImage(named: "contentsGravity")
            v.contents = image?.cgImage
            self.view.layer.addSublayer(v)
            
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 2
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            basicAnimation.fromValue = NSNumber(value: true)
            basicAnimation.toValue   = NSNumber(value: false)
            v.add(basicAnimation, forKey: property)
            
            UIView.animate(withDuration: 3, delay: 5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                v.masksToBounds = false
                }, completion: { (result) in
                    //
            })
            
            tips(info: property + " is not animatable in iOS")
        } else if property == "sublayerTransform" {
            self.view.backgroundColor = UIColor.brown
            self.detailDescriptionLabel.backgroundColor = UIColor.yellow
            
            
            let testView = UIView(frame: CGRect(x: self.view.bounds.size.width/2 - 100, y: 80, width: 200, height: 100))
            testView.backgroundColor = UIColor.darkGray
            self.view.addSubview(testView)
            
            var transformIdentity = CATransform3DIdentity // 左乘矩阵
            print(transformIdentity)
            // m11, m22, m33,是用来缩放的
            transformIdentity.m11 = 0.5
            transformIdentity.m22 = 0.5
            print(transformIdentity)
            
            let basciAnimation = CABasicAnimation(keyPath: property)
            basciAnimation.delegate = self
            basciAnimation.duration = 2
            basciAnimation.repeatCount = 3
            basciAnimation.isRemovedOnCompletion = false
            basciAnimation.autoreverses = true
            
            basciAnimation.fromValue = CATransform3DIdentity
            basciAnimation.toValue   = transformIdentity
            
            self.view.layer.add(basciAnimation, forKey: property)
            
        } else if property == "borderColor" {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear // this set is first necessary, otherwise, backgroundColor's animation will does not working
            self.detailDescriptionLabel.layer.borderWidth = 5
            let keyframeAnimation = CAKeyframeAnimation(keyPath: property)
            keyframeAnimation.delegate = self
            keyframeAnimation.duration = 2
            keyframeAnimation.repeatCount = 3
            keyframeAnimation.isRemovedOnCompletion = false
            keyframeAnimation.autoreverses = true
            keyframeAnimation.values = [UIColor.clear.cgColor, UIColor.brown.cgColor, UIColor.red.cgColor]
            self.detailDescriptionLabel.layer.add(keyframeAnimation, forKey: property)
        } else if property == "borderWidth" {
            self.detailDescriptionLabel.layer.borderColor = UIColor.black.cgColor
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 2
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            basicAnimation.fromValue = NSNumber(value: 0)
            basicAnimation.toValue   = NSNumber(value: 5)
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: property)
        } else if property == "filter" || property == "compositingFilter" {
            tips(info: "This property is not supported on layers in iOS.")
        } else if property == "opacity" {
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 2
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            basicAnimation.fromValue = NSNumber(value: 0)
            basicAnimation.toValue   = NSNumber(value: 1)
            self.detailDescriptionLabel.layer.add(basicAnimation, forKey: property)
        } else if property == "shadowColor"{
            self.detailDescriptionLabel.backgroundColor = UIColor.clear // this set is first necessary, otherwise, backgroundColor's animation will does not working
            self.detailDescriptionLabel.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.detailDescriptionLabel.layer.shadowOpacity = 1
            
            let v = UIView()
            v.frame = CGRect(x: self.view.bounds.size.width/2 - 50, y: 80, width: 100, height: 100)
            v.backgroundColor = UIColor.white
            v.layer.shadowOpacity = 1
            v.layer.shadowOffset  = CGSize(width: 10, height: 15)
            v.layer.shadowColor   = UIColor.black.cgColor
            self.view.addSubview(v)
            
            
            let keyframeAnimation = CAKeyframeAnimation(keyPath: property)
            keyframeAnimation.delegate = self
            keyframeAnimation.duration = 2
            keyframeAnimation.repeatCount = 3
            keyframeAnimation.isRemovedOnCompletion = false
            keyframeAnimation.autoreverses = true
            keyframeAnimation.values = [UIColor.clear.cgColor, UIColor.brown.cgColor, UIColor.red.cgColor]
            self.detailDescriptionLabel.layer.add(keyframeAnimation, forKey: property)
            v.layer.add(keyframeAnimation, forKey: property)
        } else if property == "shadowOffset" { // shadowOffset default is (0, -3)
            let v = UIView()
            v.frame = CGRect(x: self.view.bounds.size.width/2 - 50, y: 80, width: 100, height: 100)
            v.backgroundColor = UIColor.white
            v.layer.shadowOpacity = 1 // default is 0 (0-1)
            v.layer.shadowColor   = UIColor.black.cgColor
            self.view.addSubview(v)
            
            
            let keyframeAnimation = CAKeyframeAnimation(keyPath: property)
            keyframeAnimation.delegate = self
            keyframeAnimation.duration = 2
            keyframeAnimation.repeatCount = 3
            keyframeAnimation.isRemovedOnCompletion = false
            keyframeAnimation.autoreverses = true
            keyframeAnimation.values = [NSValue.init(cgSize: CGSize(width: 10, height: 0)), NSValue.init(cgSize: CGSize(width: 10, height: 5)), NSValue.init(cgSize: CGSize(width: 10, height: 15))]
            v.layer.add(keyframeAnimation, forKey: property)
        } else if property == "shadowOpacity" {
            let v = UIView()
            v.frame = CGRect(x: self.view.bounds.size.width/2 - 50, y: 80, width: 100, height: 100)
            v.backgroundColor = UIColor.white
            v.layer.shadowOffset  = CGSize(width: 10, height: 15)
            v.layer.shadowColor   = UIColor.black.cgColor
            self.view.addSubview(v)
            
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 2
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            basicAnimation.fromValue = NSNumber(value: 0)
            basicAnimation.toValue   = NSNumber(value: 1)
            v.layer.add(basicAnimation, forKey: property)
        } else if property == "shadowRadius" {
            let v = UIView()
            v.frame = CGRect(x: self.view.bounds.size.width/2 - 50, y: 80, width: 100, height: 100)
            v.backgroundColor = UIColor.white
            v.layer.shadowOffset  = CGSize(width: 10, height: 15)
            v.layer.shadowColor   = UIColor.orange.cgColor
            v.layer.shadowOpacity = 1
            self.view.addSubview(v)
            
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 2
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            basicAnimation.fromValue = NSNumber(value: 0)
            basicAnimation.toValue   = NSNumber(value: Float(v.bounds.size.width/2))
            v.layer.add(basicAnimation, forKey: property)
        } else if property == "shadowPath" {
            let v = UIView()
            v.frame = CGRect(x: self.view.bounds.size.width/2 - 50, y: 80, width: 100, height: 100)
            v.backgroundColor = UIColor.blue
            v.layer.shadowOffset  = CGSize(width: 10, height: 15)
            v.layer.shadowColor   = UIColor.orange.cgColor
            v.layer.shadowOpacity = 1
            self.view.addSubview(v)
            
            let basicAnimation = CABasicAnimation(keyPath: property)
            basicAnimation.delegate = self
            basicAnimation.duration = 2
            basicAnimation.repeatCount = 2
            basicAnimation.autoreverses = true
            basicAnimation.isRemovedOnCompletion = false
            
            let path1 = CGMutablePath()
            path1.addEllipse(in: CGRect(x:80, y: 20, width: 10, height: 10))
            let path2 = CGMutablePath()
            path2.addEllipse(in: CGRect(x:80, y: 20, width: 100, height: 100))
            
            
            basicAnimation.fromValue = path1
            basicAnimation.toValue   = path2
            v.layer.add(basicAnimation, forKey: property)

        } else if property == "spring" {
            let springAnimation = CASpringAnimation(keyPath: "position.y")
            springAnimation.delegate = self
            springAnimation.isRemovedOnCompletion = false

            springAnimation.damping  = 5 // 阻尼系数
            springAnimation.mass     = 1 // 质量
            springAnimation.stiffness = 100 // 弹性系数
            springAnimation.initialVelocity = -30 // 初始速度(矢量)
            springAnimation.fromValue = self.detailDescriptionLabel.layer.position.x
            springAnimation.toValue   = self.detailDescriptionLabel.layer.position.x - 60
            
            springAnimation.duration = springAnimation.settlingDuration // 计算得到的动画时间
            
            self.detailDescriptionLabel.layer.add(springAnimation, forKey: property)
        } else if property == "gravity" {
            if dynamicAnimator == nil {
                dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
                dynamicAnimator.delegate = self
            }
            
            let gravityBehavor = UIGravityBehavior()
            gravityBehavor.gravityDirection = CGVector(dx: 0, dy: 1)
            gravityBehavor.magnitude = 1
            gravityBehavor.angle     = CGFloat(degreeToRadius(degree: 45))
            dynamicAnimator.addBehavior(gravityBehavor)
            let v = UIView(frame: CGRect(x: self.view.bounds.size.width/2 - 50, y: 100, width: 50, height: 100))
            v.backgroundColor = .black
            self.view.addSubview(v)
            gravityBehavor.addItem(v)
        } else if property == "collision" {
            if dynamicAnimator == nil {
                dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
                dynamicAnimator.delegate = self
            }
            
            let collisionBehavior = UICollisionBehavior()
            collisionBehavior.collisionDelegate = self
            collisionBehavior.collisionMode = .everything
            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 10))
            let bezierPath = UIBezierPath(arcCenter: CGPoint(x:self.view.bounds.width/2, y:self.view.bounds.height/2), radius: self.view.bounds.width/2 - 50, startAngle: 0, endAngle: CGFloat(2) * CGFloat(M_PI), clockwise: true)
            collisionBehavior.addBoundary(withIdentifier: property as NSString, for: bezierPath)
            collisionBehavior.addBoundary(withIdentifier: "bounds2" as NSString, from: CGPoint(x:10, y:self.view.bounds.height/2), to: CGPoint(x:self.view.bounds.width/2, y:self.view.bounds.height))
            dynamicAnimator.addBehavior(collisionBehavior)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezierPath.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.fillColor   = UIColor.clear.cgColor
            self.view.layer.addSublayer(shapeLayer)
            
            let gravityBehavor = UIGravityBehavior()
            gravityBehavor.gravityDirection = CGVector(dx: 0, dy: 1)
            gravityBehavor.magnitude = 1
            //gravityBehavor.angle     = CGFloat(degreeToRadius(degree: 45))
            dynamicAnimator.addBehavior(gravityBehavor)
            
            
            let v = UIView(frame: CGRect(x: self.view.bounds.size.width/2 - 50, y: 100, width: 50, height: 10))
            v.backgroundColor = .black
            self.view.addSubview(v)
            gravityBehavor.addItem(v)
            collisionBehavior.addItem(v)
        } else if property == "attachment" {
            if dynamicAnimator == nil {
                dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
                dynamicAnimator.delegate = self
            }
            let gravityBehavor = UIGravityBehavior()
            gravityBehavor.gravityDirection = CGVector(dx: 0, dy: 1)
            gravityBehavor.magnitude = 1
            //gravityBehavor.angle     = CGFloat(degreeToRadius(degree: 45))
            dynamicAnimator.addBehavior(gravityBehavor)
            
            
            let v = UIView(frame: CGRect(x: self.view.bounds.size.width/2 - 50, y: 100, width: 50, height: 10))
            v.backgroundColor = .black
            self.view.addSubview(v)
            gravityBehavor.addItem(v)
            
            let v1 = UIView(frame: CGRect(x: self.view.bounds.size.width/2 + 50, y: 200, width: 50, height: 10))
            v1.backgroundColor = .gray
            self.view.addSubview(v1)
            
            let attachmentBehavior = UIAttachmentBehavior(item: v, attachedTo: v1)
            attachmentBehavior.length = 20
            attachmentBehavior.damping = 1
            attachmentBehavior.frequency = 0.5
            dynamicAnimator.addBehavior(attachmentBehavior)
        } else if property == "snap" {
            if dynamicAnimator == nil {
                dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
                dynamicAnimator.delegate = self
            }
            let v = UIView(frame: CGRect(x: self.view.bounds.size.width/2 - 50, y: 100, width: 50, height: 10))
            v.backgroundColor = .black
            self.view.addSubview(v)
            let snapBehavior = UISnapBehavior(item: v, snapTo: CGPoint(x: self.view.bounds.size.width - 100, y: self.view.bounds.height/2))
            snapBehavior.damping = 0.8
            dynamicAnimator.addBehavior(snapBehavior)
        } else if property == "push" {
            if dynamicAnimator == nil {
                dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
                dynamicAnimator.delegate = self
            }
            
            let v = UIView(frame: CGRect(x: self.view.bounds.size.width/2 - 50, y: 100, width: 50, height: 10))
            v.backgroundColor = .black
            self.view.addSubview(v)
            
            let v1 = UIView(frame: CGRect(x: self.view.bounds.size.width/2 + 50, y: 200, width: 50, height: 10))
            v1.backgroundColor = .gray
            self.view.addSubview(v1)
            
            let pushBehavoir = UIPushBehavior(items: [v, v1], mode: UIPushBehaviorMode.instantaneous)
            pushBehavoir.active = true
            pushBehavoir.setAngle(CGFloat(M_PI_2), magnitude:0.1)// 推力的方向 和 item的加速度
            
            dynamicAnimator.addBehavior(pushBehavoir)
        } else if property == "field" {
            if dynamicAnimator == nil {
                dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
                dynamicAnimator.delegate = self
                dynamicAnimator.setValue(true, forKey: "debugEnabled")
            }
            
            let fieldBehavior = UIFieldBehavior.springField()
            fieldBehavior.addItem(self.detailDescriptionLabel)
            fieldBehavior.direction = CGVector(dx: 1, dy: 0)
//            fieldBehavior.strength = 0.3
//            fieldBehavior.falloff = 0.1
            fieldBehavior.position = self.detailDescriptionLabel.center
            fieldBehavior.region = UIRegion(size: CGSize(width: 200, height: 100))
            
            let parentBehavior = UIDynamicBehavior()
            let itemBehavior = UIDynamicItemBehavior(items: [self.detailDescriptionLabel])
            itemBehavior.density = 0.01
            itemBehavior.resistance = 10
            itemBehavior.friction   = 0
            itemBehavior.allowsRotation = false
//            parentBehavior.addChildBehavior(itemBehavior)
            parentBehavior.addChildBehavior(fieldBehavior)
            dynamicAnimator.addBehavior(parentBehavior)
            
            let pushBehavoir = UIPushBehavior(items: [self.detailDescriptionLabel], mode: UIPushBehaviorMode.instantaneous)
            
            pushBehavoir.active = true
            pushBehavoir.pushDirection = CGVector(dx: 0, dy: -1)
            pushBehavoir.magnitude = 0.1
            
            dynamicAnimator.addBehavior(pushBehavoir)
            
/*
            Field Behaviors
            class func dragField()
            Creates and returns a field behavior for slowing an object’s velocity.
            class func springField()
            Creates and returns a spring field behavior.
            class func velocityField(direction: CGVector)
            Creates and returns a field behavior object that applies a directional velocity to items.
            class func electricField()
            Creates and returns a field behavior object that interacts with charged items.
            class func magneticField()
            Creates and returns a field behavior that interacts with charged items.
            class func radialGravityField(position: CGPoint)
            Creates and returns a field behavior object that models a radial gravitational force.
            class func linearGravityField(direction: CGVector)
            Creates and returns a field behavior object that models a linear gravitational force.
            class func vortexField()
            Creates and returns a field behavior object that applies a rotational force relative to the field’s position.
            class func noiseField(smoothness: CGFloat, animationSpeed: CGFloat)
            Creates and returns a field behavior object that applies random noise to other forces.
            class func turbulenceField(smoothness: CGFloat, animationSpeed: CGFloat)
            Creates and returns a field behavior object that applies noise to an item in motion.
 */
        }
    }
    
    // MARK: - CAAnimationDelegate
    func animationDidStart(_ anim: CAAnimation) { // even though put a break point in this delegate method,but not effect the animation thread
        print("animationDidStart")
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
        } else if self.detailDescriptionLabel.layer.animation(forKey: "backgroundColor") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "borderColor") == anim || self.detailDescriptionLabel.layer.animation(forKey: "borderWidth") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.orange
        } else if self.detailDescriptionLabel.layer.animation(forKey: "opacity") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.darkGray
        } else if self.detailDescriptionLabel.layer.animation(forKey: "shadowColor") == anim {
        } else if self.detailDescriptionLabel.layer.animation(forKey: "spring") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.magenta
        }
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animationDidStop")
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
        } else if self.detailDescriptionLabel.layer.animation(forKey: "backgroundColor") == anim { // TODO:- why not call?
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "borderColor") == anim || self.detailDescriptionLabel.layer.animation(forKey: "borderWidth") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "opacity") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        } else if self.detailDescriptionLabel.layer.animation(forKey: "spring") == anim {
            self.detailDescriptionLabel.backgroundColor = UIColor.clear
        }
            
        self.detailDescriptionLabel.layer.removeAllAnimations()
    }
    
    // MARK: - UIDynamicAnimatorDelegate
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        //
    }
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        //
    }
    
    // MARK: - UICollisionBehaviorDelegate
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        print(p)
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        print(identifier as? NSString ?? "endedContactFor")
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
        print(item2)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print(p)
        print(identifier as? NSString ?? "beganContactFor")
    }
    
    // MARK: - Transform Animation
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
        
        animationScaleX.fromValue = NSNumber(value: 0.5)
        animationScaleX.toValue   = NSNumber(value: 2)
        self.detailDescriptionLabel.layer.add(animationScaleX, forKey: "transform")
    }
    
    // MARK: - Utils
    func degreeToRadius(degree:Float) -> Float {
        return degree/180.0 * Float(M_PI)
    }
    
    func radiusToDegree(radius:Float) -> Float {
        return radius / Float(M_PI) * 180.0
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
    
}

