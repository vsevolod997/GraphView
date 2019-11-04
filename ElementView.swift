//
//  ElementView.swift
//  GraphView
//
//  Created by Всеволод Андрющенко on 30.10.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ElementView: UIView {
    
    let label = UILabel()
    
    var text: String?{
        didSet{
            label.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func setup(){
        self.backgroundColor = .red
        self.layer.cornerRadius = 10
        label.frame = CGRect(x: 19, y: 20, width: 110, height: 55)
        label.numberOfLines = 2
        self.addSubview(label)
    }
}
