//
//  ViewController.swift
//  PhotoFilter
//
//  Created by Kaustav Chakraborty on 8/29/16.
//  Copyright © 2016 photoca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    // Create a place to render the filtered image
    let context = CIContext(options: nil)
    
    @IBAction func applyFilter(sender: AnyObject) {
        
        // Create an image to filter
        let inputImage = CIImage(image: img.image!)
        
        // Create a random color to pass to a filter
        let randomColor = [kCIInputAngleKey: (Double(arc4random_uniform(314)) / 100)]
        
        // Apply a filter to the image
        let filteredImage = inputImage!.imageByApplyingFilter("CIHueAdjust", withInputParameters: randomColor)
        
        // Render the filtered image
        let renderedImage = context.createCGImage(filteredImage, fromRect: filteredImage.extent)
        
        // Reflect the change back in the interface
        img.image = UIImage(CGImage: renderedImage)
        
    }
    
    func getDocumentDirectoryPath() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func jpegRepresentationOfImage(image: CIImage) -> NSData {
        let eaglContext = EAGLContext(API: .OpenGLES2)
        let ciContext = CIContext(EAGLContext: eaglContext)
        
        let outputImageRef = ciContext.createCGImage(image, fromRect: image.extent)
        let uiImage = UIImage(CGImage: outputImageRef, scale: 1.0, orientation: UIImageOrientation.Up)
        
        return UIImageJPEGRepresentation(uiImage, 0.9)! //this takes upwards of 20-30 seconds with large photos!
    }
    
    @IBAction func saveFilter(sender: AnyObject) {
        // Create the image to save
        let inputImage = CIImage(image: img.image!)
        let filename = getDocumentDirectoryPath().stringByAppendingPathComponent("\(NSDate()).jpeg")
        
        do {
            try jpegRepresentationOfImage(inputImage!).writeToFile(filename, atomically: true)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("SAVING FAILED")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}