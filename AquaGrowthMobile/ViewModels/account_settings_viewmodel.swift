//
//  account_settings_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation

class account_settings_viewmodel: ObservableObject{
    @Published var notifyMeAbout = ""
    @Published var NotifyMeAboutType = ""
    
    @Published var playNotifications = false
    @Published var sendReadReceipt = false

    init(){}
    
}
