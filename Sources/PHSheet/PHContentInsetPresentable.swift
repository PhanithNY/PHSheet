//
//  PHContentInsetPresentable.swift
//
//
//  Created by Suykorng on 30/5/24.
//

#if os(iOS)
import UIKit

public protocol PHContentInsetPresentable: UIViewController {
  
  /// Allow to dismiss on tap. Default is `true`.
  var sheetDismissOnTap: Bool { get }
  
  /// Allow to dismiss on scroll. Default is `true`.
  var sheetDismissible: Bool { get }
  
  /// The height for short form of the sheet. Default is `375`.
  var sheetShortFormHeight: CGFloat { get }
  
  /// The height of long form of the sheet. Default is `375`.
  var sheetLongFormHeight: CGFloat { get }
  
  /// The vertical scrollView inside the sheet.
  /// If provided, sheet will interactive dismiss if contentOffset of the scrollView is zero. Default is `nil`.
  var sheetScrollView: UIScrollView? { get }
  
  /// The transitioning object between presenting and dismissal.
  var sheetTransitionManager: UIViewControllerTransitioningDelegate? { get set }
  
  /// Transition the sheet between its form.
  /// - Parameter form: The provided form, `shortForm` or `shortForm`.
  func sheetTransition(to form: PHContentInsetModalForm)
  
  /// Tell the presentation controller to update the layout.
  /// - Parameter animated: If `true`, animation will be perform.
  func sheetUpdatePresentationLayout(animated: Bool)
  
}

public extension PHContentInsetPresentable {
  var sheetDismissOnTap: Bool {
    true
  }
  
  var sheetDismissible: Bool {
    true
  }
  
  var sheetShortFormHeight: CGFloat {
    view.bounds.width
  }
  
  var sheetLongFormHeight: CGFloat {
    view.bounds.width
  }
  
  var sheetScrollView: UIScrollView? {
    nil
  }
  
  func sheetTransition(to form: PHContentInsetModalForm) {
    ((navigationController ?? self).presentationController as? PHContentInsetPresentationController)?.transition(to: form)
  }
  
  func sheetUpdatePresentationLayout(animated: Bool = false) {
    presentationController?.containerView?.setNeedsLayout()
    
    switch animated {
    case true:
      UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
        self.presentationController?.containerView?.layoutIfNeeded()
      }, completion: nil)
      
    case false:
      presentationController?.containerView?.layoutIfNeeded()
    }
  }
}
#endif
