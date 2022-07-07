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

class ViewControllerPhoto: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var leftUmage: UIImageView!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var isLikedImage: UIImageView!
    @IBOutlet var collectionView: UICollectionView!


    var countOfImage = 0
    var position = 0
    var images: [UIImage] = []
    var alertView: AlertView?
    
    enum UserDefaultsKey: String {
        case kPhoto = "kPhoto"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()

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
        
      //  let closeKeyboard = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        leftGesture.direction = .left
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        rightGesture.direction = .right
        
      //  self.view.addGestureRecognizer(closeKeyboard)
        self.isLikedImage.addGestureRecognizer(tapGesture)
        self.centerImage.addGestureRecognizer(leftGesture)
        self.centerImage.addGestureRecognizer(rightGesture)

        self.navigationController?.isNavigationBarHidden = true
        
        print(images.count)
        print(countOfImage)
print(images)
        collectionView.reloadData()
        collectionView.dataSource = self
        collectionView.delegate = self
        print(123)
        print(images.count)
        print(321)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        let center = NotificationCenter.default
//        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        let center = NotificationCenter.default
//        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    @objc func closeKeyboard() {
//        view.endEditing(true)
//    }
    
    @IBAction func didTapAddButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
//    @IBAction func didTapAddAlert() {
//        let view = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first
//        if let view = view as? AlertView {
//            alertView = view
//            alertView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//            self.view.addSubview(alertView!)
//        }
//    }
    
//    @IBAction func didTapSaveComment() {
//        images.removeAll()
//        if let imageData: Data =  UserDefaults.standard.object(forKey:  UserDefaultsKey.kPhoto.rawValue) as? Data {
//            if var someImages: [SomeImage] = try? PropertyListDecoder().decode(Array<SomeImage>.self, from: imageData) {
//                someImages[position].comment = commentField.text ?? ""
//
//                UserDefaults.standard.set(try? PropertyListEncoder().encode(someImages), forKey: UserDefaultsKey.kPhoto.rawValue)
//            }
//        }
//    }
    
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
        countOfImage = 0
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
        
        images.removeAll()
        countOfImage = 0
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
                            }
        }
    }
    
    func savePhoto(newImage: UIImage) {
        print(5)
        if UserDefaults.standard.object(forKey: UserDefaultsKey.kPhoto.rawValue) == nil {
            var someImages: [SomeImage] = []
            let image = SomeImage(photo: newImage, isLiked: false)
            someImages.append(image)
          
            UserDefaults.standard.set(try? PropertyListEncoder().encode(someImages), forKey: UserDefaultsKey.kPhoto.rawValue)
        } else {
        if let imageData: Data =  UserDefaults.standard.object(forKey:  UserDefaultsKey.kPhoto.rawValue) as? Data {
            if var someImages: [SomeImage] = try? PropertyListDecoder().decode(Array<SomeImage>.self, from: imageData) {
                    let image = SomeImage(photo: newImage, isLiked: false)
                    someImages.append(image)
                                  
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(someImages), forKey: UserDefaultsKey.kPhoto.rawValue)
                }
            }
        }
        setImage()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView", for: indexPath) as? CollectionView {

           
            cell.imageView.image = images[indexPath.row]
            return cell
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
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
