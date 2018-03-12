//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//
//  GraphView.swift
//  CarbonApp
//
//  Created by Kamal Popat on 14/10/2016.
//  Copyright © 2016 CarbonNV Ltd. All rights reserved.
//

import UIKit

protocol GraphViewModelable {
    var prices: [(Date, Double)] { get }
    var lineColours: [CGColor] { get }
    var lineWidth: CGFloat { get }
    var showOriginLine: Bool { get }
    var maxValue: Double { get }
    var minValue: Double { get }
    var range: Double { get }
}

extension GraphViewModelable {
    var maxValue: Double {
        get {
            return prices.max(by: {$0.1 < $1.1})!.1
        }
    }
    
    var minValue: Double {
        get {
            return prices.min(by: {$0.1 < $1.1})!.1
        }
    }
    
    var range: Double {
        get {
            return maxValue - minValue
        }
    }
}

class MockGraphViewModel: GraphViewModelable {
    var prices: [(Date, Double)]
    var lineColours: [CGColor] = [UIColor.orange.cgColor, UIColor.blue.cgColor]
    var lineWidth: CGFloat = 2.5
    var showOriginLine: Bool = false
    
    private static func absBufferAverage(_ buffer:[Double]) -> Double {
        var total:Double = 0
        buffer.forEach {
            total = total + $0
        }
        return abs(total / Double(buffer.count))
    }
    
    // TODO(Olivier): Make this better
    init() {
        let numDays = Int(arc4random_uniform(50)) + 50
        var data = [(Date(), Double(arc4random_uniform(50)) - 50)]
        var buffer = [Double(arc4random_uniform(100)) - 50]
        var firstPrice = data.first!.1
        
        for index in 0..<numDays {
            if Int(arc4random_uniform(20)) == 1 {
                continue
            }
            let date = Date() - (Double(index) * 24 * 60 * 60)
            
            let sign:Double = Int(arc4random_uniform(1)) == 1 ? 1 : -1
            let bufferShuffle = MockGraphViewModel.absBufferAverage(buffer) * Double(arc4random_uniform(4)) + 0.5
            let firstPriceShuffle = (firstPrice)*Double(arc4random_uniform(3) + 1)
            let deltaPrice = (bufferShuffle / firstPriceShuffle) * sign
            let lastPrice = data.last!.1
            data.append((date, (firstPrice+lastPrice/2) + deltaPrice))
            buffer.append(lastPrice + deltaPrice)
            if buffer.count > 7 {
                _ = buffer.removeFirst()
            }
            if Int(arc4random_uniform(20)) == 10 {
                firstPrice = abs(deltaPrice + firstPrice) / 2 * sign
            }
        }
        self.prices = data
    }
}

class GraphViewController: UIViewController {
    
    let graphColor = UIColor.cyan
    
    var originLine: CAShapeLayer?
    var simpleLine: CAShapeLayer?
    var gradientLine: CAGradientLayer?
    
    var viewModel: GraphViewModelable? {
        didSet{
            self.view.setNeedsLayout()
        }
    }
    
    class func getMockInstance() -> GraphViewController {
        let viewControllerInstance = GraphViewController()
        viewControllerInstance.viewModel = MockGraphViewModel()
        return viewControllerInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.graphColor.setFill()
        self.graphColor.setStroke()
    }
    
    override func viewWillLayoutSubviews() {
        self.updateGraph()
    }
    
    func updateGraph(){
        self.originLine?.removeFromSuperlayer()
        self.simpleLine?.removeFromSuperlayer()
        self.gradientLine?.removeFromSuperlayer()
        
        guard let viewModel = self.viewModel, let _ = viewModel.prices.first else {
            return
        }
        let data = viewModel.prices
        let lineWidth:CGFloat = viewModel.lineWidth
        let width = self.view.frame.width - lineWidth * 2
        let height = self.view.frame.height - (lineWidth * 4)
        let colX = { (column:Int) -> CGFloat in
            let columns = CGFloat(data.count - 1)
            return (CGFloat(column) * width/columns) + lineWidth
        }
        let colY = { (graphPoint:Double) -> CGFloat in
            let y = (height - (((CGFloat(graphPoint) - CGFloat(viewModel.minValue)) /
                CGFloat(viewModel.range)) * height))
            return y + (lineWidth * 2)
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x:colX(0), y:colY(data[0].1)))
        for i in 1..<data.count {
            let nextPoint = CGPoint(x: colX(i), y: colY(data[i].1))
            path.addLine(to: nextPoint)
        }
        
        if viewModel.showOriginLine {
            let originPath = UIBezierPath()
            originPath.move(to: CGPoint(x:colX(0), y:colY(data[0].1)))
            let endPoint = CGPoint(x:colX(data.count - 1), y:colY(data[0].1))
            originPath.addLine(to: endPoint)
            
            let lineShape = CAShapeLayer()
            lineShape.frame = self.view.frame
            lineShape.path = originPath.cgPath
            lineShape.frame.origin = CGPoint.zero
            lineShape.fillColor = UIColor.clear.cgColor
            lineShape.lineWidth = 1
            lineShape.lineDashPattern = [1,6]
            lineShape.strokeColor = UIColor.red.cgColor
            self.simpleLine = lineShape
            self.view.layer.addSublayer(lineShape)
        }
        
        if viewModel.lineColours.count > 1 {
            let outlinePath = path.cgPath.copy(strokingWithWidth: lineWidth, lineCap: .round, lineJoin: .bevel, miterLimit: lineWidth)
            let gradient = CAGradientLayer()
            gradient.frame = self.view.frame
            gradient.frame.origin = CGPoint.zero
            gradient.colors = viewModel.lineColours
            
            let gradientMask = CAShapeLayer()
            gradientMask.path = outlinePath
            gradient.mask = gradientMask
            self.gradientLine = gradient
            self.view.layer.addSublayer(gradient)
        } else {
            let lineShape = CAShapeLayer()
            lineShape.frame = self.view.frame
            lineShape.path = path.cgPath
            lineShape.frame.origin = CGPoint.zero
            lineShape.fillColor = UIColor.clear.cgColor
            lineShape.lineWidth = lineWidth
            lineShape.strokeColor = viewModel.lineColours[0]
            self.simpleLine = lineShape
            self.view.layer.addSublayer(lineShape)
        }
    }
    
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .green
        self.view = view
    }
    
    override func viewWillAppear(_ animated:Bool) {
        let graphViewController = GraphViewController.getMockInstance()
        self.addChildViewController(graphViewController)
        view.addSubview(graphViewController.view)
        graphViewController.view.frame = CGRect(x: 10, y: 10, width: 300, height: 300)
        graphViewController.view.backgroundColor = .white
        graphViewController.didMove(toParentViewController: self)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
