//
//  ViewController.swift
//  MotionGraph
//
//  Created by Kj Drougge on 2014-12-10.
//  Copyright (c) 2014 kj. All rights reserved.
//
import UIKit
import CoreMotion

class ViewController: UIViewController{
    
    var linechart = LineChart()
    var label = UILabel()
    var views: Dictionary<String, AnyObject> = [:]
    var list: [CGFloat] = [3, 4 , 9 , 11  ,13, 15]
    
    var xList: Array<CGFloat> = []
    var yList: Array<CGFloat> = []
    var zList: Array<CGFloat> = []
    
    let manager = CMMotionManager()
    let motionQueue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if manager.accelerometerAvailable{
            manager.accelerometerUpdateInterval = 1
            manager.startAccelerometerUpdatesToQueue(motionQueue, withHandler: showValues)
            
            label.text = "Accelorometer"
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            label.textAlignment = NSTextAlignment.Center
            self.view.addSubview(label)
            views["label"] = label
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: nil, metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: nil, metrics: nil, views: views))
            
            linechart.addLine(list)
            //linechart.areaUnderLinesVisible = true
            self.view.addSubview(linechart)
            
            linechart.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            views["chart"] = linechart
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: nil, metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: nil, metrics: nil, views: views))
        }
    }
    
    func showValues(motion: CMAccelerometerData!, error: NSError!){
        
        var x = motion.acceleration.x
        var y = motion.acceleration.y
        var z = motion.acceleration.z
        
        if xList.count == 10 {
            xList.removeAtIndex(0)
            yList.removeAtIndex(0)
            zList.removeAtIndex(0)
        }
        
        xList.append(CGFloat(x))
        yList.append(CGFloat(y))
        zList.append(CGFloat(z))
        
        dispatch_async(dispatch_get_main_queue(), {
            
            if self.xList.count > 2 {
                self.linechart.clear()
                
                self.linechart.addLine(self.xList)
                self.linechart.addLine(self.yList)
                self.linechart.addLine(self.zList)
                
                self.view.addSubview(self.linechart)
                self.linechart.setTranslatesAutoresizingMaskIntoConstraints(false)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}