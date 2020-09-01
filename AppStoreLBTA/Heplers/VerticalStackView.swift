//
//  VerticalStackView.swift
//  AppStoreLBTA
//
//  Created by Иван on 20.04.2020.
//  Copyright © 2020 vanyacherepkow. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {

    init(arrangedSubviews: [UIView], spacing: CGFloat = 0){
        super.init(frame: .zero)
        
        arrangedSubviews.forEach({addArrangedSubview($0)})
        self.spacing = spacing
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
