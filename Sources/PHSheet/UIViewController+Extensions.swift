//
//  UIViewController+Extensions.swift
//
//
//  Created by Suykorng on 3/6/24.
//

import UIKit

public extension UIViewController {
  final func presentPHSheet(_ viewController: PHContentInsetPresentable,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil) {
    let interactionController = PHContentInsetInteractionController(viewController: viewController)
    let transitionManager = PHContentInsetTransitioningManager(interactionController: interactionController)
    viewController.sheetTransitionManager = transitionManager
    viewController.transitioningDelegate = transitionManager
    viewController.modalPresentationStyle = .custom
    present(viewController, animated: animated, completion: completion)
  }
}
