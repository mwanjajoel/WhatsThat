//
//  ViewController.swift
//  WhatsThat
//
//  Created by Codebender on 18/07/2017.
//  Copyright © 2017 A23 Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var imageLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
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
}




























