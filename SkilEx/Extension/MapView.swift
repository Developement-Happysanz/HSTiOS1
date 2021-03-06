//
//  MapView.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 23/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MapKit

extension UIViewController: MKMapViewDelegate
{
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        
       // let reuseId = "pin"
        
        let reuseId = GlobalVariables.shared.reuseID
        if reuseId == "pin"
        {
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
                pinView!.pinTintColor = UIColor.red
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        else
        {
            var annotationView: MKAnnotationView?
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) {
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
            }
            else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            if let annotationView = annotationView {
                
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "bike")
            }
            return annotationView
        }
        
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
                print(doSomething)
            }
        }
    }
}

