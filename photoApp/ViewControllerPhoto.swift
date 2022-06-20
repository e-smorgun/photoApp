//
//  ViewControllerPhoto.swift
//  photoApp
//
//  Created by Evgeny on 16.06.22.
//

import UIKit

public struct SomeImage: Codable {

    let photo: Data
    var isLiked: Bool
    var comment: String
    
    init(photo: UIImage, isLiked: Bool = false, comment: String = "") {
        self.photo = photo.pngData()!
        self.isLiked = isLiked
        self.comment = comment
    }
}

class ViewControllerPhoto: UIViewController {
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var leftUmage: UIImageView!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var isLikedImage: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet var botomSize: NSLayoutConstraint!

    var countOfImage = 0
    var position = 0
    var images:[UIImage] = []
    var alertView: AlertView?
    
    enum UserDefaultsKey: String {
        case kPhoto = "kPhoto"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerImage.image = UIImage(named: "addImage")
        if let imageData: Data =  UserDefaults.standard.object(forKey:  UserDefaultsKey.kPhoto.rawValue) as? Data {
            if let someImages: [SomeImage] = try? PropertyListDecoder().decode(Array<SomeImage>.self, from: imageData) {
                for someImage in someImages {
                    let image = UIImage(data: someImage.photo)!
                    images.append(image)
                    countOfImage += 1
                }
            }
        }
        if UserDefaults.standard.object(forKey: UserDefaultsKey.kPhoto.rawValue) != nil {
        setImage()}
        
        let closeKeyboard = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        leftGesture.direction = .left
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        rightGesture.direction = .right
        
        self.view.addGestureRecognizer(closeKeyboard)
        self.isLikedImage.addGestureRecognizer(tapGesture)
        self.centerImage.addGestureRecognizer(leftGesture)
        self.centerImage.addGestureRecognizer(rightGesture)

        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        botomSize.constant -= 135
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        botomSize.constant += 135
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
    
    @IBAction func didTapSaveComment() {
        images.removeAll()
        if let imageData: Data =  UserDefaults.standard.object(forKey:  UserDefaultsKey.kPhoto.rawValue) as? Data {
            if var someImages: [SomeImage] = try? PropertyListDecoder().decode(Array<SomeImage>.self, from: imageData) {
                someImages[position].comment = commentField.text ?? ""
                
                UserDefaults.standard.set(try? PropertyListEncoder().encode(someImages), forKey: UserDefaultsKey.kPhoto.rawValue)
            }
        }
    }
    
    @objc func didTapLike(){
        images.removeAll()
        if let imageData: Data =  UserDefaults.standard.object(forKey:  UserDefaultsKey.kPhoto.rawValue) as? Data {
            if var someImages: [SomeImage] = try? PropertyListDecoder().decode(Array<SomeImage>.self, from: imageData) {
                if someImages[position].isLiked == true {
                    isLikedImage.image = UIImage(named: "dislike")
                    someImages[position].isLiked = !someImages[position].isLiked
                } else
                {
                    isLikedImage.image = UIImage(named: "like")
                    someImages[position].isLiked = !someImages[position].isLiked
                }
                
                UserDefaults.standard.set(try? PropertyListEncoder().encode(someImages), forKey: UserDefaultsKey.kPhoto.rawValue)
            }
        }
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer){
    switch sender.direction {
        case .left:
        position += 1
        case .right:
        position -= 1
        default:
            break
        }
        setImage()
    }
    
    func setImage() {
        images.removeAll()
        if let imageData: Data =  UserDefaults.standard.object(forKey:  UserDefaultsKey.kPhoto.rawValue) as? Data {
            if let someImages: [SomeImage] = try? PropertyListDecoder().decode(Array<SomeImage>.self, from: imageData) {
                for someImage in someImages {
                    let image = UIImage(data: someImage.photo)!
                    images.append(image)
                    countOfImage += 1
                }
            }
        }


        switch(images.count){
        case 0: centerImage.image = UIImage(named: "addImage")
            
        case 1: centerImage.image = images[0]
            
        case 2: if position == 0 || position == images.endIndex{
            position = 0
            centerImage.image = images[0]
            rightImage.image = images[1]
            leftUmage.image = images[1]
        } else if position == 1 || position == -1{
            position = images.endIndex - 1
            rightImage.image = images[0]
            centerImage.image = images[1]
            leftUmage.image = images[0]
        }
        default:
            if position == 0 || position == images.endIndex {
                position = 0
            leftUmage.image = images[images.endIndex - 1]
            centerImage.image = images[position]
            rightImage.image = images[position + 1]
        } else if position == images.endIndex - 1 || position == -1 {
            position = images.endIndex - 1
            leftUmage.image = images[position - 1]
            centerImage.image = images[position]
            rightImage.image = images[0]
        } else {
            leftUmage.image = images[position - 1]
            centerImage.image = images[position]
            rightImage.image = images[position + 1]
        }
    }
        
        if let imageData: Data =  UserDefaults.standard.object(forKey:  UserDefaultsKey.kPhoto.rawValue) as? Data {
            if let someImages: [SomeImage] = try? PropertyListDecoder().decode(Array<SomeImage>.self, from: imageData) {
                for someImage in someImages {
                    let image = UIImage(data: someImage.photo)!
                    images.append(image)
                    countOfImage += 1
                }
                if someImages[position].isLiked == true {
                    isLikedImage.image = UIImage(named: "like")
                } else
                {
                    isLikedImage.image = UIImage(named: "dislike")
                }
                
                commentField.text = someImages[position].comment
            }
        }
    }
    
    func savePhoto(newImage: UIImage) {
        print(5)
        if UserDefaults.standard.object(forKey: UserDefaultsKey.kPhoto.rawValue) == nil {
            print(12312)
            var someImages: [SomeImage] = []
            let image = SomeImage(photo: newImage, isLiked: false)
            someImages.append(image)
          
            UserDefaults.standard.set(try? PropertyListEncoder().encode(someImages), forKey: UserDefaultsKey.kPhoto.rawValue)
        } else {
        if let imageData: Data =  UserDefaults.standard.object(forKey:  UserDefaultsKey.kPhoto.rawValue) as? Data {
            if var someImages: [SomeImage] = try? PropertyListDecoder().decode(Array<SomeImage>.self, from: imageData) {
                    let image = SomeImage(photo: newImage, isLiked: false)
                    someImages.append(image)
                  
                print(12345)
                
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(someImages), forKey: UserDefaultsKey.kPhoto.rawValue)
                }
            }
        }
        setImage()
    }
}

extension ViewControllerPhoto: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[.originalImage] as? UIImage
        if let image = image {
            //images.append(image)
            savePhoto(newImage: image)
        }

        picker.dismiss(animated: true)
    }
}
