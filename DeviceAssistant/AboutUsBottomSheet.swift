//
//  AboutUsBottomSheet.swift
//  DeviceAssistant
//
//  Created by 梁程 on 2022/2/18.
//
import UIKit
import DynamicBottomSheet

class AboutUsBottomSheet: DynamicBottomSheetViewController{
    
    let logoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Device\nAssistant"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 25)
        lbl.layer.borderWidth = 8
        lbl.layer.cornerRadius = 15
        lbl.layer.borderColor = K.brandYellow.cgColor
        Helper.setHeight(lbl, 150)
        Helper.setWidth(lbl, 150)
        
        return lbl
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon")
        Helper.setWidth(iv, 150)
        Helper.setHeight(iv, 150)
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    override func configureView() {
        super.configureView()
        
        let dragButton = Helper.setUpDragHandle(color: UIColor.darkGray, width: 50, height: 12, radius: 6)
        contentView.addSubview(dragButton)
        dragButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.centerX.equalTo(contentView)
        }
        
        Helper.setHeight(contentView, 300)
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
    
}
