//
//  ViewController.swift
//  WhatsThat
//
//  Created by Codebender on 18/07/2017.
//  Copyright © 2017 A23 Labs. All rights reserved.
//

import UIKit
import CoreML



class ViewController: UIViewController, UINavigationControllerDelegate {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var imageLabel: UILabel!

	var model: Inceptionv3!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func viewWillAppear(_ animated: Bool) {


		model = Inceptionv3()



	}


	//method to unleash picking an image from a camera once the camera button is pressed

	@IBAction func camera(_ sender: Any) {

		//incase the camera is not available, just chill out
		if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {

			return
		}

		//otherwise, business as usual
		let cameraPicker = UIImagePickerController()
		cameraPicker.delegate = self
		cameraPicker.sourceType = .camera
		cameraPicker.allowsEditing = false

		//then we present the view
		present(cameraPicker, animated: true)
	}

	//this method picks from the Photos Library
	@IBAction func fromLibrary(_ sender: Any) {

		let picker = UIImagePickerController()
		picker.allowsEditing = false
		picker.delegate = self
		picker.sourceType = .photoLibrary

		present(picker, animated: true)


	}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

//we create an extension of UIImagePickerViewController
extension ViewController : UIImagePickerControllerDelegate {

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

		dismiss(animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

		picker.dismiss(animated: true)

		//update the label
		imageLabel.text = "Analyzing Image ..."
		guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {

			return
		}

		UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
		image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
		var pixelBuffer : CVPixelBuffer?
		let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
		guard (status == kCVReturnSuccess) else {
			return
		}

		CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
		let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

		let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
		let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3

		context?.translateBy(x: 0, y: newImage.size.height)
		context?.scaleBy(x: 1.0, y: -1.0)

		UIGraphicsPushContext(context!)
		newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
		UIGraphicsPopContext()
		CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
		imageView.image = newImage

		//back to Core ML
		guard let prediction = try? model.prediction(image: pixelBuffer!) else {

			return
		}

		imageLabel.text = "I think this is a \(prediction)"
	}

}





























