//
//  updateUserNameBottomSheet.swift.swift
//  DeviceAssistant
//
//  Created by 梁程 on 2022/2/17.
//

import DynamicBottomSheet
import KRProgressHUD

class changeUserNameBottomSheet: DynamicBottomSheetViewController{
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        Helper.setHeight(tf, 50)
        tf.backgroundColor = K.brandGrey
        tf.layer.cornerRadius = 15
        tf.setLeftPaddingPoints(10)
        tf.font =  UIFont.init(name: "ArialRoundedMTBold", size: 19)
        tf.tintColor = K.darkTab
        tf.returnKeyType = .done
        return tf
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Update Username"
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 18)
        lbl.textColor = K.darkTab
        return lbl
    }()
    
    @objc func dismissKeyboard() {
        contentView.endEditing(true)
    }
    
    
    override func configureView() {
        super.configureView()
        KRProgressHUD.set(style: .black)
        
        
        Helper.setHeight(contentView, Float(K.screenHeight) / 2)
        nameTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tap)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(16)
        }
        
        
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottomMargin).offset(32)
            make.left.equalTo(contentView).offset(40)
            make.right.equalTo(contentView).offset(-40)
        }
    }
    
}


extension changeUserNameBottomSheet : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text!.count == 0 {
            KRProgressHUD.showMessage("Please enter a username")
            Helper.Viberation.error.viberate()
        }else if textField.text!.count < 20{
            KRProgressHUD.showMessage("Done")
            textField.resignFirstResponder()
            UserDefaults.standard.set(textField.text!, forKey: "username")
            Helper.Viberation.heavy.viberate()
            
            self.dismiss(animated: true, completion: nil)
            
        }else {
            Helper.Viberation.error.viberate()
            KRProgressHUD.showMessage("Your username is too long, 20 letters maximum")
        }
        
        return true
    }
}
