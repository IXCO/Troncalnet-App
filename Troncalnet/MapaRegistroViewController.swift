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
class MapaRegistroViewController: UIViewController, MKMapViewDelegate {
    var regionRadio: CLLocationDistance = 1000
    var latitude:NSString! = ""
    var longitude:NSString! = ""
    var latitudes=[String]()
    var longitudes=[String]()
    var route: MKRoute?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var region:CLLocation!
       
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
            
            let annotation = MKPointAnnotation()
            annotation.coordinate=location
            
            
            self.mapView.addAnnotation(annotation)

        }
                
        
    }
    func creaRecorrido(){
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        //Punto inicial
        point1.coordinate = CLLocationCoordinate2DMake(Double(self.latitudes[0])!, Double(self.longitudes[0])!)
        
        mapView.addAnnotation(point1)
        //Punto final
        point2.coordinate = CLLocationCoordinate2DMake(Double(self.latitudes[1])!, Double(self.longitudes[1])!)
        mapView.addAnnotation(point2)
        
        //Centra el mapa hacia la coordenada/punto dos
        mapView.centerCoordinate = point2.coordinate
        
        
        //Span of the map
        mapView.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
        
        //Busca el camino desde punto 1 a punto 2
        let directionsRequest = MKDirectionsRequest()
        let markOne = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        let markTwo = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source=MKMapItem(placemark: markTwo)
        directionsRequest.destination=MKMapItem(placemark: markOne)
        directionsRequest.transportType = MKDirectionsTransportType.automobile
        let directions = MKDirections(request: directionsRequest)
        //Calcula ruta de punto 1 a punto 2 y la agrega sobre el mapa
        directions.calculate ( completionHandler: {
            (response:MKDirectionsResponse?, error: NSError?) in
            if error == nil {
                self.route = response!.routes[0] as MKRoute
                self.mapView.add((self.route?.polyline)!)
            }
        } as! MKDirectionsHandler)
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
        //Modifica las propiedades de la linea para un recorrido
        let myLineRenderer = MKPolylineRenderer(polyline: route!.polyline)
       myLineRenderer.strokeColor = UIColor.red
        myLineRenderer.lineWidth = 3
        return myLineRenderer
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
