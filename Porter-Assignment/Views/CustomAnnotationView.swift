//
//  CustomAnnotationView.swift
//  Porter-Assignment
//
//  Created by Ravi Tripathi on 01/12/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import UIKit
import MapKit

protocol CustomAnnotationViewDelegate {
    func bookNowTapped()
}

class CustomAnnotationView: MKAnnotationView {
    
    private let inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    private let bubbleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.blue.cgColor
        layer.lineWidth = 0.5
        return layer
    }()
    var delegate: CustomAnnotationViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updatePath()
    }
    
    func updatePath() {
        let path = UIBezierPath()
        var point: CGPoint = CGPoint(x: bounds.size.width - inset.right, y: bounds.size.height - inset.bottom)
        var controlPoint: CGPoint
        path.move(to: point)
        point = CGPoint(x: bounds.size.width / 2.0 + inset.bottom, y: bounds.size.height - inset.bottom)
        path.addLine(to: point)
        controlPoint = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        controlPoint = CGPoint(x: point.x, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: point.x - inset.bottom, y: controlPoint.y)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        point.x = inset.left
        path.addLine(to: point)
        controlPoint = CGPoint(x: 0, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: 0, y: controlPoint.y - inset.left)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        point.y = inset.top
        path.addLine(to: point)
        controlPoint = CGPoint.zero
        point = CGPoint(x: inset.left, y: 0)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        point = CGPoint(x: bounds.size.width - inset.left, y: 0)
        path.addLine(to: point)
        controlPoint = CGPoint(x: bounds.size.width, y: 0)
        point = CGPoint(x: bounds.size.width, y: inset.top)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        point = CGPoint(x: bounds.size.width, y: bounds.size.height - inset.bottom - inset.right)
        path.addLine(to: point)
        controlPoint = CGPoint(x: bounds.size.width, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: bounds.size.width - inset.right, y: bounds.size.height - inset.bottom)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        path.close()
        bubbleLayer.path = path.cgPath
        layer.insertSublayer(bubbleLayer, at: 0)
    }
    
    @IBAction func bookNowTapped(_ sender: Any) {
        print("Button tapped")
        delegate?.bookNowTapped()
    }    
}
