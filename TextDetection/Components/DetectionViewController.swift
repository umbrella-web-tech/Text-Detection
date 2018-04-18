//
//  DetectionViewController.swift
//  TextDetection
//
//  Created by Ramazanov Sultan on 7/21/17.
//  Copyright © 2017 umbrella-web. All rights reserved.
//

import UIKit
import TesseractOCR

class DetectionViewController: UIViewController, G8TesseractDelegate {

    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    var activityIndicator:UIActivityIndicatorView!
    var image = UIImage()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        indicatorView.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.imageView.image = image
        let scaledImage = scaleImage(image, maxDimension: 640)
        self.performImageRecognition(scaledImage)
    }

    func scaleImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {

        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor:CGFloat

        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }

        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }

    func performImageRecognition(_ image: UIImage) {
        let tesseract:G8Tesseract = G8Tesseract(language:"eng")
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()

        textField.text = tesseract.recognizedText
        textField.isEditable = true

        if textField.text.isEmpty || !textField.text.trimmingCharacters(in: .whitespaces).isEmpty {
            textField.text = "Sorry, I can't read it. Try again"
        }

        indicatorView.stopAnimating()
    }

}
