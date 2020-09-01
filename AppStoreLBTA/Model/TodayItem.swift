//
//  TodayItem.swift
//  AppStoreLBTA
//
//  Created by Иван on 24.04.2020.
//  Copyright © 2020 vanyacherepkow. All rights reserved.
//

import UIKit

struct TodayItem {
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    let cellType: CellType
    
    let apps: [FeedResult]
    
    enum CellType: String{
        case single, multiple
    }
}
