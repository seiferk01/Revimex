//
//  InfoUserController.swift
//  
//
//  Created by Maquina 53 on 30/11/17.
//

import UIKit

class InfoUserController: UIViewController {
    
    @IBOutlet weak var imgUser: UIImageView!;
    @IBOutlet weak var scVwDatosUser: UIScrollView!;
    
    @IBOutlet weak var txFlEmailUser: UITextField!;
    @IBOutlet weak var txFlNameUser: UITextField!;
    @IBOutlet weak var txFlPApellidoUser: UITextField!;
    @IBOutlet weak var txFlSApellidoUser: UITextField!;
    @IBOutlet weak var txFlEstadoUser: UITextField!;
    @IBOutlet weak var txFlTelUser: UITextField!;
    @IBOutlet weak var txFlFacebookUser: UITextField!;
    @IBOutlet weak var txFlGoogleUser: UITextField!;
    @IBOutlet weak var txFlFechaNacUser: UITextField!;
    @IBOutlet weak var txFlDirUser: UITextField!;
    @IBOutlet weak var txFlRFCUser: UITextField!;
    
    @IBOutlet weak var btGuardar: UIButton!
    private let fltBtn:UIButton! = UIButton();
    
    private var user_id : String!;
    private var cuentaBtn: UIButton!;
    private var tapGesture: UITapGestureRecognizer!;
    private var menuContainer: UIView!;
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard();
        
        self.navigationController?.isNavigationBarHidden = false;
        
        //Se obtiene de las subviews el Boton de información de usuario
        let a = self.navigationController?.navigationBar.subviews;
        cuentaBtn = a![5] as! UIButton;
        
