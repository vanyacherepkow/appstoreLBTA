//
//  TodayController.swift
//  AppStoreLBTA
//
//  Created by Иван on 23.04.2020.
//  Copyright © 2020 vanyacherepkow. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
//    let items = [
        
//        TodayItem.init(category: "Holidays", title: "Travel on a budget", image: #imageLiteral(resourceName: "holiday"), description: "Find all you need to know on how to travel without packing everything", backgroundColor: #colorLiteral(red: 0.9851021171, green: 0.9690124393, blue: 0.720505178, alpha: 1), cellType: .single)
//    ]
    
    var items = [TodayItem]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = #colorLiteral(red: 0.9424175127, green: 0.9424175127, blue: 0.9424175127, alpha: 1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMupltipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        let topBar = UIView(frame: UIApplication.shared.statusBarFrame)
        topBar.backgroundColor = #colorLiteral(red: 0.9424175127, green: 0.9424175127, blue: 0.9424175127, alpha: 1)
        view.addSubview(topBar)
    }
    
    fileprivate func fetchData(){
        
        let dispatchGroup = DispatchGroup()
        
        var topGrossingGroup: AppGroup?
        var gamesGroup: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, err) in
            topGrossingGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, err) in
            gamesGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main){
            self.activityIndicatorView.stopAnimating()
            
            self.items = [
                TodayItem.init(category: "Daily List", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
                TodayItem.init(category: "Daily List", title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),
                TodayItem.init(category: "LIFE HACK", title: "Utilizing yout time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the rigth way", backgroundColor: .white, cellType: .single, apps: [])
            ]
            
            self.collectionView.reloadData()
        }
        
    }
    
    var appFullscreenController: AppFullscreenController!
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if items[indexPath.item].cellType == .multiple{
            let fullController = TodayMultipleAppsController(mode: .fullscreen)
            fullController.apps = self.items[indexPath.item].apps
            present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
            return
        }
        
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        addChild(appFullscreenController)
        
        self.appFullscreenController = appFullscreenController
        
        self.collectionView.isUserInteractionEnabled = false
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else {return}
        
        self.startingFrame = startingFrame
        
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: startingFrame.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach ({$0?.isActive = true})
        
        fullscreenView.layer.cornerRadius = 16
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
//            appFullscreenView.frame = self.view.frame
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else {return}
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    var startingFrame: CGRect?
    
    @objc func handleAppFullscreenDismiss(gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
//            self.appFullscreenController.tableView.contentOffset = .zero
            self.appFullscreenController.tableView.scrollToRow(at: [0,0], at: .top, animated: true)
            
            guard let startingFrame = self.startingFrame else {return}
            
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            if let tabBarFrame = self.tabBarController?.tabBar.frame{
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else {return}
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            gesture.view?.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = items[indexPath.item].cellType.rawValue
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMupltipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTaps))))
        
        return cell
    }
    
    @objc func handleMultipleAppsTaps(gesture: UIGestureRecognizer){
        
        let collectionView = gesture.view
        
        var superview = collectionView?.superview
        
        while superview != nil{
            if let cell = superview as? TodayMupltipleAppCell{
                guard let indexPath = self.collectionView.indexPath(for: cell) else {return}
                let apps = self.items[indexPath.item].apps
                
                let fullControlelr = TodayMultipleAppsController(mode: .fullscreen)
                fullControlelr.apps = apps
                present(fullControlelr, animated: true)
            }
            superview = superview?.superview
        }
    }
    
    static let cellSize: CGFloat = 500
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
