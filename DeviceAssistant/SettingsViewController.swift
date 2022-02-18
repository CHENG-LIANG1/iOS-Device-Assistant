//
//  SettingsViewController.swift
//  DeviceAssistant
//
//  Created by 梁程 on 2022/2/14.
//

import UIKit

class SettingsViewController: UIViewController, ImagePickerDelegate{
    func createCardView(width: Int, height: Int) -> UIView {
        let v = UIView()
        v.layer.cornerRadius = 15
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.borderWidth = 0.3
        v.backgroundColor = .white
        Helper.setWidth(v, width)
        Helper.setHeight(v, Float(height))
        return v
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .clear
        sv.contentSize = CGSize(width: K.screenWidth, height: 700)
        return sv
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 50
        Helper.setWidth(iv, 100)
        Helper.setHeight(iv, 100)
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        iv.image = UIImage(named: "cool")?.withTintColor(K.emojiYellow)
        return iv
    }()
    
   
    let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 24)
        lbl.textColor = K.darkTab
        return lbl
    }()
    
    
    func didSelect(image: UIImage?) {
        saveImage(image: image!)
    }
    
    var profileImage: UIImage?
    
    func saveImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: "profilePic")
    }

    func loadImage() -> UIImage {
        guard let data = UserDefaults.standard.data(forKey: "profilePic") else { return UIImage(named: "cool")!.withTintColor(K.emojiYellow)}
         let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
         let image = UIImage(data: decoded)
        
        
        return image!
    }
    
    
    var username = "User"
    func getUserInfo(){
        
        if let name = UserDefaults.standard.string(forKey: "username"){
            username = name
            userNameLabel.text = username
            
        }
        
        profileImageView.image = loadImage()

    }
    
    var imagePicker: ImagePicker?
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Info"
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 22)
        lbl.textColor = K.brandDarkGrey
        return lbl
    }()
    
    let generalLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "General"
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 22)
        lbl.textColor = K.brandDarkGrey
        return lbl
    }()
    

    
    func createStyledButton(buttonText: String, bgColor: UIColor) -> UIButton{
        let btn = UIButton()
        btn.setTitle(buttonText, for: .normal)
        btn.setBackgroundColor(color: bgColor, forState: .normal)
        btn.titleLabel?.font = UIFont.init(name: "ArialRoundedMTBold", size: 22)
        btn.setTitleColor(K.darkTab, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.clipsToBounds = true
        btn.sizeToFit()
        Helper.setWidth(btn, Int(K.screenWidth) - 64)
        Helper.setHeight(btn, 50)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0,left: 20,bottom: 0,right: 20)
        return btn
    }
    
    
    let profileButtonStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
      }()
    
    let generalButtonStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    

    
    @objc func updateProfilePictureAction(sender: UIButton){
        imagePicker?.present(from: sender)
        Helper.Viberation.heavy.viberate()
    }
    
    @objc func updateUsernameAction(sender: UIButton){
       let userNameBottomSheet = changeUserNameBottomSheet()
        Helper.Viberation.heavy.viberate()
        self.present(userNameBottomSheet, animated: true, completion: nil)
    }
    
    @objc func aboutUsAction(){
        Helper.Viberation.heavy.viberate()
        let aboutUsBottomSheet = AboutUsBottomSheet()
        present(aboutUsBottomSheet, animated: true, completion: nil)
    }
    
    @objc func shareUsAction(){
        Helper.Viberation.heavy.viberate()
        let text = "Device Assistant"
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        

        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        getUserInfo()
        userNameLabel.text = username
        
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.getUserInfo()
         })
        
        let image = UIImage(named: "bgColor")
        let color = UIColor.init(patternImage: image!)
        view.backgroundColor = color
        
        title = "Profile"
        
        let profileCardView = createCardView(width: Int((K.screenWidth - 32)), height: 150)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        scrollView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(scrollView).offset(30)
        }
        
        
        
        scrollView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(profileImageView.snp.bottomMargin).offset(16)
        }
        
        
        scrollView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottomMargin).offset(24)
            make.left.equalTo(scrollView).offset(48)
        }
        
        let profilePictureButton = createStyledButton(buttonText: "Update Profile Picture", bgColor: .white)
        
        let updateUserNameButton = createStyledButton(buttonText: "Update Username", bgColor: .white)
        
        profilePictureButton.addTarget(self, action: #selector(updateProfilePictureAction(sender:)), for: .touchUpInside)
        updateUserNameButton.addTarget(self, action: #selector(updateUsernameAction(sender:)), for: .touchUpInside)
        
        
        
        
        profileButtonStack.addArrangedSubview(profilePictureButton)
        profileButtonStack.addArrangedSubview(updateUserNameButton)

        let stackContentView = UIView()
        stackContentView.layer.cornerRadius = 20
        stackContentView.clipsToBounds = true
        stackContentView.addSubview(profileButtonStack)
        profileButtonStack.snp.makeConstraints { make in
            make.left.equalTo(stackContentView)
            make.right.equalTo(stackContentView)
            make.top.equalTo(stackContentView)
            make.bottom.equalTo(stackContentView)
        }

        scrollView.addSubview(stackContentView)
        stackContentView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottomMargin).offset(16)
            make.centerX.equalTo(view)
        }
        
        scrollView.addSubview(generalLabel)
        generalLabel.snp.makeConstraints { make in
            make.top.equalTo(profileButtonStack.snp.bottomMargin).offset(16)
            make.left.equalTo(infoLabel)
        }
        
        
        let generalContentView = UIView()
        generalContentView.layer.cornerRadius = 20
        generalContentView.clipsToBounds = true
        generalContentView.addSubview(generalButtonStack)
        
        generalButtonStack.snp.makeConstraints { make in
            make.left.equalTo(generalContentView)
            make.right.equalTo(generalContentView)
            make.top.equalTo(generalContentView)
            make.bottom.equalTo(generalContentView)
        }
        
        scrollView.addSubview(generalContentView)
        generalContentView.snp.makeConstraints { make in
            make.top.equalTo(generalLabel.snp.bottomMargin).offset(16)
            make.centerX.equalTo(view)
        }
        
        
        let aboutUsButton = createStyledButton(buttonText: "About Us", bgColor: .white)
        
        let shareUsButton = createStyledButton(buttonText: "Share Us", bgColor: .white)
        
        aboutUsButton.addTarget(self, action: #selector(aboutUsAction), for: .touchUpInside)
        shareUsButton.addTarget(self, action: #selector(shareUsAction), for: .touchUpInside)
        
        generalButtonStack.addArrangedSubview(aboutUsButton)
        generalButtonStack.addArrangedSubview(shareUsButton)
        
    }
    
}



