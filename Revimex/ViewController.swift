//
//  ViewController.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

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
var gris = UIColor(hexString: "#E5E5E5ff")

var isAlreadyIn = false

class ViewController: UIViewController {
    
    
    @IBOutlet weak var textoRegistro: UITextView!
    @IBOutlet weak var textoInvitado: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textoRegistro.isEditable = false
        textoInvitado.isEditable = false
        
        
        let screenSize = UIScreen.main.bounds
        
        let navBar: UINavigationBar = UINavigationBar()
        navBar.frame = CGRect(x: 0.0,y: 0.0,width: screenSize.width,height: screenSize.height/5)  // Here you can set you Width and Height for your navBar
        navBar.backgroundColor = azul
        
        let logo = UIImage(named: "revimex.png")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: screenSize.width/4,y: screenSize.height/12,width: screenSize.width/2,height: screenSize.height/12)
        
        view.addSubview(navBar)
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.addSubview(imageView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func crearCuentaTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isFirstTime")
    }
    
    @IBAction func invitadoTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isFirstTime")
        isAlreadyIn = true
    }
    
    
}

