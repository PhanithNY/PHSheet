//
//  AirPodSheet.swift
//  PHSheetDemo
//
//  Created by Suykorng on 31/5/24.
//

import PHSheet
import SceneKit
import UIKit

final class AirPodSheet: UIViewController, PHContentInsetPresentable {
  
  var sheetDismissOnTap: Bool {
    true
  }
  
  var sheetDismissible: Bool {
    true
  }
  
  var sheetShortFormHeight: CGFloat {
    let targetWidth = view.bounds.width
    
    // The smallest possible size for presentation width.
    let fittingSize: CGSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
    
    // The calculated height for above presentation width.
    let selfSizingHeight: CGFloat = view.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required,
                                                                          verticalFittingPriority: .defaultLow).height
    
    return selfSizingHeight
  }
  
  var sheetLongFormHeight: CGFloat {
    sheetShortFormHeight
  }
  
  var sheetTransitionManager: (any UIViewControllerTransitioningDelegate)?
  
  var sheetScrollView: UIScrollView? {
    nil
  }
  
  // MARK: - Properties
  
  private lazy var titleLabel = UILabel().config {
    $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    $0.textAlignment = .center
    $0.textColor = .label
    $0.text = "Phanith's AirPods Pro"
  }
  
  private lazy var descriptionLabel = UILabel().config {
    $0.numberOfLines = 0
    $0.textAlignment = .center
    
    let attachment = NSTextAttachment()
    attachment.image = UIImage(systemName: "bolt.fill")
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 4
    paragraphStyle.alignment = .center
    
    let attributedText = NSMutableAttributedString(attachment: attachment)
    attributedText.append(NSAttributedString(string: " Optimized Battery Charging. AirPods scheduled to finish charging by 8:30 in the evening.", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor: UIColor.label]))
    attributedText.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
    $0.attributedText = attributedText
  }
  
  private lazy var actionButton = UIButton(type: .system).config {
    $0.setTitle("Turn off until tomorrow", for: .normal)
    if let font = $0.titleLabel?.font {
      $0.titleLabel?.font = UIFont.systemFont(ofSize: font.pointSize, weight: .medium)
    }
    $0.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
  }
  
  private lazy var sceneView = SCNView().config {
    $0.backgroundColor = .systemBackground
    $0.rendersContinuously = true
    $0.antialiasingMode = .multisampling4X
  }
  
  // MARK: - Lifecycle 
  
  override var prefersHomeIndicatorAutoHidden: Bool {
    true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareLayouts()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    loadScene()
  }
  
  // MARK: - Actions
  
  @objc
  private func didTap(_ sender: UIButton) {
    dismiss(animated: true)
  }
  
  private func loadScene() {
    let scene = SCNScene(named: "airpodspro.usdz")
    sceneView.autoenablesDefaultLighting = true
    sceneView.allowsCameraControl = true
    sceneView.scene = scene
  }
}

// MARK: - Layouts

extension AirPodSheet {
  private func prepareLayouts() {
    view.backgroundColor = .systemBackground
    
    titleLabel.layout {
      view.addSubview($0)
      $0.top(constraint: view.topAnchor, 32)
        .leading()
        .trailing()
    }
    
    actionButton.layout {
      view.addSubview($0)
      $0.leading(16)
        .trailing(16)
        .bottom(constraint: view.safeAreaLayoutGuide.bottomAnchor)
        .height(52)
    }
    
    descriptionLabel.layout {
      view.addSubview($0)
      $0.bottom(constraint: actionButton.topAnchor)
        .leading(24)
        .trailing(24)
    }
    
    sceneView.layout {
      view.insertSubview($0, at: 0)
      $0.top(-24)
        .leading(24)
        .trailing(24)
        .bottom(constraint: actionButton.topAnchor, 16)
        .height(view.bounds.width, relativeBy: .greaterThanOrEqual, priority: .defaultHigh)
    }
  }
}
