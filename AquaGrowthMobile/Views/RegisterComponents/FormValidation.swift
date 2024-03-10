//
//  FormValidation.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/29/24.
//

import Foundation
fileprivate protocol FormValidation{
    var isValid: Bool{get}
    var value: String{get set}
    var error: String{get}
    var isSubmitted: Bool{get}
    func submitted()
}

class Email: FormValidation, ObservableObject{
    @Published private(set) var isValid: Bool = true
    @Published var value: String = ""
    @Published private (set) var error: String = ""
    @Published fileprivate var isSubmitted: Bool = false
    
    init(){
        $value.combineLatest($isSubmitted)
    }
    
    func submitted() {
        isSubmitted = true
    }
}
