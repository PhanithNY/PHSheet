//
//  ViewController.swift
//  PHSheetDemo
//
//  Created by Suykorng on 29/5/24.
//

import EasyAnchor
import UIKit
import PHSheet

class ViewController: UIViewController {

  private lazy var airPodButton = UIButton(type: .system).config {
    $0.setTitle("AirPods", for: .normal)
    $0.addTarget(self, action: #selector(showAirPods(_:)), for: .touchUpInside)
  }
  
  private lazy var tableButton = UIButton(type: .system).config {
    $0.setTitle("TableView", for: .normal)
    $0.addTarget(self, action: #selector(showTable(_:)), for: .touchUpInside)
  }
  
  private lazy var collectionButton = UIButton(type: .system).config {
    $0.setTitle("CollectionView", for: .normal)
    $0.addTarget(self, action: #selector(showCollection(_:)), for: .touchUpInside)
  }
  
  private lazy var stackView = UIStackView(arrangedSubviews: [airPodButton, tableButton, collectionButton]).config {
    $0.axis = .vertical
    $0.spacing = 16
  }
  
  // MARK: - Properties
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Premium Sheet"
    view.backgroundColor = .systemBackground
    stackView.layout {
      view.addSubview($0)
      $0.centerY()
        .leading()
        .trailing()
    }
  }

  @objc
  private func showAirPods(_ sender: UIButton) {
    let sheetViewController: AirPodSheet = .init()
    presentPHSheet(sheetViewController, animated: true)
  }
  
  @objc
  private func showTable(_ sender: UIButton) {
    let sheetViewController: TableViewController = .init()
    let navigationController = UINavigationController(rootViewController: sheetViewController)
    presentPHSheet(navigationController, animated: true)
  }
  
  @objc
  private func showCollection(_ sender: UIButton) {
    let sheetViewController: CollectionViewController = .init()
    presentPHSheet(sheetViewController, animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  UINavigationController(rootViewController: ViewController())
}
