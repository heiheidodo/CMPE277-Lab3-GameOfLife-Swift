//
//  Board.swift
//  GameOfLife
//
//  Created by ZHOUSHENG on 5/16/17.
//  Copyright © 2017 Sheng Zhou. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

class Board: UIView {
    
    var matrix : [[Int]] = Array(repeating: Array(repeating: 0, count: 15), count: 15)
    
    let size = 15
    let screenSize: CGRect = UIScreen.main.bounds
    var box : Float!
    var start : Float!
    var touch : UITouch!
    var lastPoint : CGPoint!
    
    //@IBOutlet var nextStage: UIButton!
    @IBOutlet var nextStage: UIButton!
    @IBOutlet var reset: UIButton!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let screenWidth = Float(screenSize.width)
        let screenHeight = Float(screenSize.height)
        
        if screenWidth > screenHeight
        {
            self.box = screenHeight / Float(size)
            self.start = (screenWidth - screenHeight)/2
        }
        else
        {
            self.box = screenWidth / Float(size)
            self.start = (screenHeight - screenWidth)/2
        }
        
        for i in 0...(size-1)
        {
            for j in 0...(size-1)
            {
                if screenWidth > screenHeight
                {
                    let context = UIGraphicsGetCurrentContext()
                    context?.setStrokeColor(UIColor.black.cgColor)
                    let rectangle = CGRect(x: Int(start + Float(i)*box),y: Int(Float(j)*box), width: Int(box),height: Int(box))
                    context?.addRect(rectangle)
                    context?.strokePath()
                    if matrix[i][j] == 1
                    {
                        context?.addEllipse(in: rectangle)
                        context?.setFillColor(UIColor.red.cgColor)
                    }
                    else
                    {
                        let context = UIGraphicsGetCurrentContext()
                        context?.setStrokeColor(UIColor.black.cgColor)
                        let rectangle = CGRect(x: Int(start + Float(i)*box),y: Int(Float(j)*box), width: Int(box),height: Int(box))
                        context?.addRect(rectangle)
                        context?.strokePath()
                    }
                }
                else
                {
                    let context = UIGraphicsGetCurrentContext()
                    context?.setStrokeColor(UIColor.black.cgColor)
                    let rectangle = CGRect(x: Int(Float(i)*box),y: Int(start + Float(j)*box), width: Int(box),height: Int(box))
                    context?.addRect(rectangle)
                    context?.strokePath()

                    if self.matrix[i][j] == 1
                    {
                        context?.addEllipse(in: rectangle)
                        context?.setFillColor(UIColor.red.cgColor)
                        context?.drawPath(using: .fill)
                    }
                    else
                    {
                        context?.addRect(rectangle)
                        context?.strokePath()
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
            let pointX = currentPoint.x
            let pointY = currentPoint.y
            //print(pointX, pointY)
            
            let i = Int(Float(pointX)/Float(box))
            let j = Int((Float(pointY)-start)/Float(box))
            let outer = start + Float(size) * box
            
            if Float(pointY) < Float(start) || Float(pointY) > Float(outer)
            {
                // do nothing
            }
            else
            {
                if self.matrix[i][j] == 0
                {
                    self.matrix[i][j] = 1
                }
                else
                {
                    self.matrix[i][j] = 0
                }
            //print(matrix)
                setNeedsDisplay()
            }
            /*let dot = Board(frame:CGRect(x: Int(pointX), y: Int(pointY), width: 10, height: 10))
            let context = UIGraphicsGetCurrentContext()
            context?.setLineWidth(1.0)
            context?.setStrokeColor(UIColor.blue.cgColor)
            let rectangle = CGRect(x: Int(pointX), y: Int(pointY), width: 10, height: 10)
            context?.addEllipse(in: rectangle)
            context?.strokePath()
            self.addSubview(dot)*/
        }
    }
    
    @IBAction func resetAll(_ sender: Any)
    {
        let alert = UIAlertController(title: "Warning",
                                      message: "Do you still want to reset the board?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertActionStyle.cancel,
                                      handler: nil))
        
        alert.addAction(UIAlertAction(title: "Reset",
                                      style: UIAlertActionStyle.default,
                                      handler: { (action : UIAlertAction!) -> Void in
                                        self.matrix = Array(repeating: Array(repeating: 0, count: 15), count: 15)
                                        self.setNeedsDisplay()
        }))
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func generateBoard(_ sender: Any)
    {
        algorithm()
        self.setNeedsDisplay()
    }
    
    func algorithm()
    {
        for i in 0..<size
        {
            for j in 0..<size
            {
                var count = 0;
                
                for a in max(i-1, 0)..<min(i+2, size)
                {
                    for b in max(j-1, 0)..<min(j+2, size)
                    {
                        count = count + Int(matrix[a][b] & 1)
                    }
                }
                
                if count == 3 || (count - matrix[i][j] == 3)
                {
                    self.matrix[i][j] |= 2
                }
            }
        }
        
        for i in 0..<size
        {
            for j in 0..<size
            {
                self.matrix[i][j] >>= 1
            }
        }
        //print(matrix)
    }
}
