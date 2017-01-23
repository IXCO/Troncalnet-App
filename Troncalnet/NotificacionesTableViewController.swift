//
//  NotificacionesTableViewController.swift
//  Troncalnet
//
//  Created by Ana Arellano on 10/2/15.
//  Copyright © 2015 IXCO. All rights reserved.
//

import UIKit

class NotificacionesTableViewController: UITableViewController {

    var user:Usuario!
    var fechas = [String]()
    var estilos = [String]()
    var placas = [String]()
    @IBOutlet weak var progreso: UIActivityIndicatorView!
    
    var notificaciones: Dictionary<String,Dictionary<String,Dictionary<String,String>>>!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        cargarNotificaciones()
        
        //Ajusta la celda y cambia colores de separadores
        tableView.tableFooterView = UIView(frame:CGRect.zero)
        tableView.separatorColor=UIColor(red: 0, green: (112.0/255.0), blue: (51.0/255.0), alpha: 1.0)

    }
    func cargarNotificaciones(){
        progreso.startAnimating()
        var connection:Bool=false
        let urlBase=Direccion()
        let urlPath = urlBase.direccion+"notificaciones.php?idu="+self.user.IdCliente
        let url = URL(string: urlPath)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {data, response, error -> Void in
            if(error == nil) {
                //Revisa por posibles errores de respuesta
                var jsonResult : Any
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: (data)!, options: JSONSerialization.ReadingOptions.mutableContainers)
                }catch {

                    fatalError()
                }
                //Mapea el JSON a un diccionario
                if let _ = jsonResult as? NSDictionary   {
                    
                    self.notificaciones = jsonResult as? Dictionary
                }
                connection = true
            }
            DispatchQueue.main.async(execute: {
                //Crea un diccionario para la estructura de una notificacion
                var notificacion :Dictionary<String,String>
                if(connection == true){
                    //Por cada resultado dentro del JSON se crea una estructura tipo
                    // Notificacion[ Fecha , Tipo]
                    
                    var contador=1
                    for (_,_) in self.notificaciones{
                        //Sirve para enviar la informaciòn en orden
                        let value = self.notificaciones[String(contador)]!
                        for valor in value.values{
                            notificacion = valor as Dictionary
                            //Enviar a arreglos para facilidad de uso
                            
                            self.fechas.append(notificacion["fecha"] as String!)
                            self.estilos.append(notificacion["tipo"] as String!)
                            self.placas.append(notificacion["placas"] as String!)
                            
                            
                        }
                        contador += 1
                    }
                    //Carga un dato vacio al ultimo para que no cubra toda la pantalla
                    self.fechas.append(" ")
                    self.estilos.append(" ")
                    self.placas.append(" ")
                   
                    //Recarga los datos de la tabla con los autos encontrado
                    self.tableView.reloadData()
                }else {
                    //Si no hay conexión avisa al usuario para que vuelva a intentar
                    let alertController = UIAlertController(title: "Error", message:
                        "No se pudo conectar. Vuelva a intentar en unos minutos o revise su conexión a internet.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                self.progreso.stopAnimating()
            })
            
        })
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fechas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)

        let fecha = self.fechas[indexPath.row]
        let estilo = "Tipo de evento: " + self.estilos[indexPath.row]
        let placas = "Placas: "+self.placas[indexPath.row]
        cell.textLabel?.text=fecha
        
        cell.textLabel?.textColor=UIColor(red: 0, green: (112.0/255.0), blue: (51.0/255.0), alpha: 1.0)
        cell.detailTextLabel?.text = estilo+" "+placas
        cell.backgroundColor=UIColor.white


        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
