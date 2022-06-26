//
//  ViewController.swift
//  TableViews
//
//  Created by Brais Moure.
//  Copyright © 2020 MoureDev. All rights reserved.
//

import UIKit
//1.- Importar librería Core Data
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //2.- Referencia al managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //3.- Cambiar a variable de tipo pais sin datos iniciales
    private var myCountries:[Pais]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        //4.- Recuperar datos
        
        recuperarDatos()

    }

    @IBAction func add(_ sender: Any) {
        
        //Crear alerta
        let alert = UIAlertController(title: "Agregar País", message: "Añade un país nuevo", preferredStyle: .alert)
        
        alert.addTextField()
        
        //Crear y configurar botón de alerta
        let botonAlerta = UIAlertAction(title: "Añadir", style: .default) {
            (action) in
            
            //Recuperar textField de la alerta
            let textField = alert.textFields![0]
            
            //Crear objeto Pais
            let nuevoPais = Pais(context: self.context)
            nuevoPais.nombre = textField.text
            
            //Guardar información (Añade do try catch)
            try! self.context.save()
            
            //Refrescar información en tableview
            self.recuperarDatos()
        }
        //Añadir botón a la alerta y mostrar alerta
        alert.addAction(botonAlerta)
        self.present(alert, animated: true, completion: nil)
    }
    
    func recuperarDatos(){
        do{
            self.myCountries = try context.fetch(Pais.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print("Error recuperando datos")
        }
    }
    
}




// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //5
        return myCountries!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
            if cell == nil {
               
                cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
                
            }
        cell!.textLabel?.text = myCountries![indexPath.row].nombre
            return cell!
      
            
       
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //5 print(myCountries![indexPath.row])
        
        //7.- Añadir funcionalidad de editar
        
        //Cuál país se editará?
        let paisEditar = self.myCountries![indexPath.row]
        
        //Crear alerta
        let alert = UIAlertController(title: "Editar País", message: "Edita el país", preferredStyle: .alert)
        alert.addTextField()
        
        //Recuperar nombre del país actual de la tabla y agregarla al textField
        let textField = alert.textFields![0]
        
        textField.text = paisEditar.nombre
        
        //Crear y configurar botón de alerta
        let botonAlerta = UIAlertAction(title: "Editar", style: .default){
            (action) in
            
            //Recuperar textField de la alerta
            let textField = alert.textFields![0]
            
            //Editar pais actual con lo que esté en el textfield
            
            paisEditar.nombre = textField.text
            
            //Guardar información (Añade block do-try-catch)
            try! self.context.save()
            
            //Refrescar información en tableview
            self.recuperarDatos()
        }
        
        //Añadir botón a la alerta y mostrar la alerta
        alert.addAction(botonAlerta)
        self.present(alert, animated: true, completion: nil)
    }
    
    //6.- Añadir funcionalidad de swipe para eliminar
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Crear acción de eliminar
        let accionEliminar = UIContextualAction(style: .destructive, title: "Eliminar") {
            (action, view, completionHandler) in
            //Cuál país se eliminará?
            let paisEliminar = self.myCountries![indexPath.row]
            
            //Eliminar país
            self.context.delete(paisEliminar)
            
            //Guardar el cambio de información
            try! self.context.save()
            
            //Recargar datos
            self.recuperarDatos()
        }
        
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
    
}

