//
//  support_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Megan Kang on 4/27/24.
//

//import Foundation
//import MessageUI
//
//class support_viewmodel: NSObject, MFMailComposeViewControllerDelegate {
//
//    func sendMessage(message: String) {
//        if MFMailComposeViewController.canSendMail() {
//            let mailComposer = MFMailComposeViewController()
//            mailComposer.mailComposeDelegate = self
//            mailComposer.setToRecipients(["AquaGrowth@gmail.com"])
//            mailComposer.setSubject("Support Request")
//            mailComposer.setMessageBody(message, isHTML: false)
//            
//            // Get the top-most view controller to present the mail composer
//            if let topViewController = UIApplication.shared.windows.first?.rootViewController {
//                topViewController.present(mailComposer, animated: true, completion: nil)
//            }
//        } else {
//            print("Email cannot be sent. Please configure your mail settings.")
//        }
//    }
//
//    // MARK: - MFMailComposeViewControllerDelegate
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//        // Handle the result of the email sending process if needed
//    }
//}

import Foundation
import MessageUI
import Combine

class support_viewmodel: NSObject, ObservableObject, MFMailComposeViewControllerDelegate {
    @Published var showingMailAlert = false
    @Published var mailAlertTitle = ""
    @Published var mailAlertMessage = ""

    func sendMessage(message: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["aquagrowthofficial@gmail.com"])
            mailComposer.setSubject("Support Request")
            mailComposer.setMessageBody(message, isHTML: false)

            // Get the top-most view controller to present the mail composer
            if let topViewController = UIApplication.shared.windows.first?.rootViewController {
                topViewController.present(mailComposer, animated: true, completion: nil)
            }
        } else {
            // Handle case where email cannot be sent
            showingMailAlert = true
            mailAlertTitle = "Error"
            mailAlertMessage = "Email cannot be sent. Please configure your mail settings."
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

        // Handle the result of the email sending process if needed
        switch result {
        case .sent:
            showingMailAlert = true
            mailAlertTitle = "Success"
            mailAlertMessage = "Your message has been sent successfully!"
        case .cancelled:
            // Handle case where user cancels sending the email
            showingMailAlert = false // Dismiss any existing alert
        case .failed:
            // Handle case where email sending failed
            showingMailAlert = true
            mailAlertTitle = "Error"
            mailAlertMessage = "Failed to send email. Please try again."
        case .saved:
            // Handle case where user saves the email as a draft
            showingMailAlert = false // Dismiss any existing alert
        @unknown default:
            break
        }
    }
}
