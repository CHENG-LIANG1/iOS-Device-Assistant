//
//  HomeViewController+helpers.swift
//  DeviceAssistant
//
//  Created by 梁程 on 2022/2/16.
//

import Foundation

extension HomeViewController {
    func getScreenSizeInInch() -> String {
        let deviceInfo = GBDeviceInfo()
        var screenSize = ""
        
        if deviceInfo.displayInfo.display == GBDeviceDisplay.display10p2Inch{}
        
        switch deviceInfo.displayInfo.display {
        case GBDeviceDisplay.display4p7Inch:
            screenSize = "4.7\""
            break
        case GBDeviceDisplay.display5p4Inch:
            screenSize = "5.4\""
            break
        case GBDeviceDisplay.display5p5Inch:
            screenSize = "5.5\""
            break
        case GBDeviceDisplay.display5p8Inch:
            screenSize = "5.8\""
            break
        case GBDeviceDisplay.display6p1Inch:
            screenSize = "6.1\""
            break
        case GBDeviceDisplay.display6p5Inch:
            screenSize = "6.5\""
            break
        case GBDeviceDisplay.display6p7Inch:
            screenSize = "6.7\""
            break
        default:
            screenSize = ""
        }
        
        
        return screenSize
    }
    
    func createCardView(width: Int, height: Int) -> UIView {
        let v = UIView()
        v.layer.cornerRadius = 15
        v.layer.borderColor = UIColor.gray.cgColor
        v.backgroundColor = .white
        Helper.setWidth(v, width)
        Helper.setHeight(v, Float(height))
        return v
    }
    
    func getFreeDiskspace() -> Int64? {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
                if let freeSize = dictionary[FileAttributeKey.systemFreeSize] as? NSNumber {
                    return freeSize.int64Value
                }
            }else{
                print("Error Obtaining System Memory Info:")
            }
            return nil
        }
    
    func createCapsuleLabel(color: UIColor, text: String, height:Int = 30) -> UIButton {
        let lbl = UIButton()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.setTitle(text, for: .normal)
        lbl.titleLabel?.font = UIFont.init(name: "ArialRoundedMTBold", size: 14)
        lbl.layer.cornerRadius = 15
        lbl.setBackgroundColor(color: color, forState: .normal)
        
        
        lbl.contentEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
        
        
        Helper.setHeight(lbl, Float(height))
        return lbl
    }
    

    
    
    func getCustomizedSFSymbol(name: String, color: UIColor, pointSize: Int) -> UIImage{
        return (UIImage(systemName: name)?.withTintColor(color).withRenderingMode(.alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration.init(pointSize: CGFloat(pointSize))))!
    }
    
}
