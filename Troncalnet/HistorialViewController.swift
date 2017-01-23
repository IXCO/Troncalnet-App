//
//  HistorialViewController.swift
//  Troncalnet
//
//  Created by Ana Arellano on 02/08/16.
//  Copyright © 2016 Ixco. All rights reserved.
//

import UIKit

class HistorialViewController: UIViewController {

    @IBOutlet weak var periodo: UIPickerView!
    @IBOutlet weak var direccionRecibe: UITextField!
    var vehiculo:Auto!
    var registro:Dictionary<String,Dictionary<String,String>>!
    let datosPicker = ["7 días","14 días","21 días"]
    var diasSeleccionados=7
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enviar(_ sender: AnyObject) {
        let urlBase=Direccion()
        let urlPath = urlBase.direccion+"reporteAnterior.php?idv="+String(self.vehiculo.id)+"&periodo="+String(self.diasSeleccionados)+"&correo="+self.direccionRecibe.text!
        
        
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
                var mensaje = "Error"

                for (_,_) in self.registro{
                    //Sirve para obtener la estructura de respuesta
                    let value = self.registro["Resultado"]!

                    for valor in value.values{
                        mensaje = valor as String!
                        
                    }

                }
                //La respuesta predetermina de la API de conexión
                if(mensaje.contains("Error")){
                    self.crearMensaje("Error", mensaje: "No se pudo enviar el mensaje. Intente más adelante.", boton: "Aceptar")
                }else{
                    self.crearMensaje("Exito!", mensaje: "El mensaje ha sido enviado.", boton: "Aceptar")
                }
            })
            
            
            
        })
        
        task.resume()
    }
    /*
    Función generica para generar mensaje tipo alerta
    */
    func crearMensaje(_ titulo:String,mensaje:String,boton:String){
        let alertController = UIAlertController(title: titulo, message:
            mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: boton, style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - Delegates and data sources for PickerView
    //MARK: Data Sources
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datosPicker.count
    }
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datosPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
