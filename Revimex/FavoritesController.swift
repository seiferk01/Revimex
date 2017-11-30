//
//  FavoritesController.swift
//  Revimex
//
//  Created by Seifer on 17/11/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class FavoritesController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let top = (navigationController?.navigationBar.bounds.height)!+20
        let misFavoritos = UIButton()
        misFavoritos.frame = CGRect(x: 0, y: top, width: view.bounds.width/2, height: view.bounds.height * (0.07))
        misFavoritos.backgroundColor = gris
        misFavoritos.setTitle("Mis Favoritos", for: .normal)
        misFavoritos.setTitleColor(UIColor.white, for: .normal)
        misFavoritos.layer.borderWidth = 1
        misFavoritos.layer.borderColor = UIColor.white.cgColor
        
        let sugerencias = UIButton()
        sugerencias.frame = CGRect(x: view.bounds.width/2, y: top, width: view.bounds.width/2, height: view.bounds.height * (0.07))
        sugerencias.backgroundColor = gris
        sugerencias.setTitle("Sugerencias", for: .normal)
        sugerencias.setTitleColor(UIColor.white, for: .normal)
        sugerencias.layer.borderWidth = 1
        sugerencias.layer.borderColor = UIColor.white.cgColor
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            msotrarFavoritos(userId: userId)
        }
        else{
            solicitarRegistro()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func msotrarFavoritos(userId: Int){
        
        let urlFvoritos =  "http://18.221.106.92/api/public/favorites/" + String(userId)
        
        guard let url = URL(string: urlFvoritos) else { return }
        
        let session  = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("response:")
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data)
                    
                    for element in json as! NSArray {
                        print("************Empieza Favorito************")
                        if let favorito = element as? NSDictionary{
                            print(favorito["idPropiedad"] as! Int)
                        }
                    }
                    
                    //let results = json["results"] as! NSObject
                
                    
                }catch {
                    print(error)
                }
                
            }
        }.resume()
    }
    
    
    func solicitarRegistro(){
        let contenedorInfo = UIView()
        contenedorInfo.frame = CGRect(x: view.bounds.width * (0.1), y: view.bounds.height * (0.2), width: view.bounds.width * (0.8), height: view.bounds.height * (0.8))
        
        let image = UIImage(named: "favoritosSinLogin.png")
        let notLoggedMessage = UIImageView(image: image)
        notLoggedMessage.frame = CGRect(x: 0, y: 0, width: contenedorInfo.bounds.width, height: contenedorInfo.bounds.height)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mostrarLogin(tapGestureRecognizer:)))
        let loginBtn = UIButton()
        loginBtn.frame = CGRect(x: view.bounds.width * (0.15), y: view.bounds.height * (0.8), width: view.bounds.width * (0.7), height: view.bounds.height * (0.06))
        loginBtn.backgroundColor = gris
        loginBtn.setTitle("Registrarse", for: .normal)
        loginBtn.addGestureRecognizer(tapGestureRecognizer)
        
        contenedorInfo.addSubview(notLoggedMessage)
        view.addSubview(contenedorInfo)
        view.addSubview(loginBtn)
    }
    
    
    @objc func mostrarLogin(tapGestureRecognizer: UITapGestureRecognizer){
        print("fue a login")
        navBarStyleCase = 2
        performSegue(withIdentifier: "favoritesToLogin", sender: nil)
    }

}
