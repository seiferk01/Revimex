//
//  SubirPropiedadViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 06/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class SubirPropiedadViewController: UIViewController{
    
    @IBOutlet weak var cnVwFormularios: UIView!
    
    @IBOutlet weak var btnSig: UIButton!
    @IBOutlet weak var btnAnt: UIButton!
    
    var detallesInmueble: UIViewController!;
    var ubicacionInmueble: UIViewController!;
    var fotosInmueble: UIViewController!;
    
    var views:[UIViewController?]!;
    
    var cont: Int!;
    
    private var actualViewController: UIViewController?{
        didSet{
            removeInactiveViewController(inactiveViewController: oldValue);
            updateActiveViewController();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cont = 0;
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        
        detallesInmueble = storyboard.instantiateViewController(withIdentifier: "DetallesInmueble");
        ubicacionInmueble = storyboard.instantiateViewController(withIdentifier: "UbicacionInmueble");
        fotosInmueble = storyboard.instantiateViewController(withIdentifier: "FotosInmueble");
        
        views = [detallesInmueble,ubicacionInmueble,fotosInmueble];
        
        
        
        btnSig = Utilities.genearSombras(btnSig);
        btnSig.titleLabel?.font = UIFont.fontAwesome(ofSize: 38);
        btnSig.setTitle(String.fontAwesomeIcon(name: .chevronRight), for: .normal);
        
        btnAnt = Utilities.genearSombras(btnAnt);
        btnAnt.titleLabel?.font = UIFont.fontAwesome(ofSize: 38);
        btnAnt.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal);
        
        
        actualizar();
        
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?){
        if let inactiveVC = inactiveViewController{
            inactiveVC.willMove(toParentViewController: nil);
            inactiveVC.view.removeFromSuperview();
            inactiveVC.removeFromParentViewController();
        }
    }
    
    private func updateActiveViewController(){
        if let activeVC = actualViewController{
            addChildViewController(activeVC);
            activeVC.view.frame = cnVwFormularios.bounds;
            cnVwFormularios.addSubview(activeVC.view);
            activeVC.didMove(toParentViewController: self);
        }
    }
    
    private func actualizar(){
        if(cont == 0){
            btnAnt.isEnabled = false;
        }else{
            btnAnt.isEnabled = true;
        }
        if(cont == 2){
            btnSig.isEnabled = false;
        }else{
            btnSig.isEnabled = true;
        }
        actualViewController = views[cont];
    }
    
    @IBAction func actSig(_ sender: UIButton) {
        if(cont<3){
            cont = cont + 1;
            actualizar();
        }
    }
    
    @IBAction func actAnt(_ sender: UIButton) {
        if(cont>0){
            cont = cont - 1;
            actualizar();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
