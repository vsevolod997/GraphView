//
//  ElementData.swift
//  GraphView
//
//  Created by Всеволод Андрющенко on 30.10.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

protocol ElementDataProtocol {
    var level: Int { get set }
    var position: Int {get set}
    var data: String { get set }
}

class ElementData: ElementDataProtocol, Equatable{
    
    static func == (lhs: ElementData, rhs: ElementData) -> Bool {
        return lhs.data == rhs.data &&
        lhs.level == rhs.level &&
        lhs.position == rhs.position
    }
    
    var position: Int
    var level: Int
    var data: String
    
    init(level: Int, position: Int,  data: String) {
        self.position = position
        self.level = level
        self.data = data
    }
}
