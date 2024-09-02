//
//  QRReaderViewController.swift
//  Snaptime
//
//  Created by 이대현 on 2/28/24.
//

import AVFoundation
import SnapKit
import UIKit

protocol QRReaderViewControllerDelegate: AnyObject {
    func didFinishAddAlbum()
}

final class QRReaderViewController: UIViewController {
    private let brand: FourCutBrand
    private let captureSession = AVCaptureSession()
    weak var delegate: QRReaderViewControllerDelegate?
    
    init(didSelectedBrand: FourCutBrand) {
        self.brand = didSelectedBrand
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQRReader()
    }
    
}

extension QRReaderViewController {
    private func setQRReader() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        do {
            // 제한하고 싶은 영역
            let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2 , y: (UIScreen.main.bounds.height - 200) / 2, width: 200, height: 200)
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)
            setGuideCrossLineView(rectOfInterest: rectOfInterest)
            output.rectOfInterest = rectConverted
            
            captureSession.startRunning()
        }
        catch {
            print("error")
        }
    }
    
    private func setVideoLayer(rectOfInterest: CGRect) -> CGRect{
        // 영상을 담을 공간.
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //카메라의 크기 지정
        videoLayer.frame = view.layer.bounds
        //카메라의 비율지정
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        
        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    private func setGuideCrossLineView(rectOfInterest: CGRect) {
        let path = CGMutablePath()
        path.addRect(self.view.bounds)
        path.addRect(rectOfInterest)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        maskLayer.fillRule = .evenOdd

        view.layer.addSublayer(maskLayer)
        
        guard let previewLayer = self.view.layer.sublayers?.filter({
            $0 as? AVCaptureVideoPreviewLayer != nil
        }).first else {
            print("error")
            return
        }
        var cornerRadius = previewLayer.cornerRadius
        var cornerLength: CGFloat = 20
        let cornerLineWidth: CGFloat = 6
        
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

        view.layer.addSublayer(shapeLayer)
    }
}

extension QRReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            print("i got metadata")
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }
            print("stringValue: " + stringValue)
            print(brand)
            
            self.captureSession.stopRunning()
            /// 여기에 api 호출
//            APIService.fetchImageFromQR(
//                brand: brand,
//                url: stringValue
//            ).performRequest(responseType: ) { result in
//                print(result)
//            }
            
            delegate?.didFinishAddAlbum()
        }
    }
}

