//
//  DGUISliederViewController.swift
//  Components
//
//  Created by dd on 2019/1/18.
//  Copyright © 2019年 dd. All rights reserved.
//

import UIKit

class DGUISliederViewController: UIViewController {
    var altView :alterAnimationView?
    lazy var slider :MYSlider! = {
        let slider = MYSlider()
        slider.minimumValue = 0
        slider.maximumValue = 999
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setAlterViewAndSlider()
    }
    
    func setAlterViewAndSlider() {
        //设置弹出图像
        setAlterView()
        //设置滑动条
        setSlider()
    }
    
    private func setAlterView() {
        altView = alterAnimationView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        self.view.addSubview(altView!)
        altView?.isHidden = true
    }
    
    private func setSlider() {
        slider = MYSlider()
        
        slider.value = 500/1000
        
        //let image = UIImage.originImage(image: #imageLiteral(resourceName: "dog"),scaleSize: CGSize(width: 50, height: 50))
        //slider.setThumbImage(image, for: .normal)
        
        //let beforeImage = UIImage.originImage(image: #imageLiteral(resourceName: "before"), scaleSize: CGSize(width: slider.bounds.width/2, height: SliderH))
        //let afterImage = UIImage.originImage(image: #imageLiteral(resourceName: "after"), scaleSize: CGSize(width: /slider.bounds.width, height: SliderH))
        //slider.setMinimumTrackImage(beforeImage, for: .normal)
        // slider.setMaximumTrackImage(afterImage, for: .normal)
        
        
        slider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderValueChange(value:)), for: .valueChanged)
        self.view.addSubview(slider)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slider.frame =  CGRect(origin: .zero, size: CGSize(width: self.view.bounds.size.width-40, height: 30))
        
        slider.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 60.0)
    }
    
    @objc func sliderTouchUp() {
        altView?.isHidden = true
    }
    
    @objc func sliderTouchDown() {
        self.altView?.isHidden = false
        shakeAnimation()
        updateViewFrame()
    }
    
    @objc func sliderValueChange(value:CGFloat) {
        updateViewFrame()
    }
    
    func updateViewFrame() {
        let trackRect = slider.convert(slider.bounds, to: nil)//可能scrubberSlider嵌套，求出scrubberSlider在最外层（infoView父层）的frame
        let thumbRect = slider.thumbRect(forBounds: slider.bounds, trackRect: trackRect, value: slider.value)//得到滑块在最外层（infoView父层）的frame
        //求info的x，y
        altView?.center.x = thumbRect.origin.x+thumbRect.size.width/2+30
        altView?.center.y = thumbRect.origin.y - altView!.bounds.size.height - 20
        altView?.sliderScroll(value: Int(slider.value*1000))
    }
    
    //摆动动画
    func shakeAnimation(){
        //移除self.mineTopView.layer上的所有动画，可以避免多次重复添加
        altView?.layer.removeAllAnimations()
        let momAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        momAnimation.fromValue = NSNumber(value: -0.1) //左幅度
        momAnimation.toValue = NSNumber(value: 0.1) //右幅度
        momAnimation.duration = 0.1
        momAnimation.repeatCount = 2 //无限重复
        momAnimation.autoreverses = true //动画结束时执行逆动画
        
        momAnimation.delegate = self//CAAnimationDelegate 代理中有动画的开始和结束
        altView?.layer.add(momAnimation, forKey: "centerLayer")
    }
    
}

extension DGUISliederViewController: CAAnimationDelegate{
    
}
