//
//  SignUpViewController.swift
//  practice
//
//  Created by Eunji Kim on 12/19/24.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var pwConfirmValidate: UILabel!
    @IBOutlet weak var pwValidate: UILabel!
    @IBOutlet weak var emailValidate: UILabel!
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPw: UITextField!
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    
    var emailClicked = false
    var passwordClicked = false
    var pwConfirmClicked = false
    var isViewMoved = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfEmail.addTarget(self, action: #selector(emailDidChange(_ :)), for: .editingChanged)
        tfPassword.addTarget(self, action: #selector(pwDidChange(_ :)), for: .editingChanged)
        tfConfirmPw.addTarget(self, action: #selector(pwConfirmDidChange(_ :)), for: .editingChanged)
        emailValidate.text = ""
        pwValidate.text = ""
        pwConfirmValidate.text = ""
        tfPassword.isSecureTextEntry = true
        tfConfirmPw.isSecureTextEntry = true
        
        tfEmail.delegate = self
        tfPassword.delegate = self
        tfConfirmPw.delegate = self
        
        setKeyboardEvent()

    }
    
    
    // 로그인 화면으로 넘어가는 버튼
    @IBAction func btnLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // registor 버튼
    @IBAction func btnSignUp(_ sender: Any) {
        
        guard let email = tfEmail.text else {return}
        guard let password = tfPassword.text else {return}
        if emailValidate.isHidden &&  pwValidate.isHidden && pwConfirmValidate.isHidden && !tfEmail.text!.isEmpty && !tfPassword.text!.isEmpty && !tfConfirmPw.text!.isEmpty {
            
            googleSignUp(email: email, password: password)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please Check your input.", preferredStyle: .alert)
            let action  = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }
        
        
    }
    // 이메일 텍스트필드 변경시 검증
    @objc func emailDidChange(_ textField: UITextField) {
        validateTextField(textField, errorLabel: emailValidate, errorText: "The email format is incorrect.", regex: emailRegEx)
    }
    // 패스워드 텍스트필드 변경시 검증
    @objc func pwDidChange(_ textField: UITextField) {
        validateTextField(textField, errorLabel: pwValidate, errorText: "At least 8 characters long and include both letters and numbers", regex: passwordRegEx)
        checkPasswordMatch(textField: textField)
    }
    // 패스워드 확인 텍스트 필드 변경시 검증
    func checkPasswordMatch(textField: UITextField) {
        if !pwValidate.isHidden {
            validateTextField(textField, errorLabel: pwValidate, errorText: "At least 8 characters long and include both letters and numbers", regex: passwordRegEx)
        }
        guard let password = tfPassword.text else {return}
        guard let confirmPw = tfConfirmPw.text else {return}
    
        if password != confirmPw {
            pwConfirmValidate.text = "The passwords entered do not match."
            pwConfirmValidate.isHidden = false
            pwConfirmValidate.textColor = .red
        } else {
            pwConfirmValidate.isHidden = true
        }
    }
        @objc func pwConfirmDidChange(_ textField: UITextField) {
            checkPasswordMatch(textField: textField)
        }
    
    // 이메일과 비밀번호 검증 함수
    func validateTextField(_ textField: UITextField, errorLabel: UILabel, errorText: String, regex: String) {
        guard let text = textField.text else { return }
        
        if !isValidInput(text, regex) {
            errorLabel.text = errorText
            errorLabel.textColor = .red
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
        }
    }
    
    func isValidInput(_ input: String,_ regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
    
    // 구글과 연동하여 로그인
    func googleSignUp(email:String, password:String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            } else {
                print("User signed up successfully")
                // Navigate to LoginViewController or main app interface
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setKeyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ : )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_ : )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(_ sender: NotificationCenter){
        if !isViewMoved  && emailClicked {
            self.view.frame.origin.y -= 120
            isViewMoved = true
        } else if !isViewMoved && passwordClicked {
            self.view.frame.origin.y -= 120
            isViewMoved = true
        } else if !isViewMoved && pwConfirmClicked {
            self.view.frame.origin.y -= 120
            isViewMoved = true
        }
        
    }
    @objc func keyboardWillDisappear(_ sender: NotificationCenter){
        if isViewMoved {
            self.view.frame.origin.y = 0
                   isViewMoved = false
               }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
    
}// SignUpViewController

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailClicked = false
        passwordClicked = false
        pwConfirmClicked = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailClicked = true
        passwordClicked = true
        pwConfirmClicked = true

    }
}
