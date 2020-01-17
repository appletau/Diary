//
//  DiaryWallViewController.swift
//  Diary
//
//  Created by tautau on 2019/12/14.
//  Copyright © 2019 tautau. All rights reserved.
//

import UIKit

class DiaryWallViewController: UIViewController {
    
    lazy var controller:DiaryWallController = {
        return DiaryWallController()
    }()
    var viewModel:DiaryWallViewModel {
        return controller.viewModel
    }
    
    var dataSource: UICollectionViewDiffableDataSource<String, DataSourceItem>! = nil
    
    let titleElementKind = "title-element-kind"
    
    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:setCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        collectionView.register(WallDiaryCell.self,
                                forCellWithReuseIdentifier: WallDiaryCell.cellIdentifier())
        collectionView.register(WallMemberCell.self,
                                forCellWithReuseIdentifier:WallMemberCell.cellIdentifier())
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: self.titleElementKind, withReuseIdentifier: CollectionHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    lazy var loadingIdicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configDataSoure()
        initBinding()
        controller.start()
    }
}

extension DiaryWallViewController {
    func initBinding() {
        viewModel.sectionViewModels.addObserver { [weak self] (sectionViewModels) in
            var snapshot = NSDiffableDataSourceSnapshot<String, DataSourceItem>()
            for sectionVM in sectionViewModels {
                snapshot.appendSections([sectionVM.headerTitle])
                snapshot.appendItems(sectionVM.rowViewModels.map{DataSourceItem(item: $0)} , toSection: sectionVM.headerTitle)
            }
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        viewModel.isLoading.addObserver {[weak self] (isLoading) in
            if isLoading {
                self?.loadingIdicator.startAnimating()
            }else {
                self?.loadingIdicator.stopAnimating()
            }
        }
        
        viewModel.isCollectionViewHidden.addObserver {[weak self] (isHidden) in
            self?.collectionView.isHidden = isHidden
        }
        
        viewModel.title.addObserver { [weak self] (title) in
            self?.navigationItem.title = title
        }
        
    }
}

extension DiaryWallViewController {
    func setCollectionViewLayout() -> UICollectionViewCompositionalLayout{
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.2))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let itemSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.7))
            let item2 = NSCollectionLayoutItem(layoutSize: itemSize2)
            
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                   heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item,item2])
            group.interItemSpacing = .fixed(5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: self.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    func configDataSoure() {
        dataSource = UICollectionViewDiffableDataSource<String,DataSourceItem>(collectionView: collectionView) {[weak self](collectionView: UICollectionView,
            indexPath: IndexPath,
            item: DataSourceItem) -> UICollectionViewCell? in
            
            guard let self = self else {return nil}
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:self.cellIdentifier(for: item.value), for:indexPath)
            if let cell = cell as? CellConfigurable {cell.setup(viewModel: item.value)}
            cell.layoutIfNeeded()
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let self = self else { return nil }
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.reuseIdentifier, for: indexPath) as? CollectionHeaderView else {return nil}
            let header = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView.setTitle(header)
            
            return headerView
        }
    }
    
    func cellIdentifier(for viewModel: CellViewModel) -> String {
        switch viewModel {
        case is DiaryCellViewModel:
            return WallDiaryCell.cellIdentifier()
        case is MemberCellViewModel:
            return WallMemberCell.cellIdentifier()
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
}

