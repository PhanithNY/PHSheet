//
//  PHContentInsetTransitioningAnimator.swift
//
//
//  Created by Suykorng on 29/5/24.
//

#if os(iOS)
import UIKit

public final class PHContentInsetTransitioningAnimator: NSObject {
  
  enum AnimationType {
    case present
    case dismiss
  }
  
  // MARK: - Init / Deinit
  
  private let animationType: AnimationType
  private let duration: TimeInterval
  
  init(animationType: AnimationType,
       duration: TimeInterval = 0.5) {
    self.animationType = animationType
    self.duration = duration
    super.init()
  }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PHContentInsetTransitioningAnimator: UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    switch animationType {
    case .present:
      animatePresentation(using: transitionContext)
      
    case .dismiss:
      animateDismissal(using: transitionContext)
    }
  }
  
  private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
    let presentedViewController = transitionContext.viewController(forKey: .to).unsafelyUnwrapped
    transitionContext.containerView.addSubview(presentedViewController.view)
    
    let presentedFrame = transitionContext.finalFrame(for: presentedViewController)
    let dismissedFrame = CGRect(x: presentedFrame.minX, 
                                y: transitionContext.containerView.bounds.height,
                                width: presentedFrame.width,
                                height: presentedFrame.height)
    presentedViewController.view.frame = dismissedFrame
    
    let duration = transitionDuration(using: transitionContext)
    let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0) {
      presentedViewController.view.frame = presentedFrame
    }
    
    animator.addCompletion { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    animator.startAnimation()
  }
  
  private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
    let presentedViewController = transitionContext.viewController(forKey: .from).unsafelyUnwrapped
    let presentedFrame = transitionContext.finalFrame(for: presentedViewController)
    let dismissedFrame = CGRect(x: presentedFrame.minX,
                                y: transitionContext.containerView.bounds.height,
                                width: presentedFrame.width,
                                height: presentedFrame.height)
    
    let duration = transitionDuration(using: transitionContext)
    let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0) {
      presentedViewController.view.frame = dismissedFrame
    }
    
    animator.addCompletion { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    animator.startAnimation()
  }
}
#endif
