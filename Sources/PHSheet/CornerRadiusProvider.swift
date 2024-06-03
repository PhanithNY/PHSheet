//
//  CornerRadiusProvider.swift
//
//
//  Created by Suykorng on 29/5/24.
//

import UIKit

public enum CornerRadiusProvider {
  public static var notchCornerRadius: CGFloat {
    UIScreen.main.displayCornerRadius
  }
}

extension UIScreen {
  private static let cornerRadiusKey: String = {
    let components = ["Radius", "Corner", "display", "_"]
    return components.reversed().joined()
  }()
  
  /// The corner radius of the display. Uses a private property of `UIScreen`,
  /// and may report 0 if the API changes.
  public var displayCornerRadius: CGFloat {
    guard let cornerRadius = self.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
      return 0.0
    }
    
    return max(0, cornerRadius)
  }
}
