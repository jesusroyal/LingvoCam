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

final class HomeViewController: UIViewController {

	// MARK: - IBOutlets
	
	@IBOutlet weak var settingsButton: UIButton!
	@IBOutlet weak var sourceWord: UILabel!
	@IBOutlet weak var translatedWord: UILabel!
	@IBOutlet weak var mainPadding: UIView!
	@IBOutlet weak var previewView: UIView!
	
	// MARK: - Private Properties
	
	private let model = try! VNCoreMLModel(for: Inceptionv3(configuration: MLModelConfiguration()).model)
	
	// MARK: - Lifecycle
	
	override func viewDidLoad(){
		super.viewDidLoad()
		
		prepareAVCapture()
		prepareLabels()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
		super.viewWillAppear(animated)
	}

	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
		super.viewWillDisappear(animated)
	}
	
	// MARK: - Private Methods
	
	private func prepareLabels(){
		translatedWord.layer.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 0.5568627451, alpha: 1)
		translatedWord.layer.cornerRadius = 15.0
		
		mainPadding.layer.cornerRadius = 15.0
		settingsButton.layer.cornerRadius = 15.0
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
	
}


extension HomeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
	
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
		
		let request = VNCoreMLRequest(model: model) { [weak self] (req, err) in
			guard let results = req.results as? [VNClassificationObservation] else { return }
			DispatchQueue.main.async {
				self?.sourceWord.text = results.first!.identifier.firstWord()!
			}
			TranslationService.instance.translate(text: results.first!.identifier.firstWord()!) { [weak self] (res) in
				DispatchQueue.main.async {
					self?.translatedWord.text = res ?? "Ошибка"
				}
			}
		}
		
		try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
	}
}

