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
    
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var graphLabel: UILabel!
    var selectedChart = 0
    
    var Xarray: [Float]! = []
    var Yarray: [Float]! = []
    var Zarray: [Float]! = []
    
    let manager = CMMotionManager()
    let motionQueue = NSOperationQueue()
    
    var series: ChartSeries!
    var series2: ChartSeries!
    var series3: ChartSeries!
    
    var xValue: Double = 0.0;
    var yValue: Double = 0.0;
    var zValue: Double = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGraph()
    }
    
    func startGraph(){
        chart.minY = -1
        chart.maxY = 1
        
        for(var i = 0; i < 30; i++){
            Xarray.append(Float(0));
            Yarray.append(Float(0));
            Zarray.append(Float(0));
        }
        
        series = ChartSeries(Xarray)
        series2 = ChartSeries(Yarray)
        series3 = ChartSeries(Zarray)
        
        series.color = UIColor.blueColor()
        series2.color = UIColor.redColor()
        series3.color = UIColor.yellowColor()
        
        chart.addSeries(series)
        chart.addSeries(series2)
        chart.addSeries(series3)
        
        switch selectedChart{
        case 0:
            println("Accelerometer")
            if manager.accelerometerAvailable{
                graphLabel.text = "Accelerometer"
                manager.accelerometerUpdateInterval = 1.0 / 30.0
                manager.startAccelerometerUpdatesToQueue(motionQueue, withHandler:
                    {(data: CMAccelerometerData!, error: NSError!) in
                        
                        self.xValue = (data.acceleration.x * 0.3) + (self.xValue * (1.0 - 0.3))
                        self.yValue = (data.acceleration.y * 0.3) + (self.yValue * (1.0 - 0.3))
                        self.zValue = (data.acceleration.z * 0.3) + (self.zValue * (1.0 - 0.3))
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.updateGraph(Float(self.xValue), y:Float(self.yValue),z: Float(self.zValue));
                        })
                })
            }
            
        case 1:
            println("Gyroscope")
            if manager.gyroAvailable{
                graphLabel.text = "Gyroscope"
                manager.gyroUpdateInterval = 1.0 / 30.0
                manager.startGyroUpdatesToQueue(motionQueue, withHandler:
                    {(data: CMGyroData!, error: NSError!) in
                        
                        self.xValue = (data.rotationRate.x * 0.3) + (self.xValue * (1.0 - 0.3))
                        self.yValue = (data.rotationRate.y * 0.3) + (self.yValue * (1.0 - 0.3))
                        self.zValue = (data.rotationRate.z * 0.3) + (self.zValue * (1.0 - 0.3))
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.updateGraph(Float(self.xValue), y:Float(self.yValue),z: Float(self.zValue));
                        })
                })
            }
            
        case 2:
            println("Magnetometer")
            if manager.magnetometerAvailable{
                graphLabel.text = "Magnetometer"
                manager.magnetometerUpdateInterval = 1.0 / 30.0
                manager.startMagnetometerUpdatesToQueue(motionQueue, withHandler:
                    {(data: CMMagnetometerData!, error: NSError!) in
                        
                        self.xValue = (data.magneticField.x * 0.3) + (self.xValue * (1.0 - 0.3))
                        self.yValue = (data.magneticField.y * 0.3) + (self.yValue * (1.0 - 0.3))
                        self.zValue = (data.magneticField.z * 0.3) + (self.zValue * (1.0 - 0.3))
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.updateGraph(Float(self.xValue), y:Float(self.yValue),z: Float(self.zValue));
                        })
                })
            }
            
        default:
            break
        }
    }
    
    func stopGraph(){
        self.manager.stopAccelerometerUpdates()
        self.manager.stopGyroUpdates()
        self.manager.stopMagnetometerUpdates()
        
        Xarray.removeAll()
        Yarray.removeAll()
        Zarray.removeAll()
        chart.removeSeries()
    }
    
    override func viewDidDisappear(animated: Bool) {
        println("viewDidDisappear")
        stopGraph()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGraph(x:Float, y:Float, z:Float){
        
        self.chart.removeSeries()
        
        if self.Xarray.count > 30{
            Xarray.removeAtIndex(0)
            Yarray.removeAtIndex(0)
            Zarray.removeAtIndex(0)
        }
        
        self.Xarray.append(Float(x))
        self.Yarray.append(Float(y))
        self.Zarray.append(Float(z))
        
        series = ChartSeries(Xarray)
        series2 = ChartSeries(Yarray)
        series3 = ChartSeries(Zarray)
        
        series.color = ChartColors.greenColor()
        series2.color = ChartColors.redColor()
        series3.color = ChartColors.blueColor()
        
        chart.addSeries(series)
        chart.addSeries(series2)
        chart.addSeries(series3)
        
        self.chart.setNeedsDisplay()
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        if let settingsViewController = segue.sourceViewController as? SettingsViewController {
            
            selectedChart =  settingsViewController.graphSwitch.selectedSegmentIndex
            startGraph()
        }
    }
}