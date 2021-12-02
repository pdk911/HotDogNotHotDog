//
//  ViewController.swift
//  HotDogNotHotDog
//
//  Created by Krish Pathak on 11/29/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    
    
    let imagePicker = UIImagePickerController()
    
    let results : [VNClassificationObservation] = []

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem)
    {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[.originalImage] as?UIImage
        {
            imageView.image = image
            
            imagePicker.dismiss(animated : true, completion: nil)
            
            
            guard let ciImage = CIImage(image : image) else {return}
            
            detect(image : ciImage)
            
        }
        
    }
        
    
    
    func detect(image: CIImage)
    {
        if let model = try? VNCoreMLModel(for : Inceptionv3__1_().model)
        {
            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                        

                            // Results -> (0.8, 0.7, 0.3) -> 0.8: Hot Dog
                            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first   else {return}
                            
                            
                            if topResult.identifier.contains("hotdog") {
                                //Main Thread   -   | | | |  | | |
                                DispatchQueue.main.async {
                                    self.navigationItem.title = "Hotdog"
                                    
                                }
                            }
                            
                            else {
                                
                                
                                DispatchQueue.main.async {
                                    self.navigationItem.title = " Not Hotdog"
                                    
                                }
                            }
                        
                        
                    })
            
            let handler = VNImageRequestHandler(ciImage : image)
            do
            {
                try handler.perform([request])
            }
            catch
            {
                print(error)
            }
        }
    }
}
