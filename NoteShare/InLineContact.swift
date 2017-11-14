//
//  InLineContact.swift
//  NoteShare
//
//  Created by Prato Das on 2017-10-02.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import MessageUI

class InLineContact: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtMsg: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callPhone(_ sender: UIButton) {
        txtMsg.resignFirstResponder()
        txtPhone.resignFirstResponder()
        if let phoneURL = NSURL(string: "tel://\(txtMsg.text!)")
        {
            UIApplication.shared.openURL(phoneURL as URL)
        }
    }
    @IBAction func sendSMS(_ sender: UIButton) {
        let msgVC = MFMessageComposeViewController()
        msgVC.body = "Hi Dawg!, wassup?"
        msgVC.recipients = [txtPhone.text!]
        msgVC.messageComposeDelegate = self
        
        self.present(msgVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }

    

}
