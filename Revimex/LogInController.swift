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
    @IBOutlet var invitadoBtn: UIView!
    
    var usuario = ""
    var contraseña = ""
    
    //para un metodo del sdk de facebbok
    var dict : [String : AnyObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pculta el boton de inicio de secion
        incioSesionBtn.isHidden = true
        
        //permite que el teclado se esconda al hacer click en otro lugar de la pantalla
        self.hideKeyboard()
        
        //asigna color tamaño y logo a la barra de navegacion dependiendo de si ya existe un usuario registrado
        switch navBarStyleCase {
            case 0:
                let screenSize = UIScreen.main.bounds
                
                let navBar: UINavigationBar = UINavigationBar()
                navBar.frame = CGRect(x: 0.0,y: 0.0,width: screenSize.width,height: screenSize.height/3)
                navBar.backgroundColor = UIColor.black
                
                let logo = UIImage(named: "revimex.png")
                let imageView = UIImageView(image:logo)
                imageView.frame = CGRect(x: screenSize.width/8,y: screenSize.height/7,width: screenSize.width*(6/8),height: screenSize.height/8)
                
                view.addSubview(navBar)
                navBar.setBackgroundImage(UIImage(), for: .default)
                navBar.shadowImage = UIImage()
                navBar.isTranslucent = true
                navBar.addSubview(imageView)
                invitadoBtn.isHidden = false
                break
            case 1:
                print("vista uno")
                break
            case 2:
                print("vista dos")
                break
            default:
                invitadoBtn.isHidden = true
            
        }
        
        
        //pide a facebook los datos de ususario en caso de que ya se haya logueado anteriormente
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //muestra nuevamente el boton de inicio de sesion en la barra de navegacion al ocultar la pagina
        incioSesionBtn.isHidden = false
    }
        
    
    @IBAction func entrarComoInvitado(_ sender: Any) {
        
    }
    
    
    //genera un alert
    func alerta(titulo: String,mensaje: String){
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //navega a la pagina principal
    func continuar(){
        self.performSegue(withIdentifier: "logedIn", sender: nil)
    }
    
    
    //********************************Funcion de inicio de sesion********************************
    @IBAction func iniciaSesion(_ sender: Any) {
        
        usuario = usuarioLabel.text!
        contraseña = contrasenaLabel.text!
        
        if Utilities.isValidEmail(testStr: usuario){
        
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
                            //guarda los datos del usuario si la respuesta fue exitosa
                            UserDefaults.standard.set(self.usuario, forKey: "usuario")
                            UserDefaults.standard.set(self.contraseña, forKey: "contraseña")
                            if let userId = (json["user_id"] as? Int){
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
                        if (UserDefaults.standard.object(forKey: "userId") as? Int) != nil{
                            //si se obtuvo un id de usuario, continua a la pagina principal
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
    
    
    //********************************Funcion de creacion de cuenta********************************
    @IBAction func nuevaCuenta(_ sender: Any) {
        
        usuario = usuarioLabel.text!
        contraseña = contrasenaLabel.text!
        
        if Utilities.isValidEmail(testStr: usuario){
            
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
                                //guarda los datos del usuario si la respuesta fue exitosa
                                UserDefaults.standard.set(self.usuario, forKey: "usuario")
                                UserDefaults.standard.set(self.contraseña, forKey: "contraseña")
                                if let userId = (json["user_id"] as? Int){
                                    UserDefaults.standard.set(userId, forKey: "userId")
                                }
                            }
                            
                        } catch {
                            print("El error es: ")
                            print(error)
                        }
                        
                        OperationQueue.main.addOperation({
                            if (UserDefaults.standard.object(forKey: "userId") as? Int) != nil{
                                //si se obtuvo un id de usuario, continua a la pagina principal
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
    
    
    //*******************************Funciones para loggin con facebook******************************
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
