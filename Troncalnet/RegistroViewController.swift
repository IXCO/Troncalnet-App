    //
//  RegistroViewController.swift
//  Troncalnet
//
//  Created by Ana Arellano on 04/02/15.
//  Copyright (c) 2015 IXCO. All rights reserved.
//

import UIKit

class RegistroViewController: UITableViewController {
    
    
    @IBOutlet weak var progreso: UIActivityIndicatorView!
   
    @IBOutlet weak var segment: UISegmentedControl!
    var user:Usuario!
    var autoid :Auto!
    var latitude = [String]()
    var longitude = [String]()
    var fechas = [String]()
    var fechasAux = [String]()
    var tipos = [String]()
    var latEnvia = [String]()
    var longEnvia = [String]()
    var latitud:String!
    var longitud:String!
    var registro:Dictionary<String,Dictionary<String,Dictionary<String,String>>>!
    var direccion:Array<String>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a
        
        progreso.startAnimating()
        self.cargarEventos()
        
 
        tableView.tableFooterView = UIView(frame:CGRect.zero)
        tableView.separatorColor=UIColor(red: 0, green: (112.0/255.0), blue: (51.0/255.0), alpha: 1.0)
    }
    @IBAction func regresarRegistro(_ segue: UIStoryboardSegue){
        
    }
    @IBAction func indexChange(_ sender: AnyObject) {
        progreso.startAnimating()
        self.cargarEventos()
    }
    
    @IBOutlet weak var rango: UILabel!
    func cargarEventos(){
        let urlBase=Direccion()
        let urlPath = urlBase.direccion+"historial.php?idu="+String(self.autoid.id)+"&d="+self.rango.text!

        
        var _ : String? = nil
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
                if (jsonResult as? NSDictionary != nil)   {
                    //obtiene resultado
                    self.registro = jsonResult as? Dictionary
                }
                
            }
           
            DispatchQueue.main.async(execute: {
                //Limpia los arreglos
                self.fechas.removeAll()
                self.latitude.removeAll()
                self.longitude.removeAll()
                self.tipos.removeAll()
                var coordenada :Dictionary<String,String>
                //Si esta solo no crea nada
                if self.registro == nil{
                    
                }else{
                    var contador=1
                    for (_,_) in self.registro{
                        //Sirve para enviar la informaciòn en orden
                        let value = self.registro[String(contador)]!
                        for valor in value.values{
                            coordenada = valor as Dictionary
                            //Checa si la sección que esta solicitando es de eventos o viajes
                            if(self.segment.selectedSegmentIndex == 1){
                                let tipoDeEvento = coordenada["tipo"] as String!
                                //Genera un viaje apartir de un encendido hasta un apagado
                                if(tipoDeEvento == "ENCENDIDO"){
                                    self.fechas.append(coordenada["fecha"] as String!)
                                    self.latitude.append(coordenada["latitude"] as String!)
                                    self.longitude.append(coordenada["longitude"] as String!)
                                }else if(tipoDeEvento == "Apagado"){
                                    self.fechasAux.append(coordenada["fecha"] as String!)
                                    self.latitude.append(coordenada["latitude"] as String!)
                                    self.longitude.append(coordenada["longitude"] as String!)
                                }
                            }else{
                                //Enviar a arreglos para facilidad de uso
                                self.fechas.append(coordenada["fecha"] as String!)
                                self.latitude.append(coordenada["latitude"] as String!)
                                self.longitude.append(coordenada["longitude"] as String!)
                                self.tipos.append(coordenada["tipo"] as String!)
                            }
                            
                        }
                        contador += 1
                    }
                    
                    
                    //Recarga los datos de la tabla con los autos encontrado
                    self.tableView.reloadData()}
                //Detiene la animación de progreso
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Return the number of rows in the section.
        if fechas.isEmpty {
            return 0
        }else{
            return self.fechas.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var texto=""
        var info=""
        //Detecta si esta en sección de viajes o eventos
        if(self.segment.selectedSegmentIndex == 1){
            texto = "Viaje "+String(indexPath.row+1)
            info = "De: "+self.fechas[indexPath.row]+" a: "+self.fechasAux[indexPath.row]
        }else{
            texto = self.fechas[indexPath.row]+" "+self.tipos[indexPath.row]
            info = " Latitud: "+self.latitude[indexPath.row]+" Longitud: "+self.longitude[indexPath.row]
        }
        cell.textLabel?.text=texto
        cell.detailTextLabel?.text=info
        cell.textLabel?.textColor=UIColor(red: 0, green: (112.0/255.0), blue: (51.0/255.0), alpha: 1.0)
        cell.detailTextLabel?.textColor=UIColor(red: 0, green: (112.0/255.0), blue: (51.0/255.0), alpha: 1.0)
        cell.backgroundColor=UIColor.white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Detecta si esta en sección de viajes o eventos
        if(self.segment.selectedSegmentIndex == 1){
            self.latEnvia.removeAll()
            self.longEnvia.removeAll()
            self.longEnvia.append(self.longitude[(indexPath.row*2)])
            self.longEnvia.append(self.longitude[(indexPath.row*2)+1])
            self.latEnvia.append(self.latitude[(indexPath.row*2)])
            self.latEnvia.append(self.latitude[(indexPath.row*2)+1])
            
        }else{
            self.latitud = self.latitude[indexPath.row]
            self.longitud=self.longitude[indexPath.row]
        }
        self.performSegue(withIdentifier: "ver", sender: self)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
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
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        if (segue.identifier == "ver") {
        let controladorMapa = segue.destination as! MapaRegistroViewController
            if(self.segment.selectedSegmentIndex == 1){
                controladorMapa.latitudes = self.latEnvia
                controladorMapa.longitudes = self.longEnvia
            }else{
                controladorMapa.longitude=self.longitud as NSString!
                controladorMapa.latitude=self.latitud as NSString!
            }
        }else if(segue.identifier == "mas"){
            let controladorHistorial = segue.destination as! HistorialViewController
            controladorHistorial.vehiculo = self.autoid
        }
    }
    

    
}
