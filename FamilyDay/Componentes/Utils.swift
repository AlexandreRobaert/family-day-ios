//
//  Utils.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 08/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
    }
    
    static func temTextFieldVazia(view: UIView)-> Bool{
        var retorno = false
        for textField in getTextfield(view: view) {
            if textField.text!.isEmpty {
                textField.layer.borderWidth = 0.5
                textField.layer.borderColor = #colorLiteral(red: 1, green: 0.2784313725, blue: 0.003921568627, alpha: 1)
                retorno = true
            }
        }
        return retorno
    }
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    static func resizedImage(at image: UIImage, for size: CGSize) -> UIImage {

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
