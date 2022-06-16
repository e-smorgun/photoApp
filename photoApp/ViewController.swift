//
//  ViewController.swift
//  photoApp
//
//  Created by Evgeny on 15.06.22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    var password: String = ""
    var count = 0
    var passwordNums = ["_" , "_" , "_" , "_"]
    
    enum UserDefaultsKey: String {
        case kPassword = "kPassword"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapOne() {
        password.append(contentsOf: "1")
        changeLabel(number: "1")
    }
    
    @IBAction func didTapTwo() {
        password.append(contentsOf: "2")
        changeLabel(number: "2")
    }
    
    @IBAction func didTapThree() {
        password.append(contentsOf: "3")
        changeLabel(number: "3")
    }
    
    @IBAction func didTapFour() {
        password.append(contentsOf: "4")
        changeLabel(number: "4")
    }
    
    @IBAction func didTapFive() {
        password.append(contentsOf: "5")
        changeLabel(number: "5")
    }
    
    @IBAction func didTapSix() {
        password.append(contentsOf: "6")
        changeLabel(number: "6")
    }
    
    @IBAction func didTapSeven() {
        password.append(contentsOf: "7")
        changeLabel(number: "7")
    }
    
    @IBAction func didTapEight() {
        password.append(contentsOf: "8")
        changeLabel(number: "8")
    }
    
    @IBAction func didTapNine() {
        password.append(contentsOf: "9")
        changeLabel(number: "9")
    }
    
    @IBAction func didTapNull() {
        password.append(contentsOf: "0")
        changeLabel(number: "0")
    }
    
    @IBAction func didTapDel() {
        password.removeAll()
        passwordLabel.text = "_ _ _ _"
        count = 0
        passwordNums[0] = "_"
        passwordNums[1] = "_"
        passwordNums[2] = "_"
        passwordNums[3] = "_"

    }
    
    @IBAction func didTapCheck() {
        
    }

    func changeLabel(number: String){
        let passwordFromUD = UserDefaults.standard.string(forKey: UserDefaultsKey.kPassword.rawValue)
        
        switch(count){
        case 0: passwordNums[0] = number
            passwordLabel.text = "\(passwordNums[0]) _ _ _"
        case 1: passwordNums[1] = number
            passwordLabel.text = "\(passwordNums[0]) \(passwordNums[1]) _ _"
        case 2: passwordNums[2] = number
            passwordLabel.text = "\(passwordNums[0]) \(passwordNums[1]) \(passwordNums[2]) _"
        case 3:passwordNums[3] = number
            passwordLabel.text = "\(passwordNums[0]) \(passwordNums[1]) \(passwordNums[2]) \(passwordNums[3])"
            
            if password == passwordFromUD {
                passwordLabel.textColor = .green
                let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: ViewControllerPhoto = story.instantiateViewController(withIdentifier: "ViewControllerPhoto") as! ViewControllerPhoto
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                passwordLabel.textColor = .red
                UIView.animate(withDuration: 0.2, delay: 0, options: .allowAnimatedContent) {
                    self.leftConstraint.constant -= 10
                    self.rightConstraint.constant += 10
                    self.passwordLabel.center.x -= 10
                } completion: { _ in UIView.animate(withDuration: 0.2, delay: 0, options: .allowAnimatedContent) {
                    self.leftConstraint.constant += 20
                    self.rightConstraint.constant -= 20
                    self.passwordLabel.center.x += 20
                } completion: { _ in UIView.animate(withDuration: 0.2, delay: 0, options: .allowAnimatedContent) {
                    self.leftConstraint.constant -= 10
                    self.rightConstraint.constant += 10
                    self.passwordLabel.center.x -= 10
                } completion: { _ in
                    self.passwordLabel.textColor = .black
                    self.didTapDel()
                }
                    }
                }
            }
            
        default: break
        }
        count += 1
    }
    
}

