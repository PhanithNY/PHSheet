//
//  UINavigationController+Extensions.swift
//  PHSheetDemo
//
//  Created by Suykorng on 31/5/24.
//

import PHSheet
import UIKit

extension UINavigationController: PHContentInsetPresentable {
  public var sheetDismissible: Bool {
    (topViewController as? PHContentInsetPresentable)?.sheetDismissible ?? true
  }
  
  public var sheetDismissOnTap: Bool {
    (topViewController as? PHContentInsetPresentable)?.sheetDismissOnTap ?? true
  }
  
  public var sheetShortFormHeight: CGFloat {
    (topViewController as? PHContentInsetPresentable)?.sheetShortFormHeight ?? 375
  }
  
  public var sheetLongFormHeight: CGFloat {
    (topViewController as? PHContentInsetPresentable)?.sheetLongFormHeight ?? 375
  }
  
  public var sheetTransitionManager: (any UIViewControllerTransitioningDelegate)? {
    get {
      (topViewController as? PHContentInsetPresentable)?.sheetTransitionManager
    }
    set {
      (topViewController as? PHContentInsetPresentable)?.sheetTransitionManager = newValue
    }
  }
  
  public var sheetScrollView: UIScrollView? {
    (topViewController as? PHContentInsetPresentable)?.sheetScrollView
  }
}
