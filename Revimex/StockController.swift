//
//  StockController.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Darwin


class StockController: UIViewController,UITableViewDataSource {
    
    //referencia a tabla en la vista
    @IBOutlet weak var tableView: UITableView!
    
    //variables para la siguiente url de cada pagina
    var paginaSiguiente: String = "http://18.221.106.92/api/public/propiedades/lista"
    var haySiguiente: Bool = true
    
    //arreglo para guardar los datos del json
    var arregloOfertas = [Oferta]()
    
    //variable para indicador "loading"
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //objeto para guardar los datos del json de lista
    class Oferta {
        var estado: String
        var precio: String
        var foto: UIImage
        var id: String
        
        init(id: String,estado: String, precio: String, foto: UIImage ){
            self.id = id
            self.estado = estado
            self.precio = precio
            self.foto = foto
        }
    }
    
    //funcion que se ejecuta al cargar la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configuracion de la vista de la barra de navegacion
        navigationController?.navigationBar.isHidden = false
        let navigationBarSize = navigationController?.navigationBar.bounds
        let navigationBarSizeWidth = navigationBarSize?.width
        let navigationBarSizeHeigth = navigationBarSize?.height
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let logo = UIImage(named: "revimex.png")
        let contenedorLogo = UIImageView(image:logo)
        contenedorLogo.frame = CGRect(x: navigationBarSizeWidth!*0.3,y: 0.0,width: navigationBarSizeWidth!*0.4,height: navigationBarSizeHeigth!)
        
        navigationController?.navigationBar.addSubview(contenedorLogo)
        
        //si ya se tiene id de usuario miestra el boton de cuenta, si no el de signin
        if (UserDefaults.standard.object(forKey: "userId") as? Int) != nil{
            let tapGestureRecognizerImgAcct = UITapGestureRecognizer(target: self, action: #selector(imagenCuentaTapped(tapGestureRecognizer:)))
            
            
            let imagenCuenta = UIImage(named: "cuenta.png")
            
            //imagenCuentaBtn.tag = 1;
            imagenCuentaBtn.frame = CGRect(x: navigationBarSizeWidth!-navigationBarSizeHeigth!,y: 0.0,width: navigationBarSizeHeigth!,height: navigationBarSizeHeigth!)
            imagenCuentaBtn.setBackgroundImage(imagenCuenta, for: .normal)
            imagenCuentaBtn.addGestureRecognizer(tapGestureRecognizerImgAcct)
            
            navigationController?.navigationBar.addSubview(imagenCuentaBtn)
        }
        else{
            
            let tapGestureRecognizerSignIn = UITapGestureRecognizer(target: self, action: #selector(incioSesionTapped(tapGestureRecognizer:)))
            
            //incioSesionBtn.tag = 2;
            incioSesionBtn.setTitle("SignIn", for: .normal)
            incioSesionBtn.frame = CGRect(x: navigationBarSizeWidth! - (navigationBarSizeWidth! * (0.2)),y: 0.0,width: navigationBarSizeWidth! * (0.2),height: navigationBarSizeHeigth!)
            incioSesionBtn.layer.masksToBounds = false
            incioSesionBtn.layer.shadowRadius = 1.0
            incioSesionBtn.layer.shadowColor = UIColor.black.cgColor
            incioSesionBtn.layer.shadowOffset = CGSize(width: 0.7,height: 0.7)
            incioSesionBtn.layer.shadowOpacity = 0.5
            incioSesionBtn.addGestureRecognizer(tapGestureRecognizerSignIn)
            navigationController?.navigationBar.addSubview(incioSesionBtn)
        }
        
        
        //llamado a la lista de propiedades
        requestData(url: paginaSiguiente)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //llamado a la lista de propiedades
    func requestData(url: String){
        
        //indicador de loading
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        //variable para guardar el estatus de la llamada
        var mensaje: String = ""
        
        //url para la llamada
        guard let url = URL(string: url) else { return }
        
        //configuracion e incio del request
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        
        let session  = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    if json["mensaje"] != nil {
                        mensaje = json["mensaje"] as! String
                    }
                    
                    print("json de propiedades: ")
                    print(json["propiedades"]!!)
                    
                    if let propiedades = json["propiedades"] as? NSDictionary {
                        
                        if let data = propiedades["data"]! as? NSArray{
                            for propiedad in data {
                                
                                if let atribute = propiedad as? NSDictionary {
                                    
                                    print("************Inicia propiedad************")
                                    print(atribute)
                                    
                                    let oferta: Oferta = Oferta(id: "",estado: "",precio: "",foto: UIImage(named: "imagenNoEncontrada.png")!)
                                    
                                    if let idProp = atribute["idp"] as? Int{
                                        oferta.id = String(idProp)
                                    }
                                    
                                    if let nomEst = atribute["estado"] as? String {
                                        oferta.estado = nomEst
                                    }
                                    
                                    if let pecProp = atribute["precio"] as? String {
                                        oferta.precio = pecProp
                                    }
                                    
                                    if let propImage = atribute["fotoPrincipal"] as? String {
                                        oferta.foto = Utilities.traerImagen(urlImagen: propImage)
                                    }
                                    
                                    self.arregloOfertas.append(oferta)
                                    
                                    if let nextPage = propiedades["next_page_url"] as? String{
                                        self.paginaSiguiente = nextPage
                                        self.haySiguiente = true
                                    }
                                }
                                else{
                                    self.haySiguiente = false
                                }
                            }
                        }
                        else{
                            print("ERROR: Hubo un problema al obtener propiedades[\"data\"] ")
                        }
                    }
                    else{
                        print("ERROR: Hubo un problema al obtener json[\"propiedades\"] ")
                    }
                    
                } catch {
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                    if (mensaje == "success"){
                        self.activityIndicator.stopAnimating()
                    }
                })
                
            }
            }.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(arregloOfertas.count)
        return arregloOfertas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let row = tableView.dequeueReusableCell(withIdentifier: "row") as! TableViewCell
        row.idOfertaActual = arregloOfertas[indexPath.row].id
        row.estado.textColor = UIColor.white
        row.precio.textColor = UIColor.white
        row.estado.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        row.precio.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        row.estado.text = arregloOfertas[indexPath.row].estado
        row.precio.text = "$" + arregloOfertas[indexPath.row].precio
        row.vistaFoto.image = arregloOfertas[indexPath.row].foto
        print(indexPath.row)
        
        if arregloOfertas.count == (indexPath.row + 1){
            if haySiguiente {
                requestData(url: paginaSiguiente)
            }
        }
        
        return row
    }
    
    
    @objc func incioSesionTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //oculta la barra de navegacion del login
        navBarStyleCase = 1
        performSegue(withIdentifier: "stockToLogin", sender: nil)
    }
    
    @objc func imagenCuentaTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "stockToInfo", sender: nil)
        /*UserDefaults.standard.removeObject(forKey: "usuario")
         UserDefaults.standard.removeObject(forKey: "contraseña")
         UserDefaults.standard.removeObject(forKey: "userId")
         navBarStyleCase = 0
         navigationController?.navigationBar.isHidden = true*/
    }
    
    
}
