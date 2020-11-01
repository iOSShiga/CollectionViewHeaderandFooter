//
//  ViewController.swift
//  CollectionViewHeaderandFooter
//
//  Created by Suresh Shiga on 01/11/20.
//

import UIKit

struct AppSectionList: Hashable {
    let htitle: String
    let ftitle: String
    let cellList: [AppCellList]
}

struct AppCellList: Hashable {
    let title: String
    let symbolName: String?
    
    init(title: String, symbolName: String?) {
        self.title      = title
        self.symbolName = symbolName
    }
}

let appList = [
    AppSectionList(htitle: "Device", ftitle: "Device Specific Settings", cellList: [AppCellList(title: "Airplane Mode", symbolName: "airplane.circle.fill"),AppCellList(title: "Wi-Fi", symbolName: "wifi"),AppCellList(title: "Mobile Data", symbolName: "antenna.radiowaves.left.and.right"),AppCellList(title: "Personal Hotspot", symbolName: "personalhotspot")]),
    
    AppSectionList(htitle: "Application", ftitle: "Application Specific Settings", cellList: [AppCellList(title: "Account", symbolName: "key.fill"),AppCellList(title: "Starred Messages", symbolName: "star.fill"),AppCellList(title: "Tell a Friend", symbolName: "suit.heart.fill")]),
    
    AppSectionList(htitle: "Music", ftitle: "Hollywood Songs", cellList: [AppCellList(title: "Happiness", symbolName: ""),AppCellList(title: "Baby, I'm Jealous", symbolName: ""),AppCellList(title: "Mad at Disney", symbolName: ""),AppCellList(title: "Spell on Me", symbolName: ""),AppCellList(title: "Commander In Chief", symbolName: "")]),
]

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView! = nil
    private var datasource: UICollectionViewDiffableDataSource<AppSectionList, AppCellList>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureHierarchy()
    }

    
    func configureHierarchy()  {
        
        
        // create list layout
        
        var layoutListConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutListConfig.headerMode = .supplementary
        layoutListConfig.footerMode = .supplementary
        
        let layout = UICollectionViewCompositionalLayout.list(using: layoutListConfig)
        
        // configure CollectionView
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview( collectionView)
        
        // cell registration
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, AppCellList> { (cell, indexPath, list) in
            
            var config = cell.defaultContentConfiguration()
            
            config.text = list.title
            
            if let symbolName = list.symbolName {
                config.image = UIImage(systemName: symbolName)
            }
            
            cell.contentConfiguration = config
        }
        
        // datasource initialization
        
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, list) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: list)
            return cell
        })
        
        
        // configure headerview
        
        
        let configHeaderView = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { (headerView, element, indexPath) in
            
            let headerItem = appList[indexPath.section]
            
            var config = headerView.defaultContentConfiguration()
            
            config.text = headerItem.htitle
            
            config.textProperties.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
            config.textProperties.color = .systemBlue
            
            config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 30.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
            
            headerView.contentConfiguration = config
        }
        
        
        // configure footerview
        
        let configFooterView = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) { (footerView, element, indexPath) in
            
            
            let footerItem = appList[indexPath.section]
            
            var config = footerView.defaultContentConfiguration()
            
            config.text = footerItem.ftitle
            
            footerView.contentConfiguration = config
        }
        
        // add header and footer to datasource
        
        datasource.supplementaryViewProvider = {
            (collectionView, elementKind, indexPath) -> UICollectionReusableView in
            
            if elementKind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: configHeaderView, for: indexPath)
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(using: configFooterView, for: indexPath)
            }
        }
        
        // snapshot
        
        var snapshot = NSDiffableDataSourceSnapshot<AppSectionList, AppCellList>()
        
        snapshot.appendSections(appList)
        
        for list in appList {
            
            snapshot.appendItems(list.cellList, toSection: list)
        }
        
        datasource.apply(snapshot, animatingDifferences: true)
        
    }

}

