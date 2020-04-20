//
//  ScannerViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 10/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var quadroQrCode: UIView!
    
    var delegate: FazerLoginDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = quadroQrCode.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        quadroQrCode.layer.addSublayer(previewLayer)

        //captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanner não suportado", message: "Seus dispositivo não suporte este tipo de captura. Por favor use a câmera do seu iPhone", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        
        Configuration.shared.token = code
        UsuarioDao.getUserfor(token: code) { (usuario) in
           
            let vc = CadastroUsuarioViewController()
            vc.delegate = self.delegate
            vc.usuario = usuario!
            self.navigationController?.popViewController(animated: false)
            self.present(vc, animated: true) {
                print("Sair")
            }
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func scannear(_ sender: UIButton) {
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
            quadroQrCode.isHidden = true
        }else{
            quadroQrCode.isHidden = false
            captureSession.startRunning()
        }
    }
    
    @IBAction func convidar(_ sender: Any) {
        let items = ["Olá, nosso aplicativos para baixar \(URL(string: "https://apps.apple.com/br/app/township/id781424368?mt=12")!)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}
