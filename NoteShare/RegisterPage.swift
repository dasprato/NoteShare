//
//  RegisterPage
//  NoteShare
//
//  Created by Prato Das on 2017-10-02.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class RegisterPage: UIViewController {
    @IBOutlet weak var txtNameOUTLET: UITextField!
    @IBOutlet weak var txtEmailOUTLET: UITextField!
    
    @IBOutlet weak var txtPasswordOUTLET: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRegisterPress(_ sender: UIButton) {
        handleRegister()
    }
    
    
    private func handleRegister() {
        let name = txtNameOUTLET.text
        let userid = String(Int(Date().timeIntervalSince1970)) + name!
        let email = txtEmailOUTLET.text
        let pass = txtPasswordOUTLET.text
        Auth.auth().createUser(withEmail: email!, password: pass!, completion: { (User, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            let userref =  String(Int(Date().timeIntervalSince1970)) + userid
            let ref = Database.database().reference(fromURL: "https://noteshare-7c70f.firebaseio.com/")
            
            let usersReference = ref.child("users").child(userref)
            let values = ["name": name, "userid": userid, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print (err)
                    err
                }
            })
            let View = self.storyboard?.instantiateViewController(withIdentifier: "HomePage")
            self.present(View!, animated: true, completion: nil)
            //successfully authenticated
        })
    }
}

