//
//  AppFullscreenDescriptionCell.swift
//  AppStoreLBTA
//
//  Created by Иван on 23.04.2020.
//  Copyright © 2020 vanyacherepkow. All rights reserved.
//

import UIKit

class AppFullscreenDescriptionCell: UITableViewCell {
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "DESC"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(descriptionLabel)
        descriptionLabel.fillSuperview(padding: .init(top: 0, left: 24, bottom: 0, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
