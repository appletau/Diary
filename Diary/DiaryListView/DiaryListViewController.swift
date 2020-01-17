//
//  NewlyDiaryViewController.swift
//  Diary
//
//  Created by tautau on 2019/7/19.
//  Copyright © 2019年 tautau. All rights reserved.
//

import UIKit
import Firebase

class DiaryListViewController: UIViewController {
    
    var viewModel:DiaryListViewModel {
        return controller.viewModel
    }
    
    lazy var controller:DiaryListController = {
        return DiaryListController()
    }()
    
    var dataSource: DiaryListDataSource!
    
    weak var delegate:DiaryListVCDelegate?
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 80),
                                     tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                     tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                     tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)])
        tableView.register(ListMemberCell.self, forCellReuseIdentifier: ListMemberCell.cellIdentifier())
        tableView.register(ListDiaryCell.self, forCellReuseIdentifier: ListDiaryCell.cellIdentifier())
        
        return tableView
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:10),
                                     label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)])
        return label
    }()
    
    lazy var loadingIdicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style:.large)
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
        configDataSource()
        initBinding()
        controller.start()
        setUpUI()
    }
}

extension DiaryListViewController {
    func setUpUI() {
         view.backgroundColor = .white
         navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToEditDiaryVC))
     }
    
    func initBinding() {
        viewModel.sectionViewModels.addObserver { [weak self] (sectionViewModels) in
            var snapshot = NSDiffableDataSourceSnapshot<String, DataSourceItem>()
            for sectionVM in sectionViewModels {
                snapshot.appendSections([sectionVM.headerTitle])
                snapshot.appendItems(sectionVM.rowViewModels.map{DataSourceItem(item: $0)})
            }
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        viewModel.title.addObserver { [weak self] (title) in
            self?.navigationItem.title = title
        }
        
        viewModel.isTableViewHidden.addObserver { [weak self] (isHidden) in
            self?.tableView.isHidden = isHidden
        }
        
        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.loadingIdicator.startAnimating()
            } else {
                self?.loadingIdicator.stopAnimating()
            }
        }
    }
    
    @objc func goToEditDiaryVC() {
        delegate?.goToAddDiary(withVc: self)
    }
}

//:Config DataSource
extension DiaryListViewController {
    func configDataSource() {
        dataSource = DiaryListDataSource(tableView: tableView) { [weak self]
            (tableView: UITableView,
            indexPath: IndexPath,
            item: DataSourceItem) -> UITableViewCell? in
            
            guard let self = self else {return nil}
            let cell = tableView.dequeueReusableCell(withIdentifier:self.cellIdentifier(for: item.value), for:indexPath)
            if let cell = cell as? CellConfigurable {cell.setup(viewModel: item.value)}
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func cellIdentifier(for viewModel: CellViewModel) -> String {
        switch viewModel {
        case is DiaryCellViewModel:
            return ListDiaryCell.cellIdentifier()
        case is MemberCellViewModel:
            return ListMemberCell.cellIdentifier()
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }

}


