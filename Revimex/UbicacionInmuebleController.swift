//
//  UbicacionInmuebleController.swift
//  Revimex
//
//  Created by Maquina 53 on 07/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Eureka

class UbicacionInmuebleController: FormViewController {
    
    public var codeZip:ZipCodeRow!;
    public var edo: ActionSheetRow<String>!;
    public var mun: ActionSheetRow<String>!;
    public var col:ActionSheetRow<String>!;
    public var calle:TextRow!;
    public var numExt:IntRow!;
    public var mnz:TextRow!;
    public var lote:TextRow!;
    public var tipoCalle:ActionSheetRow<String>!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeZip = ZipCodeRow(){ row in
            row.title = "Código Postal";
            row.value = "";
            row.tag = "code_zip";
        };
        
        edo = ActionSheetRow<String>(){row in
            row.title = "Estado";
            row.value = "";
            row.tag = "edo";
        };
        
        mun = ActionSheetRow<String>(){row in
            row.title = "Municipio";
            row.value = "";
            row.tag = "mun"
        };
        
        col = ActionSheetRow<String>{row in
            row.title = "Colonia";
            row.value = "";
            row.tag = "col";
        }
        
        calle = TextRow(){ row in
            row.title = "Calle";
            row.value = "...";
            row.tag = "calle";
        }
        
        numExt = IntRow(){row in
            row.title = "Número Exterior";
            row.tag = "numExt";
        }
        
        mnz = TextRow(){row in
            row.title = "Manzana";
            row.value = "...";
            row.tag = "mnz";
        }
        
        lote = TextRow(){row in
            row.title = "Lote";
            row.value = "...";
            row.tag = "lote";
        }
        
        tipoCalle = ActionSheetRow<String>(){row in
            row.title = "Tipo de Calle";
            row.value = "";
            row.tag = "tipoCalle";
        }
        
        form+++Section("Ubicacion de su Inmueble")<<<codeZip<<<edo<<<mun<<<col<<<calle<<<numExt<<<mnz<<<lote<<<tipoCalle;
        events();
    }
    
    private func events(){
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
