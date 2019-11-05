//
//  GraphViewUIView.swift
//  GraphView
//
//  Created by Всеволод Андрющенко on 04.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

protocol GraphViewDataSource{
    func graphViewData(_ graphView: GraphViewUIView) -> [String]
}

protocol GraphViewDelegate {
    func changedElement(_ graphView: GraphViewUIView, selectedElement: String)
}


class GraphViewUIView: UIView {
    
    var firstX: CGFloat = 10
    var firstY: CGFloat = 30
    var widthView: CGFloat = 0
    var heigtView: CGFloat = 0
    
    var outputData: [ElementData] = []
    
    let scrollView = UIScrollView()
    let backgroundView = UIView()
    
    public var dataSource: GraphViewDataSource?{
        didSet{
            setupView()
        }
    }
    
    public var delegate: GraphViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView(){
        self.backgroundColor = .clear
        
        overrideInputData()
        createScrollView()
        createPathView()
        createSubview()
    }
    
    private func createScrollView() {
        scrollView.frame = self.bounds
        scrollView.indicatorStyle = .white
        scrollView.contentSize = CGSize(width: widthView, height: heigtView)
        scrollView.minimumZoomScale = 0.5 // 20 % от нормального размера
        scrollView.maximumZoomScale = 1.5
        scrollView.delegate = self
        
        backgroundView.backgroundColor = .clear
        backgroundView.frame = CGRect(x: 0.0, y: 0.0, width: widthView, height: heigtView)
        scrollView.addSubview(backgroundView)
        self.addSubview(scrollView)
    }
    
    //Mark: подготовка данных для отображения
    private func overrideInputData() {
        guard let data = dataSource?.graphViewData(self) else { return }
        widthView = CGFloat(data.count * 180)
        var maxCount: Int = 0
        let stringData = data.sorted()
        for j in stringData.indices{
            let dataMass = stringData[j].components(separatedBy: "&")
            if dataMass.count > maxCount{
                maxCount = dataMass.count
            }
            for i in dataMass.indices{
                if let oldElem = ElementData.foundSubElement(subString: dataMass[i], data: outputData){
                    outputData.append(oldElem)
                } else{
                    outputData.append(ElementData(level: i, position: j, data: dataMass[i]))
                }
            }
        }
        heigtView = CGFloat(maxCount * 140)
    }
    
    //Mark: создание блоков предствлений
    private func createSubview() {
        for item in outputData{
            let subView = ElementView()
            subView.text = item.data
            let positionX = 10 + item.position * 170
            let positionY = 50 + item.level * 140
            subView.frame = CGRect(x: positionX, y: positionY, width: 150, height: 100)
            self.backgroundView.addSubview(subView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(changeView(sender:)))
            subView.addGestureRecognizer(tap)
        }
    }
    
    @objc func changeView( sender: UITapGestureRecognizer){
        let view = sender.view as! ElementView
        if let name = view.text{
            delegate?.changedElement(self, selectedElement: name)
        }
    }
    
    //Mark: отображение связей
    private func createPathView(){
        for i in outputData.indices{
            if i < outputData.count - 2 && outputData[i].level < outputData[i + 1].level {
                let path = UIBezierPath()
                let layer = CAShapeLayer()
                layer.lineWidth = 10
                layer.strokeColor = UIColor.lightGray.cgColor
                
                let endPositionX = 10 + outputData[i+1].position * 170
                let endPpositionY = 50 + outputData[i+1].level * 140
                let endPoint = CGPoint(x: endPositionX + 75, y: endPpositionY + 20)
                
                let startPositionX = 10 + outputData[i].position * 170
                let startPpositionY = 50 + outputData[i].level * 140
                let startPoint = CGPoint(x: startPositionX + 75, y: startPpositionY + 95)
                
                path.move(to: startPoint)
                path.addLine(to: endPoint)
                path.close()
                
                layer.path = path.cgPath
                
                self.backgroundView.layer.addSublayer(layer)
            }
        }
    }
}
extension GraphViewUIView: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return backgroundView
    }
}