        cuentaBtn.setBackgroundImage(UIImage(named:"menu-horizontal-100.png"), for: .normal);
        tapGesture = UITapGestureRecognizer(target: self,action: #selector(InfoUserController.menuTapped(tapGestureRecognizer:)));
        cuentaBtn.addGestureRecognizer(tapGesture);
        
        iniMenu();
        
        user_id = UserDefaults.standard.string(forKey: "userId")!;
        
        scVwDatosUser.isScrollEnabled = true;
        scVwDatosUser.contentSize =    CGSize(width: scVwDatosUser.contentSize.width,height: (txFlDirUser.frame.height+10)*13);
        
        txFlEmailUser.placeholder = "Email" ;
        txFlEmailUser.keyboardType = UIKeyboardType.emailAddress;
        txFlEmailUser.isEnabled = false;
        txFlEmailUser.tag = 5;
        
        txFlNameUser.placeholder = "Nombre (s)";
        
        txFlPApellidoUser.placeholder = "Apellido Paterno";
        txFlSApellidoUser.placeholder = "Apellido Materno";
        txFlEstadoUser.placeholder = "Estado";
        
        txFlTelUser.placeholder = "Teléfono";
        txFlTelUser.keyboardType = UIKeyboardType.emailAddress;
        
        txFlFacebookUser.placeholder = "Dirección de Facebook";
        txFlFacebookUser.keyboardType = UIKeyboardType.emailAddress;
        
        txFlGoogleUser.placeholder = "Correo Google";
        txFlGoogleUser.keyboardType = UIKeyboardType.emailAddress;
        
        txFlFechaNacUser.placeholder = "Fecha de Nacimiento";
        txFlDirUser.placeholder = "Dirección";
        txFlRFCUser.placeholder = "RFC";
        
        btGuardar.isHidden = true;
        
        disable_EnableAllSub(principal: scVwDatosUser)
        
        btnFlotante();
        obtInfoUser();
        
        print(scVwDatosUser.contentSize.height);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func actionGuardar(_ sender: Any) {
        if(Utilities.isValidEmail(testStr: txFlEmailUser.text!)){
            self.setInfoUser();
            self.disable_EnableAllSub(principal: scVwDatosUser);
            btGuardar.isHidden = true;
            fltBtn.isHidden = false;
        }
    }
    
    //Actualiza la información de usuario
    private func setInfoUser(){
        
        let url = "http://18.221.106.92/api/public/user";
        guard let urlUpdate = URL(string:url)else{print("ERROR UPDATE");return};
        
        let parameters: [String:Any?] = [
            "user_id" :  user_id,
            "email" : txFlEmailUser.text,
            "name" : txFlNameUser.text,
            "apellidoPaterno" : txFlPApellidoUser.text,
            "apellidoMaterno" : txFlSApellidoUser.text,
            "estado" : txFlEstadoUser.text,
            "tel" : txFlTelUser.text,
            "facebook" : txFlFacebookUser.text,
            "google" : txFlGoogleUser.text,
            "fecha_nacimiento" : txFlFechaNacUser.text,
            "direccion" : txFlDirUser.text,
            "rfc" : txFlRFCUser.text
        ];
        
        var request = URLRequest(url: urlUpdate);
        request.httpMethod = "POST";
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted);
        }catch{
            print(error);
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        let session = URLSession.shared;
        session.dataTask(with: request){ (data,response,error) in
            
            
            if(error == nil){
                
                if let data = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! [String:Any?];
                    }catch{
                        print(error);
                    }
                }
                OperationQueue.main.addOperation {
                    let alert = UIAlertController(title: "Exito", message: "Los datos se han guardado", preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert,animated:true,completion:nil);
                }
            }else{
                OperationQueue.main.addOperation {
                    let alert = UIAlertController(title: "Error", message: "error: "+error.debugDescription, preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert,animated:true,completion:nil);
                }
            }
        }.resume();
        
    }
    
    //Crea el botón flotante
    private func btnFlotante(){
        
        
        let subScreen = scVwDatosUser.bounds;
        print(subScreen.width);
        print(subScreen.height);
        fltBtn.frame = CGRect(x: subScreen.width - 45, y: subScreen.height - 45, width: 38, height: 38);
        fltBtn.setBackgroundImage(UIImage(named: "pencil.png"), for: .normal);
        fltBtn.contentMode = .scaleToFill;
        fltBtn.backgroundColor = UIColor.white;
        fltBtn.clipsToBounds = true;
        fltBtn.layer.cornerRadius = 15;
        fltBtn.layer.shadowRadius = 1.2;
        fltBtn.layer.shadowOffset = CGSize(width: 0.8, height: 0.8);
        fltBtn.layer.shadowOpacity = 0.5;
        
        fltBtn.addTarget(self, action: #selector(InfoUserController.EnableEdit), for: .touchUpInside);
        
        scVwDatosUser.addSubview(fltBtn);
    }
    
    //Crear menu contextual
    private func iniMenu(){
        
        let screenSize = UIScreen.main.bounds;
        let navigation = navigationController?.navigationBar.frame;
        let posY = navigation?.maxY;
        let posX = navigation?.maxX;
        
        menuContainer = UIView(frame: CGRect(/*x: 200, y: 500, width: 100, height: 100*/));
        menuContainer.frame = CGRect(x: posX! - (screenSize.width*(0.3)) - 5, y: posY!, width: screenSize.width*(0.3), height: 100);
        menuContainer.backgroundColor = UIColor.white;
        menuContainer.layer.masksToBounds = false;
        menuContainer.layer.shadowRadius = 2.0;
        menuContainer.layer.shadowColor = UIColor.black.cgColor;
        menuContainer.layer.shadowOffset = CGSize(width: 0.7, height: 0.7);
        menuContainer.layer.shadowOpacity = 0.5;
        menuContainer.isHidden = true;
        
        let subScreen = menuContainer.bounds;
        let logOutBtn = UIButton(type: .system);
        logOutBtn.frame = CGRect(x: subScreen.minX + 4, y:0, width: subScreen.width * (0.90), height: screenSize.height * (0.04));
        logOutBtn.setTitle("Cerrar Sesión", for: .normal);
        logOutBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 16);
        logOutBtn.setTitleColor(UIColor.black, for: .normal);
        logOutBtn.backgroundColor = UIColor.white;
        logOutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside);
        
        menuContainer.frame.size = CGSize(width: menuContainer.frame.width, height: logOutBtn.frame.height);
        menuContainer.addSubview(logOutBtn);
        
        view.addSubview(menuContainer);
    }
    
    //Obtiene la informacion del usuraio a partir de su numero de ID
    private func obtInfoUser(){
        print(UserDefaults.standard.integer(forKey: "userId"));
        
        let url = "http://18.221.106.92/api/public/user/" + (user_id);
        guard let urlInfo = URL(string: url) else{ print("ERROR en URL"); return};
        
        var request = URLRequest(url: urlInfo);
        request.httpMethod = "GET";
        request.addValue("application/json", forHTTPHeaderField: "Contenet-Type");
        
        let session = URLSession.shared;
        
        session.dataTask(with: request){(data,response,error) in
            if(error == nil){
                if let data = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! [String:Any?];
                        
                        //let dataImg: NSData? = Utilities.traerImagen(urlImagen: Utilities.sinFoto);
                        
                        self.colocarInfo(json,data: Utilities.traerImagen(urlImagen: ""));
                    }catch{
                        print(error);
                    }
                };
            }
        }.resume();
        
        
    }
    
    
    //Coloca la información del usuario en los TextFields
    private func colocarInfo(_ json:[String:Any?],data: UIImage!){
        OperationQueue.main.addOperation {
            self.txFlEmailUser.text = json["email"] as? String;
            self.txFlNameUser.text = json["name"] as? String;
            self.txFlPApellidoUser.text = json["apellidoPaterno"] as? String;
            self.txFlSApellidoUser.text = json["apellidoMaterno"] as? String;
            self.txFlEstadoUser.text = json["estado"] as? String;
            self.txFlTelUser.text = json["tel"] as? String;
            self.txFlFacebookUser.text = json["facebook"] as? String;
            self.txFlGoogleUser.text = json["google"] as? String;
            self.txFlFechaNacUser.text = json["fecha_nacimiento"] as? String;
            self.txFlDirUser.text = json["direccion"] as? String;
            self.txFlRFCUser.text = json["rfc"] as? String;
            self.imgUser.image = data;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cuentaBtn.setBackgroundImage(UIImage(named: "cuenta.png"), for: .normal);
        cuentaBtn.removeGestureRecognizer(tapGesture);
        super.viewWillDisappear(animated);
    }
    
    private func disable_EnableAllSub(principal: UIView!){
        
        for node in principal.subviews{
            if let sub = node as? UITextField {
                if(node.tag != 5){
                    sub.isEnabled = !sub.isEnabled;
                }
            }
        }
    }
    
    @objc func menuTapped(tapGestureRecognizer: UITapGestureRecognizer){
        menuContainer.isHidden = !menuContainer.isHidden
    }
    
    @objc func logOut(){
        UserDefaults.standard.removeObject(forKey: "usuario");
        UserDefaults.standard.removeObject(forKey: "contraseña");
        UserDefaults.standard.removeObject(forKey: "userId");
        navBarStyleCase = 0;
        navigationController?.navigationBar.isHidden = true;
        performSegue(withIdentifier: "infoToLogin", sender: nil)
    }
    
    @objc func EnableEdit(){
        btGuardar.isHidden = false;
        fltBtn.isHidden = true;
        disable_EnableAllSub(principal: scVwDatosUser);
        
        let alert = UIAlertController(title: "Aviso", message: "Ahora puede editar su perfil", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert,animated:true,completion:nil);
        
    }
    
    
}
