//
//  ViewController.swift
//  GraphView
//
//  Created by Всеволод Андрющенко on 28.10.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var firstX: CGFloat = 10
    var firstY: CGFloat = 30
    var widthView: CGFloat = 0
    var heigtView: CGFloat = 0
    
    let scrollView = UIScrollView()

    let data = [
        "main&First otdel&D1",
        "main&Second otdel&T1&User22",
        "main&Second otdel&T2&User1",
        "main&First otdel&D2&SubOtdel&User1",
        "main&First otdel&D2&SubOtdel&User2",
        "main&First otdel&D2&SubOtdel&User3",
    ]
    
    var outputData: [ElementData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideInputData()
    }
    
    override func viewWillLayoutSubviews() {
        createScrollView()
        createPathView()
        createSubview()
    }
    
    func createScrollView() {
        scrollView.frame = self.view.bounds
        scrollView.indicatorStyle = .white
        scrollView.contentSize = CGSize(width: widthView, height: heigtView)
        self.view.addSubview(scrollView)
    }
    
    //Mark: подготовка данных для отображения
    func overrideInputData() {
        widthView = CGFloat(data.count * 180)
        var maxCount: Int = 0
        let stringData = data.sorted()
        for j in stringData.indices{
            let dataMass = stringData[j].components(separatedBy: "&")
            if dataMass.count > maxCount{
                maxCount = dataMass.count
            }
            for i in dataMass.indices{
                if let oldElem = foundSubElement(subString: dataMass[i], data: outputData){
                    outputData.append(oldElem)
                } else{
                    outputData.append(ElementData(level: i, position: j, data: dataMass[i]))
                }
            }
        }
        heigtView = CGFloat(maxCount * 120)
    }
    
    //Mark: Удаление дублирущих родительских Элементов
    func foundSubElement (subString: String, data: [ElementData]) -> ElementData?{
        for d in data{
            if d.data == subString{
                return d
            }
        }
        return nil
    }
    //Mark: Отображение структуры
    func createSubview() {
        for item in outputData{
            let subView = ElementView()
            subView.text = item.data
            let positionX = 10 + item.position * 170
            let positionY = 50 + item.level * 120
            subView.frame = CGRect(x: positionX, y: positionY, width: 150, height: 100)
            self.scrollView.addSubview(subView)
        }
    }
    //Mark: отображение связей
    func createPathView(){
        for i in outputData.indices{
            if i < outputData.count - 2 && outputData[i].level < outputData[i + 1].level {
                print(outputData[i].data)
                let path = UIBezierPath()
                let layer = CAShapeLayer()
                layer.lineWidth = 10
                layer.strokeColor = UIColor.blue.cgColor
                
                let endPositionX = 10 + outputData[i+1].position * 170
                let endPpositionY = 50 + outputData[i+1].level * 120
                let endPoint = CGPoint(x: endPositionX + 75, y: endPpositionY + 90)
                
                let startPositionX = 10 + outputData[i].position * 170
                let startPpositionY = 50 + outputData[i].level * 120
                let startPoint = CGPoint(x: startPositionX + 75, y: startPpositionY + 90)
                
                path.move(to: startPoint)
                print(startPoint)
                path.addLine(to: endPoint)
                print(endPoint)
                path.close()
                
                layer.path = path.cgPath
                
                self.scrollView.layer.addSublayer(layer)
            }
        }
    }
    
}

