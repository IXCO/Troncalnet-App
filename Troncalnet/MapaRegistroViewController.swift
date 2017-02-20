//
//  MapaRegistroViewController.swift
//  Troncalnet
//
//  Created by Ana Arellano on 3/22/15.
//  Copyright (c) 2015 IXCO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import Foundation
class MapaRegistroViewController: UIViewController, MKMapViewDelegate {
    var regionRadio: CLLocationDistance = 1000
    var latitude:NSString! = ""
    var longitude:NSString! = ""
    var latitudes=[String]()
    var longitudes=[String]()
    var route: MKRoute?
    var polyline: MKPolyline?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var region:CLLocation!
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        if(self.latitude.isEqual(to: "")){
            //Si no tiene solo un dato significa que es recorrido
            //por lo tanto hay que centrarlo y llamar la función
            region = CLLocation(latitude: 22.5561115, longitude: -120.8204404)
            regionRadio = 10 as CLLocationDistance!
            
            creaRecorrido()

        }else{
            //Si es solo un evento envia el punto que se tiene que dibujar sobre el mapa
                region = CLLocation(latitude: self.latitude.doubleValue, longitude: self.longitude.doubleValue)
            centrarMapa(region)
            
            let location = CLLocationCoordinate2D( latitude: self.latitude.doubleValue, longitude: self.longitude.doubleValue)
            
            let annotation = ColorPointAnnotation(pinColor: UIColor.red)
            annotation.coordinate=location
            
            
            self.mapView.addAnnotation(annotation)

        }
                
        
    }
    func creaRecorrido(){
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        let totalPuntos=self.longitudes.count-1
        //Punto inicial
        point1.coordinate = CLLocationCoordinate2DMake(Double(self.latitudes[0])!, Double(self.longitudes[0])!)
        let annotation = ColorPointAnnotation(pinColor: UIColor.blue)
        annotation.coordinate = point1.coordinate
        annotation.title = "Inicio"
        mapView.addAnnotation(annotation)
        //mapView.addAnnotation(point1)
        //Punto final
        point2.coordinate = CLLocationCoordinate2DMake(Double(self.latitudes[totalPuntos])!, Double(self.longitudes[totalPuntos])!)
        let point2Annotation = ColorPointAnnotation(pinColor: UIColor.red)
        point2Annotation.coordinate=point2.coordinate
        point2Annotation.title = "Fin"
        mapView.addAnnotation(point2Annotation)
        
        //Centra el mapa hacia la coordenada/punto dos
        mapView.centerCoordinate = point2.coordinate
        
        
        //Span of the map
        mapView.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
        //Inicializa arreglo de puntos cardinales
        var locations=[CLLocationCoordinate2D].self()
        var i=totalPuntos
        //Agrega punto a ruta
        while(i >= 0){
            let currentLocation = CLLocationCoordinate2D(latitude: Double(self.latitudes[i])!, longitude: Double(self.longitudes[i])!)
            locations.append(currentLocation)
            i-=1

        }
        
        addPolyLineToMap(locations: locations)

    }
    func addPolyLineToMap(locations: [CLLocationCoordinate2D])
    {
        var coordinates = locations
        
        self.polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        self.mapView.add(self.polyline!)

    }
    func centrarMapa(_ location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadio * 2.0, regionRadio * 2.0)
        mapView.setRegion(region, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
            // draw the track
            let polyLineRenderer = MKPolylineRenderer(polyline: self.polyline!)
            polyLineRenderer.strokeColor = UIColor.blue
            polyLineRenderer.lineWidth = 2.0
            
            return polyLineRenderer
        

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            let colorPointAnnotation = annotation as! ColorPointAnnotation
            pinView?.pinTintColor = colorPointAnnotation.pinColor
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
