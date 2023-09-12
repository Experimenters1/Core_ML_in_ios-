//
//  ViewController.swift
//  test3
//
//  Created by Huy Vu on 9/12/23.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var result: UILabel!
    
    var chosenImage = CIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


    }

    @IBAction func button(_ sender: Any) {
        
        // select image
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func recognizeImage(image: CIImage) {
        
        result.text = "Recognizing..."
        
        // 1- Request
        if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
            let request = VNCoreMLRequest(model: model) { (vnrequest, error) in
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    if results.count > 0 {
                        let topResult = results.first
                        
                        DispatchQueue.main.async {
                            //
                            let confidenceLevel = (topResult?.confidence ?? 0) * 100
                            let rounded = Int(confidenceLevel * 100) / 100
                            self.result.text = "It is \(topResult!.identifier) | \(rounded)%"
                        }
                    }
                }
            }
            // 2- Handler
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("error")
                }
            }
            
        }
        
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        img.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        // CIImage
        if let ciImage = CIImage(image: img.image!) {
            chosenImage = ciImage
        }
        
        // recognition
        recognizeImage(image: chosenImage)
    }
}
