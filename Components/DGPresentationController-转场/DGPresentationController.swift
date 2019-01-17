//
//  DGPresentationController.swift
//  PresentBottom
//
//  Created by dd on 2019/1/17.
//  Copyright © 2019年 Isaac Pan. All rights reserved.
//

import UIKit

enum DGPopverType: Int{
    case center = 1
    case bottom = 2
}

class DGPresentationController: UIPresentationController {

    var popverType: DGPopverType = .bottom
    var presentedSize: CGSize = CGSize.zero
    var presentedHeight: CGFloat = 0
    
    lazy var coverView: UIView = {[unowned self] in
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverViewDidClicked))
        coverView.addGestureRecognizer(tap)
        return coverView
    }()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        switch popverType {
        case .center:
            self.presentedView?.frame = CGRect(x: self.containerView!.center.x - self.presentedSize.width * 0.5, y: self.containerView!.center.y - self.presentedSize.height * 0.5, width: self.presentedSize.width, height: self.presentedSize.height)
            break
        case .bottom:
            self.presentedView?.frame = CGRect(x: 0, y: self.containerView!.bounds.size.height - self.presentedHeight, width: self.containerView!.bounds.size.width, height: self.presentedHeight)
            break
        }
        self.coverView.frame = self.containerView!.bounds
        self.containerView?.insertSubview(self.coverView, at: 0)
    }
    
    @objc private func coverViewDidClicked(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}

typealias DgCompleteHandle = ((_ presented: Bool)->())
class DGPopoverAnimatior: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate{
    
    var centerViewSize: CGSize = CGSize.zero
    var bottomViewHeight: CGFloat = 0
    var animationDuration: TimeInterval = 0.3
    
    private var popoverType: DGPopverType = .bottom
    private var completeHandle: DgCompleteHandle?
    weak private var presentationController: DGPresentationController?
    private var isPresented = false
    
    
    class func popoverAnimator(popoverType: DGPopverType, completeHandle: DgCompleteHandle?) -> DGPopoverAnimatior{
        let popoverAnimator = DGPopoverAnimatior()
        popoverAnimator.popoverType = popoverType
        popoverAnimator.completeHandle = completeHandle
        return popoverAnimator
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = DGPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.popverType = popoverType
        switch popoverType {
        case .center:
            presentation.presentedSize = centerViewSize
            break
        case .bottom:
            presentation.presentedHeight = bottomViewHeight
            break
        }
        presentationController = presentation
        return presentation
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        completeHandle?(isPresented)
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        completeHandle?(isPresented)
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresented(transitionContext: transitionContext) : animataionForDismissed(transitionContext: transitionContext)
    }
    
    private func animationForPresented(transitionContext: UIViewControllerContextTransitioning){
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        transitionContext.containerView.addSubview(presentedView!)
        self.presentationController?.coverView.alpha = 0
        
        // 设置阴影
        transitionContext.containerView.layer.shadowColor = UIColor.black.cgColor
        transitionContext.containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        transitionContext.containerView.layer.shadowOpacity = 0.5
        transitionContext.containerView.layer.shadowRadius = 10
        
        switch popoverType {
        case .center:
            presentedView?.alpha = 0
            presentedView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.presentationController?.coverView.alpha = 1
                presentedView?.alpha = 1
                presentedView?.transform = CGAffineTransform.identity
            }) { (_) in
                transitionContext.completeTransition(true)
            }
            break
        case .bottom:
            presentedView?.transform = CGAffineTransform(translationX: 0, y: bottomViewHeight)
            UIView.animate(withDuration: animationDuration, animations: {
                self.presentationController?.coverView.alpha = 1
                presentedView?.transform = CGAffineTransform.identity
            }) { (_) in
                transitionContext.completeTransition(true)
            }
            break
        }
    }
    
    private func animataionForDismissed(transitionContext: UIViewControllerContextTransitioning){
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        switch popoverType {
        case .center:
            UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.presentationController?.coverView.alpha = 0
                presentedView?.alpha = 0
            }) { (_) in
                presentedView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
            break
        case .bottom:
            UIView.animate(withDuration: animationDuration, animations: {
                self.presentationController?.coverView.alpha = 0
                presentedView?.transform = CGAffineTransform(translationX: 0, y: self.bottomViewHeight)
            }) { (_) in
                presentedView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
            break
        }
    }
}

private var popoverAnimatorKey: Void?
extension UIViewController{
   
    var popoverAnimator: DGPopoverAnimatior?{
        get{
            return objc_getAssociatedObject(self, &popoverAnimatorKey) as? DGPopoverAnimatior
        }
        set{
            objc_setAssociatedObject(self,
                                     &popoverAnimatorKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func dg_bottomPresentController(vc: UIViewController, presentedHeight: CGFloat, completeHandle: DgCompleteHandle?){
        popoverAnimator = DGPopoverAnimatior.popoverAnimator(popoverType: .bottom, completeHandle: completeHandle)
        popoverAnimator?.bottomViewHeight = presentedHeight
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = popoverAnimator
        self.present(vc, animated: true, completion: nil)
    }
    
    func dg_centerPresentController(vc: UIViewController, presentedSize: CGSize, completeHandle: DgCompleteHandle?){
         popoverAnimator = DGPopoverAnimatior.popoverAnimator(popoverType: .center, completeHandle: completeHandle)
        popoverAnimator?.centerViewSize = presentedSize
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = popoverAnimator
        self.present(vc, animated: true, completion: nil)
    }
}
