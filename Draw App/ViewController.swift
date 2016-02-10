//
//  ViewController.swift
//  Draw App
//
//  Created by Roman on 2/7/16.
//  Copyright © 2016 Roman Puzey. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var isDrawing = false
    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 10.0
    var blendMode = CGBlendMode.Normal

    let colors: [(CGFloat, CGFloat, CGFloat)] =
    [
        (0,0,0), // black
        (100 / 255, 118 / 255, 135 / 255), // Steel
        (1.0, 0, 0), // red
        (0, 0, 1.0), // Blue
        (170 / 255.0, 0 , 255), // Violet
        (96 / 255.0, 159 / 255, 23 / 255), // Green
        (130.0 / 255.0, 90 / 255.0, 44.0 / 255.0), // Brown
        (250 / 255, 104 / 255, 0), // Orange
        (1.0, 1.0, 0), // yellow
        (1.0, 1.0, 1.0), // White
    ]

    @IBOutlet weak var textLabel: UILabel!

    @IBAction func changeStyle(sender: AnyObject)
    {
        switch sender.tag
        {
        case 11:
            blendMode = CGBlendMode.PlusLighter
        case 12:
            blendMode = CGBlendMode.Overlay
        case 13:
            blendMode = CGBlendMode.Normal
        default:
            blendMode = CGBlendMode.Normal
        }
    }


    @IBOutlet weak var brushLabel: UILabel!
    @IBOutlet weak var brushSlider: UISlider!


    @IBAction func sizeSlider(sender: UISlider)
    {
        if sender == brushSlider
        {
            brushWidth = CGFloat(sender.value)
            brushLabel.text = NSString(format: "%.1f", brushWidth.native) as String
        }
    }

    @IBOutlet weak var mainImageView: UIImageView!

    @IBAction func shareButton(sender: AnyObject)
    {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x:0, y:0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let shareActivity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(shareActivity, animated: true, completion: nil)
    }

    @IBAction func clearButton(sender: AnyObject)
    {
        mainImageView.image = nil
    }

    @IBAction func colorButton(sender: AnyObject)
    {
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count
        {
            index = 0
        }

        (red, green, blue) = colors[index]

        if index == 1
        {
            red = rnd()
            green = rnd()
            blue = rnd()
        }

        print("the \(index) colorButton has been pressed")
    }

    func rnd() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }

    func drawLine(fromPoint: CGPoint, toPoint: CGPoint)
    {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        mainImageView.image?.drawInRect(CGRect(x:0, y:0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)

        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)

        CGContextSetLineWidth(context, brushWidth)
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetBlendMode(context, blendMode)

        CGContextStrokePath(context)

        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        isDrawing = false
        if let touch = touches.first as UITouch!
        {
            lastPoint = touch.locationInView(self.view)
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        isDrawing = true
        if let touch = touches.first as UITouch!
        {
            let currentPoint = touch.locationInView(mainImageView)
            drawLine(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if !isDrawing
        {
            drawLine(lastPoint, toPoint: lastPoint)
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        brushLabel.text = NSString(format: "%.1f", brushSlider.value) as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}