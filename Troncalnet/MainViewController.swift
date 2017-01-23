//
//  MainViewController.swift
//  Troncalnet
//
//  Created by Ana Arellano on 30/01/15.
//  Copyright (c) 2015 IXCO. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITextFieldDelegate {
    @IBAction func regresarInicio(_ segue: UIStoryboardSegue){
        
    }
    var user:Usuario!
    
    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //funcion para el evento de tocar el boton
    @IBAction func ingresar(_ sender: UIButton) {
        accesa()
    }
    func crearMensaje(_ titulo:String,mensaje:String,boton:String){
        let alertController = UIAlertController(title: titulo, message:
            mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: boton, style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    func accesa(){
        let usuario:String! = self.username.text
        let contra:String! = self.password.text
        if( usuario != "" && contra != "" ){
                let urlBase=Direccion()
                let urlPath = urlBase.direccion+"valid.php?username="+usuario+"&password="+contra
                        
                var result : String? = nil
                let url = URL(string: urlPath)
                var connection:Bool=false
                let session = URLSession.shared
                let task = session.dataTask(with: url!, completionHandler: {data, response, error -> Void in
                    let err: NSError?
                    var jsonResult : Any
                    if(error == nil){
                            do {
                                jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            } catch {
                                fatalError()
                            }

                            
                            if let topApps = jsonResult as? NSDictionary   {
                                if let feed = topApps["User"] as? NSDictionary {
                                    if let intern=feed["name"] as? NSString{
                                        result=intern as String
                                        
                                        let clin = feed["clientID"] as! Int
                                        
                                        let udc = feed["userID"] as! Int
                                        
                                        self.user = Usuario(idCliente: String(clin), idusuario: String(udc))
                                    }
                                    
                                }
                            }
                            connection=true
                    }
                    DispatchQueue.main.async(execute: {
                                if (result != nil ){
                                    //sin error
                                    self.performSegue(withIdentifier: "menu", sender: self)
                                }else if(result == nil && connection==true){
                                    //error de parametros
                                    self.crearMensaje("Error", mensaje: "Usuario y/o contraseña incorrecto", boton: "Aceptar")
                                     }else{
                                    self.crearMensaje("Error", mensaje: "No se pudo conectar, vuelva a intentar en unos momentos o revise su conexión.", boton: "Aceptar")                                }
                                
                            })
                    
                    
                        })
                        
                task.resume()
            }else{
            //datos vacios
            crearMensaje("Error", mensaje: "Debe ingresar sus datos para acceder a su cuenta.", boton: "Aceptar")
            }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Envia los datos del usuario a todas las vistas de la tabulación
        let tab = segue.destination as! UITabBarController
        let svc = tab.viewControllers?.first as! MapaViewController
        svc.user = self.user
       
        let controllers = tab.viewControllers?.dropLast(1)
        let scnd = controllers?.last as! AutomovilesTableViewController
        scnd.user = self.user
      
        let controller = tab.viewControllers?.dropFirst(2)
        let notificaciones = controller?.first as! NotificacionesTableViewController
        notificaciones.user = self.user
        
        
    }
    /* Mark-TextField
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        
            if textField == self.username {
                self.password.becomeFirstResponder()
            }else{
                accesa()
            }

        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    }

