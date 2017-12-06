//
//  PropiedadesController.swift
//  Revimex
//
//  Created by Maquina 53 on 05/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class PropiedadesController: UIViewController {
    
    @IBOutlet weak var sgCtrlPropiedades: UISegmentedControl!
    @IBOutlet weak var cnVwPropiedades: UIView!
    
    var misPropiedades: UIViewController!;
    var misInversiones: UIViewController!;
    
    private var activeViewController: UIViewController?{
        didSet{
            removeInactiveViewController(inactiveViewController: oldValue);
            updateActiveViewController();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        misPropiedades = storyboard.instantiateViewController(withIdentifier: "MisPropiedades");
        misInversiones = storyboard.instantiateViewController(withIdentifier: "MisInversiones");
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?){
        if let inactiveVC = inactiveViewController{
            inactiveVC.willMove(toParentViewController: nil);
            inactiveVC.view.removeFromSuperview();
            inactiveVC.removeFromParentViewController();
        }
    }
    
    private func updateActiveViewController(){
        if let activeVC = activeViewController{
            addChildViewController(activeVC);
            activeVC.view.frame = cnVwPropiedades.bounds;
            cnVwPropiedades.addSubview(activeVC.view);
            activeVC.didMove(toParentViewController: self);
        }
    }
    
    @IBAction func changeContentView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            activeViewController = misPropiedades;
            break;
        case 2:
            activeViewController = misInversiones;
            break;
        default:
            break;
            
        }
    }
    
}
