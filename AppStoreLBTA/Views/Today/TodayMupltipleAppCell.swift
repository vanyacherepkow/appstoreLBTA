//
//  TodayMupltipleAppCell.swift
//  AppStoreLBTA
//
//  Created by Иван on 24.04.2020.
//  Copyright © 2020 vanyacherepkow. All rights reserved.
//

import UIKit

class TodayMupltipleAppCell: BaseTodayCell {
    
    override var todayItem: TodayItem!{
        didSet{
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            
            multipleAppsController.apps = todayItem.apps
            multipleAppsController.collectionView.reloadData()
        }
    }
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    
    let titleLabel = UILabel(text: "Utilazing your Time", font: .boldSystemFont(ofSize: 32), numberOfLines: 2)
    
    let multipleAppsController = TodayMultipleAppsController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 16
        
        let stackView = VerticalStackView(arrangedSubviews: [
        categoryLabel,
        titleLabel,
        multipleAppsController.view
        ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
