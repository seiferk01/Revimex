//
//  LogInController.swift
//  Revimex
//
//  Created by Seifer on 16/11/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class LogInController: UIViewController {
    
    
    @IBOutlet weak var usuarioLabel: UITextField!
    @IBOutlet weak var contrasenaLabel: UITextField!
    
    var usuario = ""
    var contraseña = ""
    
    //para un metodo del sdk de facebbok
    var dict : [String : AnyObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incioSesionBtn.isHidden = true
        self.hideKeyboard()
        
        if isAlreadyIn == false {
            let screenSize = UIScreen.main.bounds
        
            let navBar: UINavigationBar = UINavigationBar()
            navBar.frame = CGRect(x: 0.0,y: 0.0,width: screenSize.width,height: screenSize.height/3)  // Here you can set you Width and Height for your navBar
            navBar.backgroundColor = azul
        
            let logo = UIImage(named: "revimex.png")
            let imageView = UIImageView(image:logo)
            imageView.frame = CGRect(x: screenSize.width/8,y: screenSize.height/7,width: screenSize.width*(6/8),height: screenSize.height/8)
        
            view.addSubview(navBar)
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
            navBar.addSubview(imageView)
        }
        
//        // Add a custom login button to your app
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginButtonClicked(tapGestureRecognizer:)))
//
//        let myLoginButton = UIButton()
//        myLoginButton.backgroundColor = UIColor.blue
//        myLoginButton.frame = CGRect(x: 200,y: 0,width: 180,height: 40);
//        myLoginButton.center = view.center;
//        myLoginButton.setTitle("My Login Button", for: .normal)
//
//        // Handle clicks on the button
//        myLoginButton.addGestureRecognizer(tapGestureRecognizer)
//
//        // Add the button to the view
//        view.addSubview(myLoginButton)
        
        //if the user is already logged in
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        incioSesionBtn.isHidden = false
    }
    
    
    @IBAction func entrarComoInvitado(_ sender: Any) {
        isAlreadyIn = true
    }
    
    
    @IBAction func iniciaSesion(_ sender: Any) {
        isAlreadyIn = true
        usuario = usuarioLabel.text!
        contraseña = contrasenaLabel.text!
        
        if isValidEmail(testStr: usuario){
        
            let urlRequestFiltros = "http://18.221.106.92/api/public/user/login"
        
            let parameters: [String:Any] = [
                "email" : usuario,
                "password" : contraseña
            ]
        
            guard let url = URL(string: urlRequestFiltros) else { return }
        
            var request = URLRequest (url: url)
            request.httpMethod = "POST"
        
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
            let session  = URLSession.shared
        
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                        
                        print(json["status"] as! Int)
                        print(json["mensaje"] as! String)
                        
                        switch (json["status"] as! Int) {
                        case 0,2:
                            self.alerta(titulo: "Datos Incorrectos",mensaje: "Correo o contraseña no validos")
                        case 1:
                            UserDefaults.standard.set(true, forKey: "loggedIn")
                            UserDefaults.standard.set(self.usuario, forKey: "usuario")
                            UserDefaults.standard.set(self.contraseña, forKey: "contraseña")
                            if let userId = (json["user_id"] as? String){
                                UserDefaults.standard.set(userId, forKey: "userId")
                            }
                        default:
                            print("Status recibido del servidor no especificado")
                        }
                        
                    } catch {
                        print("El error es: ")
                        print(error)
                    }
                    
                    OperationQueue.main.addOperation({
                        var logged = false
                        if let loggedIn = UserDefaults.standard.object(forKey: "loggedIn") as? Bool{
                            logged = loggedIn
                        }
                        if logged {
                            self.continuar()
                        }
                    })
                    
                }
            }.resume()
            
        }
        else{
            alerta(titulo: "Datos Incorrectos",mensaje: "Ingresa un correo valido")
        }
        
    }
    
    
    @IBAction func nuevaCuenta(_ sender: Any) {
        isAlreadyIn = true
        usuario = usuarioLabel.text!
        contraseña = contrasenaLabel.text!
        
        if isValidEmail(testStr: usuario){
            
            if contraseña.count > 5 {
                
                let urlRequestFiltros = "http://18.221.106.92/api/public/user/register"
            
                let parameters: [String:Any] = [
                    "email" : usuario,
                    "password" : contraseña
                ]
            
                guard let url = URL(string: urlRequestFiltros) else { return }
            
                var request = URLRequest (url: url)
                request.httpMethod = "POST"
            
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                }
            
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
                let session  = URLSession.shared
            
                session.dataTask(with: request) { (data, response, error) in
                    
                    if let response = response {
                        print(response)
                    }
                    
                    if let data = data {
                        
                        do {
                            let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                            
                            print(json["status"] as! Int)
                            print(json["mensaje"] as! String)
                            
                            if (json["status"] as! Int) == 1 {
                                UserDefaults.standard.set(true, forKey: "loggedIn")
                                UserDefaults.standard.set(self.usuario, forKey: "usuario")
                                UserDefaults.standard.set(self.contraseña, forKey: "contraseña")
                                if let userId = (json["user_id"] as? String){
                                    UserDefaults.standard.set(userId, forKey: "userId")
                                }
                            }
                            
                        } catch {
                            print("El error es: ")
                            print(error)
                        }
                        
                        OperationQueue.main.addOperation({
                            var logged = false
                            if let loggedIn = UserDefaults.standard.object(forKey: "loggedIn") as? Bool{
                                logged = loggedIn
                            }
                            if logged {
                                self.continuar()
                            }
                        })
                        
                    }
                }.resume()
                
            }
            else{
                alerta(titulo: "Datos Incorrectos",mensaje: "La contraseña debe tener al menos 6 caracteres")
            }
            
        }
        else{
            alerta(titulo: "Datos Incorrectos",mensaje: "Ingresa un correo valido")
        }
        
    }
    
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func alerta(titulo: String,mensaje: String){
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func continuar(){
        self.performSegue(withIdentifier: "logedIn", sender: nil)
    }
    
    //when login button clicked
    @IBAction func loginButtonClicked(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }

}
