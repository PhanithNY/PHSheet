//
//  PHContentInsetContainerView.swift
//
//
//  Created by Suykorng on 30/5/24.
//

#if os(iOS)
import UIKit

final class PHContentInsetContainerView: UIView {
  
  private let presentedView: UIView
  
  init(presentedView: UIView, frame: CGRect) {
    self.presentedView = presentedView
    super.init(frame: frame)
    
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIView {
  var sheetContainerView: PHContentInsetContainerView? {
    return subviews.first(where: { view -> Bool in
      view is PHContentInsetContainerView
    }) as? PHContentInsetContainerView
  }
}
#endif
