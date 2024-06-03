//
//  Instance.swift
//
//
//  Created by Suykorng on 29/5/24.
//

import UIKit

enum InterfaceIdiom {
  case phone
  case pad
}

final class Instance {
  
  static let current = Instance()
  
  var interfaceIdiom: InterfaceIdiom {
    UIDevice.current.userInterfaceIdiom == .phone ? .phone : .pad
  }
  
  private init() {}
}
