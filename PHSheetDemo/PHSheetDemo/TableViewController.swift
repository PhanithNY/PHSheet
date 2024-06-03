//
//  TableViewController.swift
//  PHSheetDemo
//
//  Created by Suykorng on 31/5/24.
//

import PHSheet
import UIKit

final class TableViewController: UIViewController, PHContentInsetPresentable {
  
  enum Form {
    case short
    case long
  }
  
  var sheetDismissOnTap: Bool {
    true
  }
  
  var sheetDismissible: Bool {
    true
  }
  
  var sheetShortFormHeight: CGFloat {
    view.bounds.width - 16
  }
  
  var sheetLongFormHeight: CGFloat {
    UIScreen.main.bounds.height * 0.9
  }
  
  var sheetTransitionManager: (any UIViewControllerTransitioningDelegate)?
  
  var sheetScrollView: UIScrollView? {
    tableView
  }
  
  // MARK: - Properties
  
  private var form: Form = .short {
    didSet {
      switch form {
      case .short:
        sheetTransition(to: .shortForm)
        
      case .long:
        sheetTransition(to: .longForm)
      }
    }
  }
  
  private lazy var tableView = UITableView(frame: .zero, style: .plain).config {
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    $0.dataSource = self
    $0.delegate = self
  }
  
  private lazy var actionButton = UIButton(type: .system).config {
    $0.setTitle("Transition to Long Form", for: .normal)
    if let font = $0.titleLabel?.font {
      $0.titleLabel?.font = UIFont.systemFont(ofSize: font.pointSize, weight: .medium)
    }
    $0.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
  }
  
  // MARK: - Lifecycle
  
  override var prefersHomeIndicatorAutoHidden: Bool {
    true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareLayouts()
  }
  
  // MARK: - Actions
  
  @objc
  private func didTap(_ sender: UIButton) {
    switch form {
    case .short:
      form = .long
      actionButton.setTitle("Transition to Short Form", for: .normal)
      
    case .long:
      form = .short
      actionButton.setTitle("Transition to Long Form", for: .normal)
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    5
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = "Cell at index \(indexPath.row)"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let viewController = TableViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

// MARK: - Layouts

extension TableViewController {
  private func prepareLayouts() {
    title = "Navigation Title"
    view.backgroundColor = .systemBackground
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.shadowColor = UIColor.clear
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.tintColor = .systemGray2
    
    actionButton.layout {
      view.addSubview($0)
      $0.leading(16)
        .trailing(16)
        .bottom(constraint: view.safeAreaLayoutGuide.bottomAnchor)
        .height(52)
    }
    
    tableView.layout {
      view.addSubview($0)
      $0.top()
        .leading()
        .trailing()
        .bottom(constraint: actionButton.topAnchor, 16)
    }
  }
}
