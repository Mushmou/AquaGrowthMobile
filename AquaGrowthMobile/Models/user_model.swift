//
//  user.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation

struct User: Codable{
    let id: String
    let username: String
    let email: String
    let password: String
    let signupDateTime: TimeInterval
}
