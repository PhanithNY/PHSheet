//
//  CollectionViewController.swift
//  PHSheetDemo
//
//  Created by Suykorng on 31/5/24.
//

import PHSheet
import UIKit

final class CollectionViewController: UIViewController, PHContentInsetPresentable {
  
  var sheetDismissOnTap: Bool {
    true
  }
  
  var sheetDismissible: Bool {
    true
  }
  
  var sheetShortFormHeight: CGFloat {
    let navigationBarHeight: CGFloat = navigationController?.navigationBar.bounds.height ?? 0.0
    let contentInset: CGFloat = collectionView.contentInset.top + collectionView.contentInset.bottom
    let collectionViewHeight: CGFloat = collectionViewContentHeight + contentInset
    let finalHeight: CGFloat = navigationBarHeight + collectionViewHeight
    return finalHeight
  }
  
  var sheetLongFormHeight: CGFloat {
    sheetShortFormHeight
  }
  
  var sheetTransitionManager: (any UIViewControllerTransitioningDelegate)?
  
  var sheetScrollView: UIScrollView? {
    nil
  }
  
  // MARK: - Properties
  
  private let inset: CGFloat = 16
  private var collectionViewContentHeight: CGFloat = 500
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = inset/2
    layout.minimumInteritemSpacing = inset/2
    layout.sectionInset.bottom = 32
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.contentInset = .init(top: inset*3, left: inset, bottom: inset, right: inset)
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()
  
  // MARK: - Lifecycle
  
  override var prefersHomeIndicatorAutoHidden: Bool {
    true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareLayouts()
//    perform(#selector(updateLayouts), with: nil, afterDelay: 0.35)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    collectionView.frame = view.bounds
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    view.layoutIfNeeded()
    collectionViewContentHeight = collectionView.contentSize.height
    setNeedsUpdateOfHomeIndicatorAutoHidden()
  }
  
  // MARK: - Actions
  
  @objc
  private func didTap(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @objc
  private func updateLayouts() {
    sheetTransition(to: .shortForm)
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    2
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    section == 0 ? 4 : 2
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
    cell.squircle()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if section == 0 {
      return .init(top: 0, left: 0, bottom: 32, right: 0)
    }
    
    return .init(top: 0, left: 0, bottom: inset, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxWidth: CGFloat = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - 8
    let width: CGFloat = maxWidth / 2 - 8
    return CGSize(width: width, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath)
  }
}

// MARK: - Layouts

extension CollectionViewController {
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
    navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(didTap(_:)))
    
    view.addSubview(collectionView)
  }
}
