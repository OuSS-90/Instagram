//
//  CameraController.swift
//  Instagram
//
//  Created by OuSS on 12/13/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {

    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let output = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCaptureSession()
        setupButtons()
    }
    
    fileprivate func setupButtons() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(bottom: view.bottomAnchor, paddingBottom: 24, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, right: view.trailingAnchor, paddingTop: 12, paddingRight: 12, width: 50, height: 50)
    }
    
    @objc func handleCapturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
    
        if let previewFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        }
        
        output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input){
               captureSession.addInput(input)
            }
        } catch let err {
            print(err)
        }
        
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let data = photo.fileDataRepresentation(), let image =  UIImage(data: data) else { return }
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = image
        
        view.addSubview(containerView)
        
        containerView.anchor(top: view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor)
    }
}
