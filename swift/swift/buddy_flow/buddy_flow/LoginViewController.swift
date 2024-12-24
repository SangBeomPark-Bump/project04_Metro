//
//  LoginViewController.swift
//  practice
//
//  Created by Eunji Kim on 12/19/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    var emailClicked: Bool = false
    var passwordClicked: Bool = false
    var isViewMoved: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        btnGoogle.addTarget(self, action: #selector(SignUpWithGoogle), for: .touchUpInside)
        
        setKeyboardEvent()
        applyShadow(view: btnGoogle)
        applyShadow(view: btnLogin)
        applyShadow(view: tfEmail)
        applyShadow(view: tfPassword)
        applyCornerRadius(view: tfEmail)
        applyCornerRadius(view: tfPassword)
        
        tfEmail.delegate = self
        tfPassword.delegate = self
        
    }
    // 버튼 및 텍스트필드 스타일
    func applyShadow(view: UIView){
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 2
    }
    func applyCornerRadius(view: UIView){
        view.layer.cornerRadius = 10
    }

    // 구글 로그인 버튼 클릭시 함수
    @objc func SignUpWithGoogle() {
        print("Button has been clicked")
        GIDSignIn.sharedInstance.signIn(withPresenting: self){SignInResult, error in
            // error
            if let error = error{
                print("\(error.localizedDescription)")
                return
            }
            // user token
            guard let user = SignInResult?.user, let idToken = user.idToken?.tokenString
            else {
                print("no user or no Token")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error {
                    print("\(error.localizedDescription)")
                    return
                }
                print("\(authResult!.user.uid)")
                self.showHomeScreen()
                
            }
            
        }
        
    }
    
    // 로그인이 완료되어 홈으로 넘어가는 함수
    func showHomeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "home") as! ViewController
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
        
    }

    // 로그인 버튼
    @IBAction func btnLogin(_ sender: UIButton) {
        guard let email = tfEmail.text else { return }
        guard let password = tfPassword.text else { return }
        if !email.isEmpty && !password.isEmpty{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else { return }
                if let error {
                    print("\(error.localizedDescription)")
                    let alert = UIAlertController(title: "Alert", message: "Invalid username or password. Please try again", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                    self!.present(alert, animated: true)
                    return
                }
                print("\(authResult!.user.uid)")
                self!.showHomeScreen()
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Invalid username or password. Please try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
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

}// ViewController

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailClicked = false
        passwordClicked = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailClicked = true
        passwordClicked = true
        
    }
}
