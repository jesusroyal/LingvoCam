//
//  ViewController.swift
//  LingvoCam
//
//  Created by Mike Shevelinsky on 13.09.2020.
//  Copyright © 2020 Mike Shevelinsky. All rights reserved.
//

import UIKit
import AVKit
import Vision

class HomeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

   
    
    @IBOutlet weak private var previewView: UIView!
    
	
	override func viewDidLoad(){
		super.viewDidLoad()
		prepareAVCapture()
		
	}
	
	private func prepareAVCapture(){
		
		
		let captureSession = AVCaptureSession()
		
		guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
		
		guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
		
		captureSession.addInput(input)
		
		let dataOutput = AVCaptureVideoDataOutput()
		
		dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "ML Vison"))
		
		captureSession.addOutput(dataOutput)
		
		captureSession.startRunning()
		
		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		
		previewView.layer.addSublayer(previewLayer)
		previewLayer.frame = previewView.frame
	}
	
	
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		
		guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
		
		let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: Inceptionv3().model)) { (req, err) in
			guard let results = req.results as? [VNClassificationObservation] else { return }
			
			TranslationService.translate(text: results.first!.identifier) { (res) in
				print(res)
			}
		}
		
		try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
		
		
	}

}

