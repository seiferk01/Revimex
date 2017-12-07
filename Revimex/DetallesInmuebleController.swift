//
//  DetallesInmuebleController.swift
//  Revimex
//
//  Created by Maquina 53 on 06/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Eureka

class DetallesInmuebleController: FormViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< TextRow(){ row in
                row.placeholder = "aqui va algo"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
