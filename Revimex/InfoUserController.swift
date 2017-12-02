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
    
    private var user_id : String!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard();
        self.navigationController?.isNavigationBarHidden = false;
        
        user_id = UserDefaults.standard.string(forKey: "userId")!;
        
        print(scVwDatosUser.contentSize.height);
        print(txFlRFCUser.frame.height);
        
        scVwDatosUser.isScrollEnabled = true;
        scVwDatosUser.contentSize =    CGSize(width: scVwDatosUser.contentSize.width,height: (txFlDirUser.frame.height+10)*13);
        
        print(scVwDatosUser.contentSize.height);
        
        txFlEmailUser.placeholder = "Email" ;
        txFlEmailUser.keyboardType = UIKeyboardType.emailAddress;
        
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
        
        obtInfoUser();
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func actionGuardar(_ sender: Any) {
        if(Utilities.isValidEmail(testStr: txFlEmailUser.text!)){
            self.setInfoUser();
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
            print(response);
            print(error);
            if(error == nil){
                
                if let data = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! [String:Any?];
                        print(json);
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
                        self.colocarInfo(json);
                    }catch{
                        print(error);
                    }
                };
            }
            }.resume();
        
        
    }
    
    
    //Coloca la información del usuario en los TextFields
    private func colocarInfo(_ json:[String:Any?]){
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
        }
    }
    
}
