//
//  ViewController.swift
//  mousouChat
//
//  Created by 齋藤　航平 on 2018/06/01.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var profileImageVoiew: UIImageView!
    @IBOutlet weak var talkTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var saveApiKeyButton: UIButton!
    
    private let talkApiProvider = MoyaProvider<TalkApi>()
    private let disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor.black.cgColor
        sendButton.layer.cornerRadius = 10
        saveApiKeyButton.layer.borderWidth = 1
        saveApiKeyButton.layer.borderColor = UIColor.black.cgColor
        saveApiKeyButton.layer.cornerRadius = 10
        if userDefaults.string(forKey: "api_key") != "" {
            saveApiKeyButton.isHidden = true
            apiKeyTextField.isHidden = true
        }
        if (userDefaults.data(forKey: "image_data") != nil) {
            let savedImage = UIImage(data: userDefaults.data(forKey: "image_data")!)
            imageView.image = savedImage
            imageView.contentMode = UIViewContentMode.scaleAspectFit
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionSendTalk(_ sender: Any) {
        talkApiProvider.rx.request(TalkApi.sendTalk(talkStr: talkTextField.text!)).subscribe{ event in
            switch event {
            case .success(let response):
                do {
                    let talkResponse = try JSONDecoder().decode(Talk.self, from: response.data)
                    if talkResponse.message == "ok" {
                        self.answerLabel.text = talkResponse.results[0].reply
                        self.talkTextField.text = ""
                    } else {
                        print("error")
                    }
                } catch {
                    print("error:", error)
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    @IBAction func actionSaveApiKey(_ sender: Any) {
        userDefaults.set(self.apiKeyTextField.text, forKey: "api_key")
    }
    
    @IBAction func actionAddImage(_ sender: Any) {
        let c = UIImagePickerController()
        c.delegate = self
        present(c, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let data = UIImagePNGRepresentation(image!)
        userDefaults.set(data, forKey: "image_data")
        print("image data:", userDefaults.data(forKey: "image_data"))
        self.imageView.image = image
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        picker.dismiss(animated: true, completion: nil)
    }
}




