//
//  CheckListViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/19.
//

import UIKit
import SwiftUI

class CheckListViewController: UIViewController {
    // test 모델
    private var checkList = [
        CheckListModel(title: "제목없음", emoji: "👍", travelDate: Date(), tasks: []),
        CheckListModel(title: "제목없음", emoji: "👍", travelDate: Date(), tasks: []),
        CheckListModel(title: "제목없음", emoji: "👍", travelDate: Date(), tasks: []),
        CheckListModel(title: "제목없음", emoji: "👍", travelDate: Date(), tasks: [])
    ]
    
    private let editButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: nil,
            action: nil
        )
        barButtonItem.tintColor = .black
        
        return barButtonItem
    }()
    
    private let checkListLabel: UILabel = {
        let label = UILabel()
        label.text = "Checklist"
        label.font = UIFont.customFont(for: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var checklistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CheckListCell.self, forCellWithReuseIdentifier: CheckListCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.setupNavigationBar()
        self.setupLayout()
    }
}

extension CheckListViewController {
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func setupLayout() {
        view.addSubview(checkListLabel)
        view.addSubview(checklistCollectionView)
        
        let guide = view.safeAreaLayoutGuide
        let checkListLabelConstraints = [
            checkListLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            checkListLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            checkListLabel.heightAnchor.constraint(equalToConstant: 22)
        ]
        
        let checklistCollectionViewConstraints = [
            checklistCollectionView.topAnchor.constraint(equalTo: checkListLabel.bottomAnchor, constant: 20),
            checklistCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            checklistCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            checklistCollectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(checkListLabelConstraints)
        NSLayoutConstraint.activate(checklistCollectionViewConstraints)
    }
}

extension CheckListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (UIScreen.main.bounds.width / 2) - 30, height: 165)
        }
}

extension CheckListViewController: UICollectionViewDelegate {
    
}

extension CheckListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.checkList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckListCell.identifier, for: indexPath) as? CheckListCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

struct CheckListViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CheckListViewController

    func makeUIViewController(context: Context) -> CheckListViewController {
        return CheckListViewController()
    }

    func updateUIViewController(_ uiViewController: CheckListViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct CheckListViewControllerPreview: PreviewProvider {
    static var previews: some View {
        CheckListViewControllerRepresentable()
            .ignoresSafeArea()
    }
}