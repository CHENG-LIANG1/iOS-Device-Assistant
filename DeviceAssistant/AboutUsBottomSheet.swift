//
//  AboutUsBottomSheet.swift
//  DeviceAssistant
//
//  Created by 梁程 on 2022/2/18.
//
import UIKit
import DynamicBottomSheet

class AboutUsBottomSheet: DynamicBottomSheetViewController{
    

    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon")
        
        Helper.setWidth(iv, 150)
        Helper.setHeight(iv, 150)
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    let versionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = K.darkTab
        lbl.font =  UIFont.init(name: "ArialRoundedMTBold", size: 19)
        lbl.text = "Version 1.0.0"
        return lbl
    }()
    
    override func configureView() {
        super.configureView()
        
        let dragButton = Helper.setUpDragHandle(color: UIColor.darkGray, width: 50, height: 12, radius: 6)
        contentView.addSubview(dragButton)
        dragButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.centerX.equalTo(contentView)
        }
        
        Helper.setHeight(contentView, Float(K.screenHeight) / 2 + 50)
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
        
        contentView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(logoImageView.snp.bottomMargin).offset(14)
        }
    }
    
}
