//
//  CustomCollectionViewCell.swift
//  PHSheetDemo
//
//  Created by Suykorng on 3/6/24.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  private lazy var imageView = UIImageView().config {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
    $0.backgroundColor = .init(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 0.5)
  }
  
  // MARK: - Init / Deinit
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    prepareLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Actions
  
  
  // MARK: - Layouts
  
  private func prepareLayouts() {
    imageView.layout {
      contentView.addSubview($0)
      $0.fill()
    }
  }
}

