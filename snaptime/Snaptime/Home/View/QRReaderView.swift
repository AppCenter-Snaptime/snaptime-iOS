//
//  QRReaderView.swift
//  Snaptime
//
//  Created by 이대현 on 2/28/24.
//

import AVFoundation
import UIKit

enum ReaderStatus {
    case success(_ code: String?)
    case fail
    case stop(_ isButtonTap: Bool)
}

protocol ReaderViewDelegate: AnyObject {
    func readerComplete(status: ReaderStatus)
}


final class QRReaderView: UIView {
    weak var delegate: ReaderViewDelegate?

    // 카메라 화면을 보여줄 Layer
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?

    private var cornerLength: CGFloat = 20
    private var cornerLineWidth: CGFloat = 6
    private var rectOfInterest: CGRect {
        CGRect(x: (bounds.width / 2) - (200 / 2),
               y: (bounds.height / 2) - (200 / 2),
                          width: 200, height: 200)
    }
    
    var isRunning: Bool {
        guard let captureSession = self.captureSession else {
            return false
        }
        return captureSession.isRunning
    }
    
    // 촬영 시 어떤 데이터를 검사할건지? - QRCode
    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetupView()
    }
    
    /// AVCaptureSession을 실행하는 화면을 구성 후 실행합니다.
    private func initialSetupView() {
        self.clipsToBounds = true
        self.captureSession = AVCaptureSession()
        
        print("testtt")
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        let videoInput: AVCaptureInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        guard let captureSession = self.captureSession else {
            self.fail()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.fail()
            return
        }
                
        let metadataOutput = AVCaptureMetadataOutput()
                
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
                    
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metadataObjectTypes
            
        } else {
            self.fail()
            return
        }
                
        self.setPreviewLayer()
        self.setFocusZoneCornerLayer()
        /*
         // QRCode 인식 범위 설정하기
         metadataOutput.rectOfInterest 는 AVCaptureSession에서 CGRect 크기만큼 인식 구역으로 지정합니다.
         !! 단 해당 값은 먼저 AVCaptureSession를 running 상태로 만든 후 지정해주어야 정상적으로 작동합니다 !!
         */
        self.start()
        metadataOutput.rectOfInterest = previewLayer!.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    /// 중앙에 사각형의 Focus Zone Layer을 설정합니다.
    private func setPreviewLayer() {
        let readingRect = rectOfInterest
        
        guard let captureSession = self.captureSession else {
            return
        }
        
        /*
         AVCaptureVideoPreviewLayer를 구성.
         */
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.layer.bounds

        // MARK: - Scan Focus Mask
        /*
         Scan 할 사각형(Focus Zone)을 구성하고 해당 자리만 dimmed 처리를 하지 않음.
         */
        /*
         CAShapeLayer에서 어떠한 모양(다각형, 폴리곤 등의 도형)을 그리고자 할 때 CGPath를 사용한다.
         즉 previewLayer에다가 ShapeLayer를 그리는데
         ShapeLayer의 모양이 [1. bounds 크기의 사각형, 2. readingRect 크기의 사각형]
         두개가 그려져 있는 것이다.
         */
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(readingRect)

        /*
         그럼 Path(경로? 모양?)은 그렸으니 Layer의 특징을 정하고 추가해보자.
         먼저 CAShapeLayer의 path를 위에 지정한 path로 설정해주고,
         QRReader에서 백그라운드 색이 dimmed 처리가 되어야 하므로 layer의 투명도를 0.6 정도로 설정한다.
         단 여기서 QRCode를 읽을 부분은 dimmed 처리가 되어 있으면 안 된다.
         이럴때 fillRule에서 evenOdd를 지정해주는데
         Path(도형)이 겹치는 부분(여기서는 readingRect, QRCode 읽는 부분)은 fillColor의 영향을 받지 않는다
         */
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        maskLayer.fillRule = .evenOdd

        previewLayer.addSublayer(maskLayer)
        
        
        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }
    
    // MARK: - Focus Edge Layer
    /// Focus Zone의 모서리에 테두리 Layer을 씌웁니다.
    private func setFocusZoneCornerLayer() {
        var cornerRadius = previewLayer?.cornerRadius ?? CALayer().cornerRadius
        if cornerRadius > cornerLength { cornerRadius = cornerLength }
        if cornerLength > rectOfInterest.width / 2 { cornerLength = rectOfInterest.width / 2 }

        // Focus Zone의 각 모서리 point
        let upperLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2)
        let upperRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2)
        let lowerRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2)
        let lowerLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2)
        
        // 각 모서리를 중심으로 한 Edge를 그림.
        let upperLeftCorner = UIBezierPath()
        upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))
        upperLeftCorner.addArc(withCenter: upperLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
        upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))

        let upperRightCorner = UIBezierPath()
        upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        upperRightCorner.addArc(withCenter: upperRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
                              radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
        upperRightCorner.addLine(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))

        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
        lowerRightCorner.addArc(withCenter: lowerRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
                                 radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))

        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        bottomLeftCorner.addArc(withCenter: lowerLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        bottomLeftCorner.addLine(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))
        
        // 그려진 UIBezierPath를 묶어서 CAShapeLayer에 path를 추가 후 화면에 추가.
        let combinedPath = CGMutablePath()
        combinedPath.addPath(upperLeftCorner.cgPath)
        combinedPath.addPath(upperRightCorner.cgPath)
        combinedPath.addPath(lowerRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = cornerLineWidth
        shapeLayer.lineCap = .square

        self.previewLayer!.addSublayer(shapeLayer)
    }
}

// MARK: - ReaderView Running Method
extension QRReaderView {
    func start() {
        print("# AVCaptureSession Start Running")
        self.captureSession?.startRunning()
    }
    
    func stop(isButtonTap: Bool) {
        self.captureSession?.stopRunning()
        
        self.delegate?.readerComplete(status: .stop(isButtonTap))
    }
    
    func fail() {
        self.delegate?.readerComplete(status: .fail)
        self.captureSession = nil
    }
    
    func found(code: String) {
        self.delegate?.readerComplete(status: .success(code))
    }
}

// MARK: - AVCapture Output
extension QRReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        print("# GET metadataOutput")
//        stop(isButtonTap: false)
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue else {
                return
            }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            AudioServicesPlayAlertSound(SystemSoundID(1407)) // Appstore purchase sound
            found(code: stringValue)
            print("## Found metadata Value\n + \(stringValue)\n")
            stop(isButtonTap: true)
        }
    }
}

internal extension CGPoint {

    // MARK: - CGPoint+offsetBy
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
