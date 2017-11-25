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
        var urlImagen: NSData?
        var id: String
        
        init(id: String,estado: String, precio: String, urlImagen: NSData?){
            self.id = id
            self.estado = estado
            self.precio = precio
            self.urlImagen = urlImagen
        }
    }
    
    //funcion que se ejecuta al cargar la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configuracion de la vista de la barra de navegacion
        let navigationBarSize = navigationController?.navigationBar.bounds
        let navigationBarSizeWidth = navigationBarSize?.width
        let navigationBarSizeHeigth = navigationBarSize?.height

        navigationController?.navigationBar.barTintColor = azul
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let logo = UIImage(named: "revimex.png")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: navigationBarSizeWidth!*0.3,y: 0.0,width: navigationBarSizeWidth!*0.4,height: navigationBarSizeHeigth!)
        
        navigationController?.navigationBar.addSubview(imageView)
        
        var logged = false
        if let loggedIn = UserDefaults.standard.object(forKey: "loggedIn") as? Bool{
            logged = loggedIn
        }
        
        if logged {
            let cuenta = UIImage(named: "cuenta.png")
            let imageCuenta = UIImageView(image:cuenta)
            imageCuenta.frame = CGRect(x: navigationBarSizeWidth!-navigationBarSizeHeigth!,y: 0.0,width: navigationBarSizeHeigth!,height: navigationBarSizeHeigth!)
            imageCuenta.layer.masksToBounds = false
            imageCuenta.layer.shadowRadius = 1.0
            imageCuenta.layer.shadowColor = UIColor.black.cgColor
            imageCuenta.layer.shadowOffset = CGSize(width: 0.7,height: 0.7)
            imageCuenta.layer.shadowOpacity = 0.5
            navigationController?.navigationBar.addSubview(imageCuenta)
        }
        else{
            
            let tapGestureRecognizerFilter = UITapGestureRecognizer(target: self, action: #selector(incioSesionTapped(tapGestureRecognizer:)))
            
            incioSesionBtn.setTitle("SignIn", for: .normal)
            incioSesionBtn.frame = CGRect(x: navigationBarSizeWidth! - (navigationBarSizeWidth! * (0.2)),y: 0.0,width: navigationBarSizeWidth! * (0.2),height: navigationBarSizeHeigth!)
            incioSesionBtn.layer.masksToBounds = false
            incioSesionBtn.layer.shadowRadius = 1.0
            incioSesionBtn.layer.shadowColor = UIColor.black.cgColor
            incioSesionBtn.layer.shadowOffset = CGSize(width: 0.7,height: 0.7)
            incioSesionBtn.layer.shadowOpacity = 0.5
            incioSesionBtn.addGestureRecognizer(tapGestureRecognizerFilter)
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
                    print(json["propiedades"])
                    
                    let propiedades = json["propiedades"] as! NSDictionary
                    
                    for propiedad in propiedades["data"] as! NSArray{
                        let atribute = propiedad as! NSDictionary
                        print("************Inicia propiedad************")
                        print(atribute)
                        
                        var idPropiedad = ""
                        if atribute["idp"] != nil{
                            idPropiedad = String(atribute["idp"] as! Int)
                        }
                        
                        var nombreEstado = ""
                        if atribute["estado"] != nil {
                            nombreEstado = atribute["estado"] as! String
                        }
                        
                        var precioPropiedad = ""
                        if atribute["precio"] != nil {
                            precioPropiedad = atribute["precio"] as! String
                        }
                        
                        var urlImagen: String = Utilities.sinFoto
                        
                        if !(atribute["fotoPrincipal"] is NSNull) {
                            urlImagen = (atribute["fotoPrincipal"] as! String)
                        }
                        
                        var data: NSData? = nil
                        while data == nil {
                            data = Utilities.traerImagen(urlImagen: urlImagen)
                            urlImagen = "http://revimex.mx/images/250x160.png"
                        }
                        
                        let oferta: Oferta = Oferta(id: idPropiedad,estado: nombreEstado,precio: precioPropiedad,urlImagen: data)
                        
                        self.arregloOfertas.append(oferta)
                        
                        print(self.arregloOfertas.count)
                        if !(propiedades["next_page_url"] is NSNull){
                            self.paginaSiguiente = propiedades["next_page_url"] as! String
                            self.haySiguiente = true
                        }
                        else{
                            self.haySiguiente = false
                        }
                        
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
        row.vistaFoto.image = UIImage(data: arregloOfertas[indexPath.row].urlImagen! as Data)
        print(indexPath.row)
        
        if arregloOfertas.count == (indexPath.row + 1){
            if haySiguiente {
                requestData(url: paginaSiguiente)
            }
            print(arregloOfertas.count % (indexPath.row + 1))
            print(arregloOfertas.count)
        }
        
        return row
    }
    
    @objc func incioSesionTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToLogin", sender: nil)
        isAlreadyIn = true
    }
    
    
}
