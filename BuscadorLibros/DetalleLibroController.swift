//
//  DetalleLibroController.swift
//  BuscadorLibros
//
//  Created by Jose Duin on 1/30/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import UIKit

class DetalleLibroController: UIViewController {

    @IBOutlet weak var autores: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    //Libro seleccionado
    var libro: Libro = Libro()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(red:205/255.0, green: 0/255.0, blue: 15/255.0, alpha: 1)
        self.title = libro.titulo
        self.autores.text = libro.autores 
        
        if (libro.portada.isEmpty) {
            self.portada.image = UIImage(named: "placeholder")
        } else {
            let urlDelLibro = NSURL(string: libro.portada)
            self.portada.image = UIImage(data: NSData(contentsOf: urlDelLibro! as URL)! as Data)!
        }
        
    }
    

}
