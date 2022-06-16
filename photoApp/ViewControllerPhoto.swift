//
//  ViewControllerPhoto.swift
//  photoApp
//
//  Created by Evgeny on 16.06.22.
//

import UIKit

class ViewControllerPhoto: UIViewController {
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var images:[UIImage] = []
    var alertView: AlertView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func didTapAddButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    
    
    @IBAction func didTapAddAlert() {
        let view = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first
        if let view = view as? AlertView {
            alertView = view
            alertView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(alertView!)
        }
    }
}

extension ViewControllerPhoto: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[.originalImage] as? UIImage
        if let image = image {
            images.append(image)
        }

        picker.dismiss(animated: true)

    }
}
