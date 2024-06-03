//
//  PHContentInsetTransitioningManager.swift
//
//
//  Created by Suykorng on 29/5/24.
//

#if os(iOS)
import UIKit

public protocol InteractionControlling: UIViewControllerInteractiveTransitioning {
  var interactionInProgress: Bool { get }
}

public final class PHContentInsetTransitioningManager: NSObject {
  
  private var interactionController: InteractionControlling?
  
  public init(interactionController: InteractionControlling?) {
    self.interactionController = interactionController
  }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PHContentInsetTransitioningManager: UIViewControllerTransitioningDelegate {
  
  public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    PHContentInsetPresentationController(presentedViewController: presented, presenting: presenting)
  }
  
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    PHContentInsetTransitioningAnimator(animationType: .present, duration: 0.5)
  }
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    PHContentInsetTransitioningAnimator(animationType: .dismiss, duration: 0.5)
  }
  
  public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    guard let interactionController = interactionController, interactionController.interactionInProgress else {
      return nil
    }
    return interactionController
  }
}
#endif
