//
//  ContatosNoMapaViewController.swift
//  ContatosIP67
//
//  Created by ios7531 on 11/08/18.
//  Copyright © 2018 ios7531. All rights reserved.
//

import UIKit
import MapKit

class ContatosNoMapaViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    var contatos:[Contato] = Array()
    
    let dao:ContatoDAO = ContatoDAO.sharedInstance()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapa.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()

        let botaoLocalizacao = MKUserTrackingBarButtonItem(mapView: self.mapa)
        self.navigationItem.rightBarButtonItem = botaoLocalizacao
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.contatos = dao.listaTodos()
        self.mapa.addAnnotations(self.contatos)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mapa.removeAnnotations(self.contatos)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier:String = "pino"
        
        var pino:MKPinAnnotationView
        
        if let reusablePin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            pino = reusablePin
            
        }else{
            pino = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        if let contato = annotation as? Contato {
            
            pino.pinTintColor = UIColor.red
            pino.canShowCallout = true
            
            if let foto = contato.foto {
            
                let frame = CGRect(x: 0.0, y: 0.0, width: 32.0, height: 32.0)
                let imagemContato = UIImageView(frame: frame)
            
                imagemContato.image = foto
            
                pino.leftCalloutAccessoryView = imagemContato
            
            }
        }
        
        return pino
    }
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        //desafio
//    }

}
