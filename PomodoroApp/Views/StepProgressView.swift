//
//  StepProgressView.swift
//  PomodoroApp
//
//  Created by Necati Alperen IŞIK on 13.08.2024.
//

import UIKit


final class StepProgressView: UIView {

    private let lineLayer = CAShapeLayer()
    private var circleLayers = [CAShapeLayer]()
    private let stepCount = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.bounds.height / 2))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height / 2))
        
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.lineWidth = 2
        lineLayer.lineCap = .round
        self.layer.addSublayer(lineLayer)
        
        for i in 0..<stepCount {
            let circleLayer = CAShapeLayer()
            let radius: CGFloat = 10
            let center = CGPoint(x: CGFloat(i) * self.bounds.width / CGFloat(stepCount - 1), y: self.bounds.height / 2)
            let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            circleLayer.path = circlePath.cgPath
            circleLayer.fillColor = UIColor.white.cgColor
            self.layer.addSublayer(circleLayer)
            circleLayers.append(circleLayer)
        }
    }
}
