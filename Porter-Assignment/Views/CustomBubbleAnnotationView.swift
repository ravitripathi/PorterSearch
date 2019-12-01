//
//  CustomBubbleAnnotationView.swift
//  Porter-Assignment
//
//  Created by Ravi Tripathi on 01/12/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import UIKit
import MapKit

class CustomBubbleAnnotationView: MKAnnotationView {
    
    private let inset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
    
    private let bubbleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.blue.cgColor
        layer.lineWidth = 0.5
        return layer
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    override func awakeFromNib() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top / 2.0),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom - inset.right / 2.0),
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset.left / 2.0),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset.right / 2.0),
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: inset.left + inset.right),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: inset.top + inset.bottom)
        ])
        layer.insertSublayer(bubbleLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updatePath()
    }
    
    private func updatePath() {
        let path = UIBezierPath()
        var point: CGPoint = CGPoint(x: bounds.size.width - inset.right, y: bounds.size.height - inset.bottom)
        var controlPoint: CGPoint
        
        path.move(to: point)
        // lower right
        point = CGPoint(x: bounds.size.width / 2.0 + inset.bottom, y: bounds.size.height - inset.bottom)
        path.addLine(to: point)
        
        // right side of arrow
        
        controlPoint = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // left of pointer
        controlPoint = CGPoint(x: point.x, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: point.x - inset.bottom, y: controlPoint.y)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        // bottom left
        
        point.x = inset.left
        path.addLine(to: point)
        
        // lower left corner
        
        controlPoint = CGPoint(x: 0, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: 0, y: controlPoint.y - inset.left)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // left
        
        point.y = inset.top
        path.addLine(to: point)
        
        // top left corner
        
        controlPoint = CGPoint.zero
        point = CGPoint(x: inset.left, y: 0)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // top
        
        point = CGPoint(x: bounds.size.width - inset.left, y: 0)
        path.addLine(to: point)
        
        // top right corner
        
        controlPoint = CGPoint(x: bounds.size.width, y: 0)
        point = CGPoint(x: bounds.size.width, y: inset.top)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // right
        
        point = CGPoint(x: bounds.size.width, y: bounds.size.height - inset.bottom - inset.right)
        path.addLine(to: point)
        
        // lower right corner
        
        controlPoint = CGPoint(x: bounds.size.width, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: bounds.size.width - inset.right, y: bounds.size.height - inset.bottom)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        path.close()
        
        bubbleLayer.path = path.cgPath
    }

}

