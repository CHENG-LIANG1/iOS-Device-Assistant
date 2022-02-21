//
//  HomeViewController.swift
//  DeviceAssistant
//
//  Created by 梁程 on 2022/2/14.
//

import UIKit
import SnapKit
import System
import BIASystemKit
import SystemConfiguration.CaptiveNetwork

class HomeViewController: UIViewController {
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = CGSize(width: K.screenWidth, height: 1000)
        return sv
    }()
    
    let deviceInfo = GBDeviceInfo()
    
    var timer = Timer()
    
    var batteryLevel = UIDevice.current.batteryLevel
    
    var networkLabel = UIButton()
    
    let networkStatus = SystemServices.shared().connectedToWiFi ? "Wifi" : "Cellular"

    
    let batteryPercentageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 16)
        return lbl
    }()
    
    var netmaskLabel = UIButton()
    var externalIPLabel = UIButton()
    var networkStatusLabel = UIButton()
    var networkIPLabel = UIButton()
    
    var networkLabelText = ""
    var networkStatusText = ""
    
    let netmaskText = SystemServices.shared().connectedToWiFi ?  "Netmask: \(SystemServices.shared().wiFiNetmaskAddress!)" : "Netmask: \(SystemServices.shared().cellNetmaskAddress!)"
    let externalIP = SystemServices.shared().connectedToWiFi ? "External IP: \(SystemServices.shared().externalIPAddress!)" : "Broadcast: \(SystemServices.shared().cellBroadcastAddress!)"
    
    let batteryImageView = UIImageView()

    let networkImageView = UIImageView()
    
    var totalMemoryLabel = UIButton()
    var usedMemoryLabel = UIButton()
    var freeMemoryLabel = UIButton()
    var usedMemoryPercent = UIButton()
    var freeMemoryPercent = UIButton()
    var inactiveMemoryLabel = UIButton()
    var inactiveMemoryPercentageLabel = UIButton()
    
    let usedMemory = SystemServices.shared().usedMemoryinRaw.roundToDecimal(1)
    let usedMemoryPercentText = SystemServices.shared().usedMemoryinPercent.roundToDecimal(1)
    let totalMemory = SystemServices.shared().totalMemory.roundToDecimal(1)
    let freeMemory = SystemServices.shared().freeMemoryinRaw.roundToDecimal(1)
    let freeMemoryPercentText = SystemServices.shared().freeMemoryinPercent.roundToDecimal(1)
    let inactiveMemory = SystemServices.shared().inactiveMemoryinRaw.roundToDecimal(1)
    let inactiveMemoryPercentage = SystemServices.shared().inactiveMemoryinPercent.roundToDecimal(1)
    
    func updateSystemInfo(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        batteryLevel = UIDevice.current.batteryLevel
        batteryPercentageLabel.text = "\(Int(batteryLevel * 100))% Charged"
        
        if SystemServices.shared().connectedToWiFi {
            networkLabelText = "Wifi"
            networkStatusText = "IP: \(SystemServices.shared().wiFiIPAddress!)"
        }else if SystemServices.shared().connectedToCellNetwork {
            networkLabelText = "Cellular"
            networkStatusText = "IP: \(SystemServices.shared().cellIPAddress!)"
        }else{
            networkLabelText = "Offline"
            networkStatusText = SystemServices.shared().carrierName!
        }
        
        networkLabel.setTitle(networkLabelText, for: .normal)
        networkStatusLabel.setTitle(networkLabelText, for: .normal)
        
        netmaskLabel.setTitle(netmaskText, for: .normal)
        externalIPLabel.setTitle(externalIP, for: .normal)
        
        if UIDevice.current.batteryState == UIDevice.BatteryState.charging{
            batteryImageView.image = getCustomizedSFSymbol(name: "battery.100.bolt", color: K.lightGreen, pointSize: 60)
            batteryPercentageLabel.text = "\(Int(batteryLevel * 100))% Charging"
        }else{
            if batteryLevel <= 0.10 {
                batteryImageView.image = getCustomizedSFSymbol(name: "battery.0", color: K.brandRed, pointSize: 60)
            }else if batteryLevel <= 0.25 {
                batteryImageView.image = getCustomizedSFSymbol(name: "battery.25", color: K.brandYellow, pointSize: 60)
            }else if batteryLevel <= 0.50 {
                batteryImageView.image = getCustomizedSFSymbol(name: "battery.50", color: K.brandYellow, pointSize: 60)
            }else if batteryLevel <= 0.75 {
                batteryImageView.image = getCustomizedSFSymbol(name: "battery.75", color: K.lightGreen, pointSize: 60)
            }else if batteryLevel <= 1{
                batteryImageView.image = getCustomizedSFSymbol(name: "battery.100", color: K.lightGreen, pointSize: 60)
            }
            
        }
        
        totalMemoryLabel.setTitle("\(totalMemory)MB", for: .normal)

        
        usedMemoryLabel.setTitle("\(usedMemory)MB Used", for: .normal)
        
        usedMemoryPercent.setTitle("\(usedMemoryPercentText)%", for: .normal)
        
        
        
        freeMemoryLabel.setTitle("\(freeMemory)MB Free", for: .normal)
        freeMemoryPercent.setTitle("\(freeMemoryPercentText)%", for: .normal)
        
        inactiveMemoryLabel.setTitle("\(inactiveMemory)MB Inactive", for: .normal)
        inactiveMemoryPercentageLabel.setTitle("\(inactiveMemoryPercentage)%", for: .normal)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        updateSystemInfo()
        
        let diskSapceFree = UIDevice.current.usedDiskSpaceInGB
        let diskSpaceFree = UIDevice.current.freeDiskSpaceInGB
        let totalDiskSpace = UIDevice.current.totalDiskSpaceInGB
        let usedDiskPercentage = (diskSapceFree as NSString).floatValue / (totalDiskSpace as NSString).floatValue
        
        
        
        
        let image = UIImage(named: "bgColor")
        let color = UIColor.init(patternImage: image!)
        view.backgroundColor = color
        
        title = "Device"
        
        let deviceCardView = createCardView(width: Int((K.screenWidth - 32)), height: 228)
        
        
        scrollView.backgroundColor = color
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(deviceCardView)
        deviceCardView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.centerX.equalTo(scrollView)
        }
        
        
        let deviceNameLabel = createCapsuleLabel(color: K.brandYellow, text: "\(UIDevice.current.name)")
        
        deviceCardView.addSubview(deviceNameLabel)
        deviceNameLabel.snp.makeConstraints { make in
            make.top.equalTo(deviceCardView).offset(20)
            make.left.equalTo(deviceCardView).offset(35)
        }
        

        networkLabel = createCapsuleLabel(color: K.rmPurple, text: networkStatus)
        deviceCardView.addSubview(networkLabel)
        networkLabel.snp.makeConstraints { make in
            make.top.equalTo(deviceNameLabel)
            make.left.equalTo(deviceNameLabel.snp.rightMargin).offset(16)
        }
        
        let carrierLabel = createCapsuleLabel(color: K.gradient1, text: SystemServices.shared().carrierName!)
        deviceCardView.addSubview(carrierLabel)
        carrierLabel.snp.makeConstraints { make in
            make.top.equalTo(deviceNameLabel)
            make.left.equalTo(networkLabel.snp.rightMargin).offset(16)
        }
        

        let modelLabel = createCapsuleLabel(color: K.brandGreen, text: UIDevice.modelName)
        view.addSubview(modelLabel)
        
        modelLabel.snp.makeConstraints { make in
            make.top.equalTo(deviceNameLabel.snp.bottomMargin).offset(16)
            make.left.equalTo(deviceNameLabel)
        }
        
        let deviceStorageLabel = createCapsuleLabel(color: K.brandDarkBlue, text: totalDiskSpace)
        deviceCardView.addSubview(deviceStorageLabel)
        deviceStorageLabel.snp.makeConstraints { make in
            make.top.equalTo(modelLabel)
            make.left.equalTo(modelLabel.snp.rightMargin).offset(16)
        }
        
        let screenResolutionText = "\(Int(UIScreen.main.nativeBounds.width))x\(Int(UIScreen.main.nativeBounds.height))"
        let screenResolutionLabel = createCapsuleLabel(color: .blue, text: screenResolutionText)
        deviceCardView.addSubview(screenResolutionLabel)
        screenResolutionLabel.snp.makeConstraints { make in
            make.top.equalTo(modelLabel.snp.bottomMargin).offset(16)
            make.left.equalTo(modelLabel)
        }
        
        
        let physicalSizeText = getScreenSizeInInch()
        let physicalSizeLabel = createCapsuleLabel(color: .black, text: physicalSizeText)
        deviceCardView.addSubview(physicalSizeLabel)
        physicalSizeLabel.snp.makeConstraints { make in            make.top.equalTo(modelLabel.snp.bottomMargin).offset(16)
            make.left.equalTo(screenResolutionLabel.snp.rightMargin).offset(16)
        }
        
        let ppiText = "\(Int(deviceInfo.displayInfo.pixelsPerInch)) PPI"
        
        let ppiLabel = createCapsuleLabel(color: .orange, text: ppiText)
        
        deviceCardView.addSubview(ppiLabel)
        ppiLabel.snp.makeConstraints { make in
            make.left.equalTo(physicalSizeLabel.snp.rightMargin).offset(16)
            make.top.equalTo(physicalSizeLabel)
        }
        
        
        
        let usedSpaceLabel = createCapsuleLabel(color: K.brandRed, text: "\(diskSapceFree) Used")
        let freeSpaceLabel = createCapsuleLabel(color: K.brandPurple, text: "\(diskSpaceFree) Free")
        
        
        deviceCardView.addSubview(usedSpaceLabel)
        deviceCardView.addSubview(freeSpaceLabel)
        usedSpaceLabel.snp.makeConstraints { make in
            make.top.equalTo(physicalSizeLabel.snp.bottomMargin).offset(16)
            make.left.equalTo(modelLabel)
        }
        
        freeSpaceLabel.snp.makeConstraints { make in
            make.top.equalTo(usedSpaceLabel)
            make.left.equalTo(usedSpaceLabel.snp.rightMargin).offset(16)
        }
 
        
        let versionLabel = createCapsuleLabel(color: K.brandBlue, text: "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
        
        deviceCardView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(usedSpaceLabel.snp.bottomMargin).offset(16)
            make.left.equalTo(deviceNameLabel)
        }
        
        let isJailBroken = BIAInfo.secure.isJailBroken ? "JailBroken" : "Not JailBroken"
        
        let jailBrokenCapsuleColor = BIAInfo.secure.isJailBroken ? UIColor.black : K.brandDarkGrey
        
        let jailBrokenLabel = createCapsuleLabel(color: jailBrokenCapsuleColor, text: "\(isJailBroken)")
        deviceCardView.addSubview(jailBrokenLabel)
        jailBrokenLabel.snp.makeConstraints { make in
            make.top.equalTo(versionLabel)
            make.left.equalTo(versionLabel.snp.rightMargin).offset(16)
        }
        
        
        let batteryCardView = createCardView(width: Int((K.screenWidth - 48) / 2), height: 132)
        
        scrollView.addSubview(batteryCardView)
        batteryCardView.snp.makeConstraints { make in
            make.top.equalTo(deviceCardView.snp.bottom).offset(16)
            make.left.equalTo(deviceCardView)
        }
        
        
        
        
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.updateSystemInfo()
         })
        
        
        
        batteryCardView.addSubview(batteryImageView)
        batteryImageView.snp.makeConstraints { make in
            make.centerX.equalTo(batteryCardView)
            make.top.equalTo(batteryCardView).offset(16)
        }
        
        batteryCardView.addSubview(batteryPercentageLabel)
        batteryPercentageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(batteryCardView)
            make.bottom.equalTo(batteryCardView).offset(-16)
        }
        
        let diskCardView = createCardView(width: Int((K.screenWidth - 48) / 2), height: 132)
        scrollView.addSubview(diskCardView)
        diskCardView.snp.makeConstraints { make in
            make.top.equalTo(deviceCardView.snp.bottom).offset(16)
            make.right.equalTo(deviceCardView)
        }
        
        let diskImageView = UIImageView()
        diskImageView.image = getCustomizedSFSymbol(name: "internaldrive.fill", color: K.darkTab, pointSize: 60)
        diskCardView.addSubview(diskImageView)
        diskImageView.snp.makeConstraints { make in
            make.centerX.equalTo(diskCardView)
            make.top.equalTo(batteryCardView).offset(16)
        }
        

        
        let diskUsagePercentLabel: UILabel = {
            let lbl = UILabel()
            lbl.font = UIFont.init(name: "ArialRoundedMTBold", size: 16)
            lbl.text = "\(Int(Double(usedDiskPercentage).roundToDecimal(2) * 100))% Space Used"
            return lbl
        }()
        
        diskCardView.addSubview(diskUsagePercentLabel)
        diskUsagePercentLabel.snp.makeConstraints { make in
            make.centerX.equalTo(diskCardView)
            make.bottom.equalTo(diskCardView).offset(-16)
        }
        
        let cpuDashboardCardView = createCardView(width: Int((K.screenWidth - 32)), height: 148)

        scrollView.addSubview(cpuDashboardCardView)
        cpuDashboardCardView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(batteryCardView.snp_bottomMargin).offset(24)
        }
        
        let cpuImage = getCustomizedSFSymbol(name: "cpu", color: K.darkTab, pointSize: 60)
        
        let cpuImageView = UIImageView()
        cpuImageView.image = cpuImage
        
        cpuDashboardCardView.addSubview(cpuImageView)
        cpuImageView.snp.makeConstraints { make in
            make.centerY.equalTo(cpuDashboardCardView)
            make.left.equalTo(cpuDashboardCardView).offset(24)
        }
        
        
        let cpuNameLabel = createCapsuleLabel(color: K.brandBlue, text: "Apple \(UIDevice.current.getCPUName())")
        
        cpuDashboardCardView.addSubview(cpuNameLabel)
        cpuNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cpuDashboardCardView).offset(20)
            make.left.equalTo(cpuImageView.snp.rightMargin).offset(32)
        }
        
        let cpuSpeedLabel = createCapsuleLabel(color: K.gradient2, text: UIDevice.current.getCPUSpeed())
        
        cpuDashboardCardView.addSubview(cpuSpeedLabel)
        cpuSpeedLabel.snp.makeConstraints { make in
            make.top.equalTo(cpuNameLabel)
            make.left.equalTo(cpuNameLabel.snp.rightMargin).offset(16)
        }
        
        
        
        
        let activeProcessorLabel = createCapsuleLabel(color: K.brandPurple, text: "Active Processors: \(BIAInfo.processor.activeCount)")
        
        let totalProcessorLabel = createCapsuleLabel(color: K.brandRed, text: "Total Processors: \(BIAInfo.processor.count)")
        
        cpuDashboardCardView.addSubview(activeProcessorLabel)
        cpuDashboardCardView.addSubview(totalProcessorLabel)
        
        totalProcessorLabel.snp.makeConstraints { make in
            make.left.equalTo(cpuNameLabel)
            make.top.equalTo(cpuNameLabel.snp.bottomMargin).offset(16)
        }
        
        activeProcessorLabel.snp.makeConstraints { make in
            make.left.equalTo(cpuNameLabel)
            make.top.equalTo(totalProcessorLabel.snp.bottomMargin).offset(16)
        }
        
        let networkCardView = createCardView(width: Int((K.screenWidth - 32)), height: 148)
        
        scrollView.addSubview(networkCardView)
        networkCardView.snp.makeConstraints { make in
            make.top.equalTo(cpuDashboardCardView.snp.bottomMargin).offset(24)
            make.left.equalTo(cpuDashboardCardView)

        }
        
        
        networkImageView.image = getCustomizedSFSymbol(name: "network", color: K.brandDark, pointSize: 60)
        networkCardView.addSubview(networkImageView)
        networkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(networkCardView)
            make.centerX.equalTo(cpuImageView)
        }
        

        
        networkStatusLabel = createCapsuleLabel(color: K.brandPurple, text: networkLabelText)
        
        networkIPLabel = createCapsuleLabel(color: K.gradient2, text: networkStatusText)
        
        
        networkCardView.addSubview(networkStatusLabel)
        networkCardView.addSubview(networkIPLabel)
        
        networkStatusLabel.snp.makeConstraints { make in            make.top.equalTo(networkCardView).offset(20)
            make.left.equalTo(cpuNameLabel)
        }
        
        networkIPLabel.snp.makeConstraints { make in            make.top.equalTo(networkStatusLabel)
            make.left.equalTo(networkStatusLabel.snp.rightMargin).offset(16)
        }
        

        netmaskLabel = createCapsuleLabel(color: K.brandYellow, text: netmaskText)
        
        externalIPLabel = createCapsuleLabel(color: K.brandBlue, text: externalIP)
        
        networkCardView.addSubview(netmaskLabel)
        networkCardView.addSubview(externalIPLabel)
        
        netmaskLabel.snp.makeConstraints { make in
            make.left.equalTo(networkStatusLabel)
            make.top.equalTo(networkStatusLabel.snp.bottomMargin).offset(16)
        }
        
        externalIPLabel.snp.makeConstraints { make in
            make.left.equalTo(netmaskLabel)
            make.top.equalTo(netmaskLabel.snp.bottomMargin).offset(16)
        }
        
        totalMemoryLabel = createCapsuleLabel(color: .orange, text: "Total: \(totalMemory)")
        
        usedMemoryLabel = createCapsuleLabel(color: K.brandRed, text: "\(usedMemory) In Use")
        
        usedMemoryPercent = createCapsuleLabel(color: K.brandRed, text: "\(usedMemoryPercentText)%")
        
        freeMemoryLabel = createCapsuleLabel(color: K.brandGreen, text: "\(freeMemory) Free")
        
        freeMemoryPercent = createCapsuleLabel(color: K.brandGreen, text: "\(freeMemoryPercentText)%")
        
        inactiveMemoryLabel = createCapsuleLabel(color: K.brandDarkGrey, text: "")
        inactiveMemoryPercentageLabel = createCapsuleLabel(color: K.brandDarkGrey, text: "")
        
        let memoryCardView = createCardView(width: Int((K.screenWidth - 32)), height: 188)
        
        scrollView.addSubview(memoryCardView)
        memoryCardView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(networkCardView.snp.bottomMargin).offset(24)
        }
        
        memoryCardView.addSubview(totalMemoryLabel)
        memoryCardView.addSubview(freeMemoryLabel)
        memoryCardView.addSubview(freeMemoryPercent)
        memoryCardView.addSubview(usedMemoryLabel)
        memoryCardView.addSubview(usedMemoryPercent)
        memoryCardView.addSubview(inactiveMemoryLabel)
        memoryCardView.addSubview(inactiveMemoryPercentageLabel)
        
        let memoryImageView = UIImageView()
        memoryImageView.image = getCustomizedSFSymbol(name: "memorychip", color: K.darkTab, pointSize: 60)
        
        memoryCardView.addSubview(memoryImageView)
        memoryImageView.snp.makeConstraints { make in
            make.centerX.equalTo(networkImageView)
            make.centerY.equalTo(memoryCardView)
        }
        
        totalMemoryLabel.snp.makeConstraints { make in
            make.left.equalTo(externalIPLabel)
            make.top.equalTo(memoryCardView).offset(20)
        }
        
        usedMemoryLabel.snp.makeConstraints { make in
            make.left.equalTo(totalMemoryLabel)
            make.top.equalTo(totalMemoryLabel.snp.bottomMargin).offset(16)
        }
        
        usedMemoryPercent.snp.makeConstraints { make in
            make.left.equalTo(usedMemoryLabel.snp.rightMargin).offset(16)
            make.top.equalTo(usedMemoryLabel)
        }
        
        freeMemoryLabel.snp.makeConstraints { make in
            make.left.equalTo(usedMemoryLabel)
            make.top.equalTo(usedMemoryLabel.snp.bottomMargin).offset(16)
        }
        
        freeMemoryPercent.snp.makeConstraints { make in
            make.top.equalTo(freeMemoryLabel)
            make.left.equalTo(freeMemoryLabel.snp.rightMargin).offset(16)
        }
        
        inactiveMemoryLabel.snp.makeConstraints { make in
            make.left.equalTo(freeMemoryLabel)
            make.top.equalTo(freeMemoryLabel.snp.bottomMargin).offset(16)
        }
        
        inactiveMemoryPercentageLabel.snp.makeConstraints { make in
            make.top.equalTo(inactiveMemoryLabel)
            make.left.equalTo(inactiveMemoryLabel.snp.rightMargin).offset(16)
        }
        
        
        let gradientImage = UIImage(named: "lblColor")
        let gradientColor = UIColor.init(patternImage: gradientImage!)
        
        let nameLabel = UIButton()
        nameLabel.setBackgroundImage(UIImage(named: "lblColor"), for: .normal)
        nameLabel.clipsToBounds = true
        nameLabel.titleLabel?.font =  UIFont.init(name: "ArialRoundedMTBold", size: 18)
        
        nameLabel.setTitle("Device Assistant", for: .normal)
        Helper.setHeight(nameLabel, 50)
        Helper.setWidth(nameLabel, 200)
 
        
        
        
        nameLabel.layer.cornerRadius = 25
        scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(memoryCardView.snp.bottomMargin).offset(32)
        }
    }
    
}


