//
//  ViewController.swift
//  PickABoo
//
//  Created by Asaduzzaman Anik on 5/9/22.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Views
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play Animation", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    let animationView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }()
    //MARK: --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    //MARK: - SetupViews And button Actions
    
    func setupViews(){
        view.addSubview(button)
        button.setDimensions(width: 200, height: 20)
        button.centerX(inView: view)
        button.centerY(inView: view)
        
        view.addSubview(animationView)
        animationView.setDimensions(width: 200, height: 200)
        animationView.centerX(inView: view)
        animationView.anchorView(bottom: button.topAnchor, paddingBottom: 20)
    }
    
    @objc func buttonPressed(_ sender: UIButton){
        animationView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        animateWindow()
        animatePerson()
    }
    
    
    //MARK: --------------------
    

    //MARK: - Helper Functions
    func animateWindow(){
        let windowBorderLayer = CALayer()
        windowBorderLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 200))
        windowBorderLayer.borderColor = UIColor(patternImage: UIImage(named: "windowImage")!).cgColor
        windowBorderLayer.borderWidth = 20
        animationView.layer.addSublayer(windowBorderLayer)
        
        //create a layer
        let windowShadeLeft = CALayer()
        //set the anchor point
        windowShadeLeft.anchorPoint = CGPoint(x: 0, y: 0)
        //give it a frame
        windowShadeLeft.frame = CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: (200-40)/2, height: 200-40))
        //set a image for the layer
        windowShadeLeft.contents = UIImage(named: "windowImage")?.cgImage
        windowShadeLeft.contentsGravity = .resizeAspectFill
        //mask to bounds, so that images doen't show outside the layer
        windowShadeLeft.masksToBounds = true
        //add it to the parent view
        animationView.layer.addSublayer(windowShadeLeft)
        
        //create a layer
        let windowShadeRight = CALayer()
        //set it's anchor point
        windowShadeRight.anchorPoint = CGPoint(x: 1, y: 0)
        //set it's frame
        windowShadeRight.frame = CGRect(origin: CGPoint(x: 100, y: 20), size: CGSize(width: (200-40)/2, height: 200-40))
        //masks to bounds, so that images doen't show outside the layer
        windowShadeRight.masksToBounds = true
        //set a image for the layer
        windowShadeRight.contents = UIImage(named: "windowImage")?.cgImage
        windowShadeRight.contentsGravity = .resizeAspectFill
        //add it to the parent view
        animationView.layer.addSublayer(windowShadeRight)
        
        //transform for the left shade
        var windowTransformLeft = CATransform3DIdentity
        //change the m34 for perspective transformation
        windowTransformLeft.m34 = -1.0 / 1000
        //set rotation angel to the transformation
        windowTransformLeft = CATransform3DRotate(windowTransformLeft, -(120 * .pi / 180), 0, 1, 0)
        
        //create the animation
        let animation = CASpringAnimation(keyPath: #keyPath(CALayer.transform))
        //easeIn, so that the animation start slowly and speeds up as it progresses
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        //set the duration
        animation.duration = 3
        //set the final transform value
        animation.toValue = windowTransformLeft
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        //add animation to left shade
        windowShadeLeft.add(animation, forKey: UUID().description)
        
        var windowTransform2 = CATransform3DIdentity
        windowTransform2.m34 = -1.0 / 1000
        windowTransform2 = CATransform3DRotate(windowTransform2, -(240 * .pi / 180), 0, 1, 0)
        
        let animation1 = CASpringAnimation(keyPath: #keyPath(CALayer.transform))
        animation1.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation1.duration = 3
        animation1.toValue = windowTransform2
        animation1.fillMode = .forwards
        animation1.isRemovedOnCompletion = false
        windowShadeRight.add(animation1, forKey: UUID().description)
        
    }
    
    func animatePerson(){
        //create a parentLayer around the animation view. it'll mask the stick figure as it's
        //comes in from the bottom
        let parentLayer = CALayer()
        parentLayer.masksToBounds = true
        parentLayer.frame = CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: animationView.frame.size.width-40, height: animationView.frame.size.height-40))
        animationView.layer.addSublayer(parentLayer)
        
        //create a personLayer. its initial position will be
        //the bottom center of the parent view
        let personLayer = CALayer()
        personLayer.frame = CGRect(origin: CGPoint(x: parentLayer.frame.width/2-12.5, y: parentLayer.frame.height), size: CGSize(width: 25, height: 25))
        parentLayer.addSublayer(personLayer)
        
        //make the figure apppear behind window animation
        let positionAnimation = CASpringAnimation(keyPath: "position.y")
        positionAnimation.toValue = parentLayer.frame.height-40
        positionAnimation.duration = 3
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        //start the animation after the window is open a bit,
        //so that it can be seen.
        positionAnimation.beginTime = CACurrentMediaTime() + 0.5
        personLayer.add(positionAnimation, forKey: UUID().description)

        
        //create head layer
        let heahLayer = CALayer()
        //make it a circle using corner radius
        heahLayer.cornerRadius = 15
        heahLayer.backgroundColor = UIColor.black.cgColor
        heahLayer.frame = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
        personLayer.addSublayer(heahLayer)
        
        //add bubble head animation to the head
        let headmovementAnimation = CASpringAnimation(keyPath: "position.x")
        headmovementAnimation.fromValue = 13
        headmovementAnimation.toValue = 16
        headmovementAnimation.duration = 0.3
        headmovementAnimation.isRemovedOnCompletion = false
        headmovementAnimation.fillMode = .forwards
        headmovementAnimation.repeatCount = .infinity
        headmovementAnimation.autoreverses = true
        heahLayer.add(headmovementAnimation, forKey: UUID().description)
        
        
        //Create path for the body
        let body = UIBezierPath(rect: CGRect(origin: .zero, size: CGSize(width: 6, height: 60)))
        //create body shape using the path
        let bodyShape = CAShapeLayer()
        bodyShape.fillColor = UIColor.black.cgColor
        bodyShape.path = body.cgPath
        bodyShape.frame = CGRect(origin: CGPoint(x: 15-3, y: 10), size: .zero)
        personLayer.addSublayer(bodyShape)
        
        //create path for the hand
        let hand = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: 6, height: 30)), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 2, height: 2))
        //create handShape using the path
        let handShape = CAShapeLayer()
        handShape.anchorPoint = CGPoint(x: 0, y: 0)
        handShape.fillColor = UIColor.black.cgColor
        handShape.path = hand.cgPath
        handShape.frame = CGRect(origin: CGPoint(x: 18, y: 50), size: .zero)
        personLayer.addSublayer(handShape)
        
        //hand wave animation
        let waveAnimation = CASpringAnimation(keyPath: #keyPath(CALayer.transform))
        waveAnimation.valueFunction = CAValueFunction(name: .rotateZ)
        waveAnimation.fromValue = 210.0 * .pi / 180
        waveAnimation.toValue = 250.0 * .pi / 180
        waveAnimation.autoreverses = true
        waveAnimation.repeatCount = .infinity
        waveAnimation.duration = 0.2
        waveAnimation.fillMode = .forwards
        waveAnimation.isRemovedOnCompletion = false
        waveAnimation.beginTime = CACurrentMediaTime() + 0.5
        handShape.add(waveAnimation, forKey: UUID().description)
    }
    
    //MARK: --------------------

}

