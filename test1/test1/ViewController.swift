//
//  ViewController.swift
//  test1
//
//  Created by Huy Vu on 9/12/23.
//

import UIKit
import MobileCoreServices
import CoreML


class ViewController: UIViewController {

    @IBOutlet weak var imgUI: UIImageView!
    
    
    @IBOutlet weak var Result: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func button1(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
          imagePicker.sourceType = .photoLibrary // You can use .camera for the camera
          imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func analyzeImage(image: UIImage?) {
        guard let buffer = image?.resize(size: CGSize(width: 224, height: 224))?
                .getCVPixelBuffer() else {
            return
        }

        do {
            let config = MLModelConfiguration()
            let model = try GoogLeNetPlaces(configuration: config)
            let input = GoogLeNetPlacesInput(sceneImage: buffer)

            let output = try model.prediction(input: input)
            let text = output.sceneLabel
            Result.text = text
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Do something with the selected image
            
            print("fbfhvfhvf \(info)")
            // Hiển thị ảnh đã chọn trên UIImageView
            imgUI.image = selectedImage
            analyzeImage(image: selectedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    
}
