//
//  CameraContoller.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 7/25/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController : UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
    
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    let capturePhotoButton : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
        btn.addTarget(self, action: #selector(captureKlikd), for: .touchUpInside)
        return btn
        
    }()
    
    @objc func captureKlikd(){
        print("capture")
        
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [ kCVPixelBufferPixelFormatTypeKey as String : previewFormatType ]
        
        output.capturePhoto(with: settings, delegate: self)
        
    }
    
    let focusSlider : UISlider = {
        
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.value = 1
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        return slider
        
    }()
    
    @objc func sliderChanged() {
        print(focusSlider.value)
        
        guard let capDev = captureDevice else { return }
        print ("CCCCCCXXXXXXX",capDev.lensPosition )
        
        do {
            try capDev.lockForConfiguration()
        } catch {
            // handle error
            return
        }
        
        capDev.setFocusModeLocked(lensPosition: focusSlider.value, completionHandler: nil)
        capDev.unlockForConfiguration()
        
    }
    
    let drugiSlider : UISlider = {
        
        
        
        let slider = UISlider()
        slider.addTarget(self, action: #selector(drugiSliderChanged), for: .valueChanged)
        return slider
        
    }()
    
    @objc func drugiSliderChanged() {
        
        guard let capDev = captureDevice else { return }
        
        do {
            try capDev.lockForConfiguration()
        } catch {
            // handle error
            return
        }
        
        capDev.setExposureTargetBias(drugiSlider.value, completionHandler: nil)
        capDev.unlockForConfiguration()
        
    }
    
    let treciSlider : UISlider = {
        
        let slider = UISlider()
        slider.addTarget(self, action: #selector(treciSliderChanged), for: .valueChanged)
        return slider
        
    }()
    
    @objc func treciSliderChanged() {
        
        guard let capDev = captureDevice else { return }
        
        do {
            try capDev.lockForConfiguration()
        } catch {
            // handle error
            return
        }
        
        
        
        capDev.videoZoomFactor = CGFloat(treciSlider.value)
        capDev.unlockForConfiguration()
        
    }
    
    
    
    
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        let image = UIImage(data: imageData!)
        
        
        
        
        let previewContainer = PreviewPhotoContainerView()
        
        previewContainer.previewImageView.image = image
        
        view.addSubview(previewContainer)
        previewContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        
        
        print("Finished processing photo semple")
    }
    
    
    let dismissButton : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        btn.addTarget(self, action: #selector(dismissKliked), for: .touchUpInside)
        return btn
        
    }()
    
    @objc func dismissKliked(){
        print("taped")
        dismiss(animated: true, completion: nil)
    }
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let newDev = captureDevice else { return }
        
        let maxB = newDev.maxExposureTargetBias
        let minB = newDev.minExposureTargetBias
        
        drugiSlider.maximumValue = maxB
        drugiSlider.minimumValue = minB
        drugiSlider.value = ( maxB - minB / 2 ) + minB
        
        //let maxWhiteBalans = newDev.maxWhiteBalanceGain
        
        let maxZOOM = newDev.activeFormat.videoMaxZoomFactor
        let minZOOM = 1
        
        treciSlider.maximumValue = Float(maxZOOM)
        treciSlider.minimumValue = Float(minZOOM)
        treciSlider.value = Float(minZOOM)
        
        
        
        
        transitioningDelegate = self
        
        setupCaptureSession()
        setupButtons()
        
    }
    
    
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return customAnimationPresentor
        
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        return customAnimationDismisser
    }
    

    
    
    fileprivate func setupButtons() {
        
        view.addSubview(capturePhotoButton)
        view.addSubview(dismissButton)
        view.addSubview(focusSlider)
        view.addSubview(drugiSlider)
        view.addSubview(treciSlider)
        
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80, centerX: view.centerXAnchor, centerY: nil)
        
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50, centerX: nil, centerY: nil)
        
        focusSlider.anchor(top: nil, left: view.leftAnchor, bottom: capturePhotoButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 20, centerX: nil, centerY: nil)
        
        drugiSlider.anchor(top: nil, left: view.leftAnchor, bottom: focusSlider.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 20, centerX: nil, centerY: nil)
        
        treciSlider.anchor(top: nil, left: view.leftAnchor, bottom: drugiSlider.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 20, centerX: nil, centerY: nil)
    }
    
    
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    
    let output = AVCapturePhotoOutput()
    
    fileprivate func setupCaptureSession() {
        
        let captureSession = AVCaptureSession()
        
        // 1. Setup input 
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
               
                
            }
            
        } catch let err {
            
            print("Could not setup camera input", err)
        }
        
        // 2. Setup output
        
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        // 3.
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    
    
    
    
    
}
