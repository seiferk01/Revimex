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


class Utilities: NSObject {
    
    static let sinFoto = "http://revimex.mx/images/250x160.png"

    //recibe una url en tipo string, la procesa y la regresa como nsdata
    static func traerImagen(urlImagen: String) -> NSData{
        
        var imgURL = NSURL(string: urlImagen)
        print(imgURL)
        if imgURL == nil{
            imgURL = NSURL(string: sinFoto)
        }
        
        var data = NSData(contentsOf: (imgURL as? URL)!)
        if data == nil {
            imgURL = NSURL(string: sinFoto)
            data = NSData(contentsOf: (imgURL as? URL)!)
        }
        
        return data!
    }
    
    
    
}
