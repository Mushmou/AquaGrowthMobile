//
//  Utilities.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 3/13/24.
//

import Foundation
import UIKit
final class Utilities {
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController?{
        let controler = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController{
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController{
            if let selected = tabController.selectedViewController{
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController{
            return topViewController(controller: presented)
        }
        return controller
    }
}

final class Application_utility {
    static var rootViewController: UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }
}
