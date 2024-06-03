//
//  PHContentInsetPresentationController.swift
//
//
//  Created by Suykorng on 29/5/24.
//

#if os(iOS)
import UIKit

public final class PHContentInsetPresentationController: UIPresentationController {
  
  // MARK: - Properties
  
  public override var shouldPresentInFullscreen: Bool {
    false
  }
  
  public override var presentedView: UIView? {
    sheetContainerView
  }
  
  /// The `presentedView` wrapper, fix some weird issue when transition between contentHeight.
  private lazy var sheetContainerView: PHContentInsetContainerView = {
    let frame = containerView?.frame ?? .zero
    return PHContentInsetContainerView(presentedView: presentedViewController.view, frame: frame)
  }()
  
  /// Then inset between screen border and the sheet.
  private let inset: CGFloat = 6.0
  
  /// Use to calculate the height of the sheet for each form style.
  private var sheetForm: PHContentInsetModalForm = .shortForm
  
  /// The radius of the sheet.
  private var cornerRadius: CGFloat = CornerRadiusProvider.notchCornerRadius {
    didSet {
      // Resolved issue where sometime the radius is negative
      let finalRadius: CGFloat = max(12, cornerRadius)
      presentedView?.layer.masksToBounds = true
      presentedView?.roundCorners(topLeft: finalRadius, topRight: finalRadius, bottomLeft: finalRadius, bottomRight: finalRadius)
      
      if let view = presentedViewController.view {
        if #available(iOS 13.0, *) {
          view.layer.cornerCurve = .continuous
        }
        view.layer.masksToBounds = true
        view.layer.cornerRadius = finalRadius
      }
    }
  }
  
  /// The backdrop view behind the sheet.
  private(set) lazy var dimmedView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    view.alpha = 0.0
    return view
  }()
  
  // MARK: - Lifecycle
  
  /// Transition between form style.
  /// - Parameter form: The provided form style, either `shortForm` or `longFrom`.
  public final func transition(to form: PHContentInsetModalForm) {
    sheetForm = form
    
    let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.75) { [self] in
      presentedView?.frame = frameOfPresentedViewInContainerView
      sheetContainerView.frame = frameOfPresentedViewInContainerView
      presentedViewController.view.frame = frameOfPresentedViewInContainerView
      containerView?.setNeedsLayout()
      containerView?.layoutIfNeeded()
    }
    animator.startAnimation()
  }
  
  public override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    
    // Fix iOS 17.1+ issue where sheet not display.
    if sheetContainerView.frame == .zero {
      sheetContainerView.frame = frameOfPresentedViewInContainerView
    }
    presentedView?.frame = frameOfPresentedViewInContainerView
  }
  
  public override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = containerView,
          let presentedView = presentedView else {
      return UIScreen.main.bounds
    }
    
    // Make sure to account for the safe area insets
    let visibleViewport: CGRect = containerView.bounds
    
    let targetWidth: CGFloat
    switch Instance.current.interfaceIdiom {
    case .phone:
      targetWidth = visibleViewport.width - inset*2
      
    case .pad:
      targetWidth = 414 - 32
    }
    
    // The smallest possible size for presentation width.
    let fittingSize: CGSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
    
    // The calculated height for above presentation width.
    let selfSizingHeight: CGFloat = presentedView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required,
                                                                          verticalFittingPriority: .defaultLow).height
    
    var targetHeight: CGFloat
    
    switch sheetForm {
    case .shortForm:
      // Grab the short form height from the controller, or read it from calculated height if not provided.
      targetHeight = (presentedViewController as? PHContentInsetPresentable)?.sheetShortFormHeight ?? selfSizingHeight
      
    case .longForm:
      // Grab the long form height from the controller, or read it from calculated height if not provided.
      targetHeight = (presentedViewController as? PHContentInsetPresentable)?.sheetLongFormHeight ?? selfSizingHeight
    }
    
    // Lock max height to screen height.
    targetHeight = min(targetHeight, visibleViewport.height - inset*2)
    
    var finalFrame = visibleViewport
    
    switch Instance.current.interfaceIdiom {
    case .phone:
      finalFrame.origin.x = inset
      finalFrame.origin.y = finalFrame.size.height - targetHeight - inset
      
    case .pad:
      finalFrame.origin.x = (finalFrame.size.width / 2) - (targetWidth/2)
      finalFrame.origin.y = (finalFrame.size.height / 2) - (targetHeight/2)
    }
    
    finalFrame.size.width = targetWidth
    finalFrame.size.height = min(targetHeight, visibleViewport.height - inset*2)
    
    return finalFrame
  }
  
  public override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
    
    // Apply corner radius logic.
    cornerRadius = CornerRadiusProvider.notchCornerRadius - inset
    
    // Add gesture if allow to dismiss on tap.
    if let presentable = presentedViewController as? PHContentInsetPresentable, presentable.sheetDismissOnTap {
      prepareGestures()
    }
    
    guard let containerView = containerView else {
      return
    }
    
    containerView.insertSubview(dimmedView, at: 0)
    dimmedView.translatesAutoresizingMaskIntoConstraints = false
    dimmedView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    dimmedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
    dimmedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    dimmedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmedView.alpha = 1.0
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.dimmedView.alpha = 1.0
    })
  }
  
  public override func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()
    
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmedView.alpha = 0.0
      return
    }
    
    if !coordinator.isInteractive {
      coordinator.animate(alongsideTransition: { _ in
        self.dimmedView.alpha = 0.0
      })
    }
  }
  
  public override func dismissalTransitionDidEnd(_ completed: Bool) {
    super.dismissalTransitionDidEnd(completed)
    
    if completed {
      dimmedView.removeFromSuperview()
    }
  }
  
  // MARK: - Actions
  
  @objc
  private func didTapGesture(_ sender: UITapGestureRecognizer) {
    if !presentedViewController.isBeingDismissed {
      presentedViewController.dismiss(animated: true)
    }
  }
  
  private func prepareGestures() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture(_:)))
    dimmedView.isUserInteractionEnabled = true
    dimmedView.addGestureRecognizer(gesture)
  }
}
#endif
