//
//  Utilities.swift
//  Revimex
//
//  Created by Seifer on 13/11/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}


extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}


var azul = UIColor(hexString: "#48B1F3ff")
var azulClaro = UIColor(hexString: "#F0F5F6ff")
var gris = UIColor(hexString: "#3B3B3Bff")

//variable global, obtiene un valor en TableViewCell.swift dependiendo de la propiedad que se selecciono
var idOfertaSeleccionada = ""

var incioSesionBtn = UIButton()
var imagenCuentaBtn = UIButton()

//indica el tipo de estilo para la barra de navegacion
var withNavBarStyle = true

var navBarStyleCase = 0

class Utilities: NSObject {

    //recibe una url en tipo string, la procesa y la regresa como imagen
    static func traerImagen(urlImagen: String) -> UIImage{
        
        var imagen = UIImage(named: "imagenNoEncontrada.png")
        
        let imgURL = NSURL(string: urlImagen)
        
        if let data = NSData(contentsOf: (imgURL as URL?)!){
            imagen = UIImage(data: data as Data)
        }
        
        return imagen!
    }
    
    //recibe una cadena de texto y regresa true si es un correo valido
    static func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
}
