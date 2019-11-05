//
//  SViewController.swift
//  GraphView
//
//  Created by Всеволод Андрющенко on 04.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class SViewController: UIViewController {
    
    @IBOutlet weak var myGraphView: GraphViewUIView!
    let data = [
        "main&First otdel&D1",
        "main&Second otdel&T1&User22",
        "main&Second otdel&T2&User1",
        "main&First otdel&D2&SubOtdel&User1",
        "main&First otdel&D2&SubOtdel&User2",
        "main&First otdel&D2&SubOtdel&User3",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myGraphView.dataSource = self
        myGraphView.delegate = self
    }
    
}
extension SViewController: GraphViewDataSource, GraphViewDelegate {
    func changedElement(_ graphView: GraphViewUIView, selectedElement: String) {
        print(selectedElement)
    }
    
    func graphViewData(_ graphView: GraphViewUIView) -> [String] {
        return data
    }
}

