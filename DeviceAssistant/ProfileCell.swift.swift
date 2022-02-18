//
//  ProfileCell.swift.swift
//  DeviceAssistant
//
//  Created by 梁程 on 2022/2/17.
//

import UIKit

class ProfileCell: UITableViewCell {
    let cellLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 18)
        lbl.textColor = K.darkTab
        return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellLabel)
        cellLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(16)
        }
 
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
