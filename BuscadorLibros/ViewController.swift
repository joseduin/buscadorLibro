//
//  ViewController.swift
//  BuscadorLibros
//
//  Created by Jose Duin on 1/30/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 0451526538 - the aventures of Tom Sawyer
    // 0201558025 - concrete mathematics
    // 0385472579 - Zen speaks
    // 9780980200447 - Slow reading

    @IBOutlet weak var titulos: UITableView!
    @IBOutlet weak var searchText: UITextField!
    
    let url_path: String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
 
    
    // titulos
    var listado_titulos: [Libro] = [Libro]()
    
    //Libro seleccionado
    var libro: Libro = Libro()
    
    @IBAction func addTitulo(_ sender: Any) {
        search()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red:205/255.0, green: 0/255.0, blue: 15/255.0, alpha: 1)
        titulos.delegate = self
        titulos.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listado_titulos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TituloTableViewCell") as! TituloTableViewCell
        let item = listado_titulos[indexPath.row]
        cell.titulo.text = item.titulo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.libro = listado_titulos[indexPath.row]
        self.performSegue(withIdentifier: "DetalleLibroController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetalleLibroController" {
            
            if let viewController = segue.destination as? DetalleLibroController {
                viewController.libro = self.libro
                
            }
        }
    }


    func search() {
        if (searchText.text?.isEmpty)! {
            message(message: "Por favor, introduzca el ISBN del libro a buscar")
            return
        }
        
        // Asincrono
        let urls = "\(self.url_path)\(searchText.text!)"
        let url = URL(string: urls)
        let sesion = URLSession.shared
        let bloque = { (datos: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.sync {
                if response != nil {
                    let texto: String = String(data: datos!, encoding: String.Encoding.utf8)!
                    if (texto == "{}") {
                        self.message(message: "Sin referencas")
                    } else {
                        self.loadData(data: datos!)
                    }
                } else {
                    self.message(message: "problemas con Internet)")
                }
            }
        }
        
        let dt = sesion.dataTask(with: url!, completionHandler: bloque)
        dt.resume()
    }
    
    func loadData(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            let dic0 = json as! NSDictionary
            let dic1 = dic0["ISBN:\(searchText.text!)"] as! NSDictionary
            let titulo_pass = dic1["title"] as! NSString as String
            
            var nombreAutores = ""
            var autores_pass = ""
            var i = 0
            if let listaAutores = dic1["authors"] as? NSArray {
                for autor in listaAutores {
                    let dicAutor = autor as! Dictionary<String,String>
                    if (i == 0) {
                        nombreAutores += "\(dicAutor["name"]!)"
                    } else {
                        nombreAutores += "\n \(dicAutor["name"]!)"
                    }
                    i = i + 1
                }
                autores_pass = "\(i == 1 ? "Autor: " : "Autores: ")\(nombreAutores)"
            }
            
            var urlImagen = ""
            if dic1["cover"] != nil {
                
                let imgSize = dic1["cover"] as! NSDictionary
                
                
                if (imgSize["medium"] != nil) {
                    urlImagen = (imgSize["medium"] as! NSString) as String
                } else if (imgSize["small"] != nil) {
                    urlImagen = (imgSize["small"] as! NSString) as String
                } else {
                    urlImagen = (imgSize["large"] as! NSString) as String
                }
                
                // Fin de la busqueda, guardamos los datos
                listado_titulos.append(Libro(titulo: titulo_pass, codigo: searchText.text!, autores: autores_pass, portada: urlImagen))
                titulos.reloadData()
                
                //Limpiamos el searchText
                searchText.text = ""
            }
            
        } catch _ {
            
        }
    }
    
    func message(message: String) {
        let alert = UIAlertController(title: "Open Library", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

class Libro {
    var titulo: String
    var codigo: String
    var autores: String
    var portada: String
    
    init(titulo: String, codigo: String, autores: String, portada: String) {
        self.titulo = titulo
        self.codigo = codigo
        self.autores = autores
        self.portada = portada
    }
    
    convenience init() {
        self.init(titulo: "", codigo: "", autores: "", portada: "")
    }
}
