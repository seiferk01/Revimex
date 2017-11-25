//
//  DescriptionViewController.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Mapbox

//variable global, obtiene un valor en TableViewCell.swift dependiendo de la propiedad que se selecciono
var idOfertaSeleccionada = ""

class DescriptionViewController: UIViewController, MGLMapViewDelegate {
    
    //variable para contener los datos entregados por el json de detalles
    var propiedad: Details = Details(Id: "",calle: "",colonia: "",construccion: "",cp: "",estacionamiento: "",estado: "",habitaciones: "",idp: "",lat: "0",lon: "0",municipio: "",niveles: "",origen_propiedad: "",patios: "",precio: "",terreno: "",tipo: "",descripcion: "",pros: "",wcs: "",fotos: [])

    
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var contenedorCarousel: UIScrollView!
    
    
    //variables para mapbox
    var mapView: MGLMapView = MGLMapView(frame: CGRect(x: 0.0,y: 0.0,width: 0,height: 0), styleURL: URL(string: "mapbox://styles/mapbox/light-v9"))
    var nombreImagenMarker: String = ""
    var degrees: Double = 180
    var marcador = "houseMarker"

    //variable para el carousel
    var vistaCarouselGrande = UIView()
    var contenedorCarouselGrande = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contenedorCarousel.isHidden = true
        
        //request a detalles
        requestDetails()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func incio() {
        
        print("***********Datos de la propiedad***************")
        print(propiedad.Id)
        print(propiedad.calle)
        print(propiedad.colonia)
        print(propiedad.construccion)
        print(propiedad.cp)
        print(propiedad.estacionamiento)
        print(propiedad.estado)
        print(propiedad.habitaciones)
        print(propiedad.idp)
        print(propiedad.lat)
        print(propiedad.lon)
        print(propiedad.municipio)
        print(propiedad.niveles)
        print(propiedad.origen_propiedad)
        print(propiedad.patios)
        print(propiedad.precio)
        print(propiedad.terreno)
        print(propiedad.tipo)
        print(propiedad.wcs)
        print(propiedad.fotos)
        
        
        //inicia asignacion de valores a descripcion
        if propiedad.descripcion != ""{
            descripcion.text = propiedad.descripcion
        }
        else if propiedad.pros != ""{
            descripcion.text = propiedad.pros
        }
        else {
            descripcion.text = "Descripcion no disponible"
        }
        
        descripcion.text = descripcion.text + "\n\nUBICACION\n"+propiedad.calle+" "+" "+propiedad.colonia+", "+propiedad.municipio+" "+propiedad.estado+" "+propiedad.cp+"."
        
        descripcion.text = descripcion.text + "\n\nINFORMACION\n"+propiedad.tipo+propiedad.habitaciones+propiedad.estacionamiento+propiedad.niveles+propiedad.patios+propiedad.terreno+propiedad.construccion+propiedad.precio
        
        descripcion.isEditable = false
        
        
        //inicia asignacion de valores al mapa
        let screenSize = UIScreen.main.bounds
        
        let url = URL(string: "mapbox://styles/mapbox/light-v9")
        
        mapView = MGLMapView(frame: CGRect(x: 0.0,y: (screenSize.height - 300),width: screenSize.width,height: 295.0), styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(propiedad.lat)!, longitude: Double(propiedad.lon)!), zoomLevel: 10, animated: false)
        mapView.delegate = self
        view.addSubview(mapView)
        
        addPrincipalMarker()
        
    }
    
    //acciondel boton para mostrar las fotos
    @IBAction func showPhotos(_ sender: Any) {
        
        descripcion.isHidden = true
        contenedorCarousel.isHidden = false
        
        var ancho = contenedorCarousel.bounds.width
        let largo = contenedorCarousel.bounds.height
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(carouselTapped(tapGestureRecognizer:)))
        contenedorCarousel.isUserInteractionEnabled = true
        contenedorCarousel.addGestureRecognizer(tapGestureRecognizer)
        
        contenedorCarousel.contentSize = CGSize(width: ancho * CGFloat(propiedad.fotos.count), height: largo)
        contenedorCarousel.isPagingEnabled = true
        contenedorCarousel.showsHorizontalScrollIndicator = false
       
        for (index, url) in propiedad.fotos.enumerated() {
            let data = Utilities.traerImagen(urlImagen: url)

            if data != nil {
                let image = UIImage(data: data as! Data)
                
                let marco = UIImageView(image: image)
                marco.frame.origin.x = ancho * CGFloat(index)
                marco.frame.origin.y = 0
                marco.frame.size = CGSize(width: ancho, height: largo)
                contenedorCarousel.addSubview(marco)
                
            }
        }
        
        
    }
    
    //accion al presionar en el carousel de fotos pequeño
    @objc func carouselTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let tappedImage = tapGestureRecognizer.view as! UIScrollView
        
        vistaCarouselGrande.frame = CGRect(x: 0 ,y: 0 ,width: self.view.frame.width,height: self.view.frame.height)
        vistaCarouselGrande.backgroundColor = UIColor.black
        vistaCarouselGrande.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        
        var ancho = view.bounds.width
        let largo = view.bounds.height
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageBigCarouselTapped(tapGestureRecognizer:)))
        vistaCarouselGrande.isUserInteractionEnabled = true
        vistaCarouselGrande.addGestureRecognizer(tapGestureRecognizer)
        
        
        contenedorCarouselGrande.frame.size = CGSize(width: view.bounds.width, height: view.bounds.width * (0.8))
        contenedorCarouselGrande.contentSize = CGSize(width: ancho * CGFloat(propiedad.fotos.count), height: largo/2)
        contenedorCarouselGrande.frame.origin.x = 0
        contenedorCarouselGrande.frame.origin.y = largo/4
        contenedorCarouselGrande.isPagingEnabled = true
        contenedorCarouselGrande.showsHorizontalScrollIndicator = false

        
        for (index, url) in propiedad.fotos.enumerated() {
            let data = Utilities.traerImagen(urlImagen: url)

            if data != nil {
                let image = UIImage(data: data as! Data)

                let marco = UIImageView(image: image)
                marco.frame.origin.x = ancho * CGFloat(index)
                marco.frame.origin.y = 0
                marco.frame.size = CGSize(width: ancho, height: view.bounds.width)
                contenedorCarouselGrande.addSubview(marco)

            }
        }
        
        vistaCarouselGrande.addSubview(contenedorCarouselGrande)
        
        view.addSubview(vistaCarouselGrande)
    }
    
    //oculta el carousel grande
    @objc func imageBigCarouselTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        contenedorCarouselGrande.removeFromSuperview()
        vistaCarouselGrande.removeFromSuperview()
    }
    
    //muestra la descripcion
    @IBAction func showDescription(_ sender: Any) {
        descripcion.isHidden = false
        contenedorCarousel.isHidden = true
    }
    
    //llamado a los detalles de la propiedad seleccionada
    func requestDetails() {
        
        let urlRequestDetails = "http://18.221.106.92/api/public/propiedades/detalle"
        
        let parameters = "id=" + idOfertaSeleccionada
        
        guard let url = URL(string: urlRequestDetails) else { return }
        
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        
        let httpBody = parameters.data(using: .utf8)
        
        request.httpBody = httpBody
        
        let session  = URLSession.shared
        print(session)
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
                print(data)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    
                    let propiedadSeleccionada = json["propiedad"] as! NSDictionary
                    print("*********Propiedad seleccionada***********")
                    print(propiedadSeleccionada)
                    
                    //                    if !(propiedadSeleccionada["Id"] is NSNull) { propiedad.Id = propiedadSeleccionada["Id"] as! String }
                    if !(propiedadSeleccionada["calle"] is NSNull) { self.propiedad.calle = propiedadSeleccionada["calle"] as! String }
                    if !(propiedadSeleccionada["colonia"] is NSNull) { self.propiedad.colonia = propiedadSeleccionada["colonia"] as! String }
                    if !(propiedadSeleccionada["construccion"] is NSNull) { self.propiedad.construccion = "Metros de construccion: " + (propiedadSeleccionada["construccion"] as! String) + "\n"}
                    if !(propiedadSeleccionada["cp"] is NSNull) { self.propiedad.cp = "C.P. " + (propiedadSeleccionada["cp"] as! String) }
                    if !(propiedadSeleccionada["estacionamiento"] is NSNull) { self.propiedad.estacionamiento = "Estacionamientos: " + (propiedadSeleccionada["estacionamiento"] as! String) + "\n"}
                    if !(propiedadSeleccionada["estado"] is NSNull) { self.propiedad.estado = propiedadSeleccionada["estado"] as! String }
                    if !(propiedadSeleccionada["habitaciones"] is NSNull) { self.propiedad.habitaciones = "Habitaciones: " + (propiedadSeleccionada["habitaciones"] as! String) + "\n"}
                    //                    if !(propiedadSeleccionada["idp"] is NSNull) { propiedad.idp = propiedadSeleccionada["idp"] as! String }
                    if !(propiedadSeleccionada["lat"] is NSNull) { self.propiedad.lat = propiedadSeleccionada["lat"] as! String }
                    if !(propiedadSeleccionada["lon"] is NSNull) { self.propiedad.lon = propiedadSeleccionada["lon"] as! String }
                    if !(propiedadSeleccionada["municipio"] is NSNull) { self.propiedad.municipio = propiedadSeleccionada["municipio"] as! String }
                    if !(propiedadSeleccionada["niveles"] is NSNull) { self.propiedad.niveles = "Niveles: " + (propiedadSeleccionada["niveles"] as! String) + "\n"}
                    if !(propiedadSeleccionada["origen_propiedad"] is NSNull) { self.propiedad.origen_propiedad = propiedadSeleccionada["origen_propiedad"] as! String }
                    if !(propiedadSeleccionada["patios"] is NSNull) { self.propiedad.patios = "Patios: " + (propiedadSeleccionada["patios"] as! String) + "\n"}
                    if !(propiedadSeleccionada["precio"] is NSNull) { self.propiedad.precio = "Precio: $" + (propiedadSeleccionada["precio"] as! String) + "\n"}
                    if !(propiedadSeleccionada["terreno"] is NSNull) { self.propiedad.terreno = "Metros de terreno: " + (propiedadSeleccionada["terreno"] as! String) + "\n"}
                    if !(propiedadSeleccionada["tipo"] is NSNull) { self.propiedad.tipo = "Tipo de inmuble: " + (propiedadSeleccionada["tipo"] as! String) + "\n"}
                    if !(propiedadSeleccionada["descripcion"] is NSNull) { self.propiedad.descripcion = propiedadSeleccionada["descripcion"] as! String }
                    if !(propiedadSeleccionada["pros"] is NSNull) { self.propiedad.pros = propiedadSeleccionada["pros"] as! String }
                    //                    if !(propiedadSeleccionada["wcs"] is NSNull) { propiedad.wcs = propiedadSeleccionada["wcs"] as! String }
                    if !(propiedadSeleccionada["files"] is NSNull) {
                        let files = propiedadSeleccionada["files"] as! Array<Any?>
                        for element in files{
                            let file = element as! NSDictionary
                            if !(file["linkPublico"] is NSNull){
                                let url = file["linkPublico"] as! String
                                self.propiedad.fotos.append(url)
                                print(self.propiedad.fotos)
                            }
                        }
                    }
                    
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    self.incio()
                })
                
            }
        }.resume()
        
    }
    

    //funciones para mostrar servicios
    @IBAction func mostrarSuperMercados(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "centroComercial"
        buscarServicios(servicio: "shopping_mall")
        cameraMovement()
    }

    @IBAction func mostrarRestaurantes(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "restaurantes"
        buscarServicios(servicio: "restaurant")
        cameraMovement()
    }

    @IBAction func mostrarEscuelas(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "escuelas"
        buscarServicios(servicio: "school")
        cameraMovement()
    }

    @IBAction func mostrarTiendas(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "Tiendas"
        buscarServicios(servicio: "convenience_store")
        cameraMovement()
    }

    @IBAction func mostrarHospitales(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "hospitales"
        buscarServicios(servicio: "hospital")
        cameraMovement()
    }

    @IBAction func mostrarParques(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        
        nombreImagenMarker = "parques"
        buscarServicios(servicio: "park")
        cameraMovement()
    }
    
    
    //agrega el marcador principal al mapa
    func addPrincipalMarker(){
        
        marcador = "houseMarker"
        let marcadorPrincipal = MGLPointAnnotation()
        marcadorPrincipal.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(propiedad.lat)!, longitude: CLLocationDegrees(propiedad.lon)!)
        marcadorPrincipal.title = propiedad.estado
        marcadorPrincipal.subtitle = propiedad.precio
        
        mapView.addAnnotation(marcadorPrincipal)
    }
    
    //movimiento de camara del mapa
    func cameraMovement(){
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(propiedad.lat)!, longitude: Double(propiedad.lon)!), animated: false)
        
        degrees += 180
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 3000, pitch: 60, heading: degrees)
        
        mapView.setCamera(camera, withDuration: 6, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }

    //request al api de google para localizar servicios
    func buscarServicios(servicio: String){
        
        marcador = servicio
        
        let apiGoogle = "AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q"
        
        let inicioUrl =  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + propiedad.lat + "," + propiedad.lon

        let urlRequestGoogle = inicioUrl+"&radius=2000&types=" + servicio + "&key=" + apiGoogle

        print("URL: " + urlRequestGoogle)

        guard let url = URL(string: urlRequestGoogle) else { return }

        let session  = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("response:")
                print(response)
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]

                    let results = json["results"] as! NSObject

                    for result in results as! NSArray {
                        let result = result as! NSDictionary
                        let geometry = result["geometry"] as! NSDictionary
                        let location = geometry["location"] as! NSDictionary
                        
                        print(result)
                        var nombre = ""
                        var direccion = ""
                        if !(result["name"] is NSNull){
                            nombre = result["name"] as! String
                        }
                        if !(result["vicinity"] is NSNull){
                            direccion = result["vicinity"] as! String
                        }
                        
                        self.agregarMarcadorServicio(latitud: location["lat"] as! Double, longitud: location["lng"] as! Double,nombre: nombre ,direccion: direccion)
                    }


                }catch {
                    print(error)
                }

            }
        }.resume()
        
        
    }

    //agrega los marcadores de servicios encontrados
    func agregarMarcadorServicio(latitud: Double, longitud: Double,nombre: String,direccion: String){
        
        let servicio = MGLPointAnnotation()
        servicio.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitud), longitude: CLLocationDegrees(longitud))
        servicio.title = nombre
        servicio.subtitle = direccion

        mapView.addAnnotation(servicio)
    }
    
    
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 2000, pitch: 50, heading: 180)
        
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "")
        
        if marcador == "houseMarker" {
            annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "marcadorPrincipal")
            
            if annotationImage == nil {
                
                var image = UIImage(named: marcador+".png")!
                image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
                
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "marcadorPrincipal")
            }
            
        }
        else {
            print(marcador)
            annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: marcador)
            
            var image = UIImage(named: marcador+".png")!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: marcador)
        
        }
        
        return annotationImage
        
    }
    
    
    //funciones favoritos
    @IBAction func favoritos(_ sender: Any) {
        let urlRequestFavoritos = "http://18.221.106.92/api/public/user/favorito"
        
        var userId = ""
        
        if let usId = UserDefaults.standard.object(forKey: "userId") as? String{
            userId = usId
        }
        
        let parameters: [String:Any] = [
            "user_id" : userId,
            "prop_id" : idOfertaSeleccionada
        ]
        
        print(userId)
        print(idOfertaSeleccionada)
        
        guard let url = URL(string: urlRequestFavoritos) else { return }
        
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let session  = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    print(json)
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    
                })
                
            }
        }.resume()
        
    }
    
    @IBAction func compartir(_ sender: Any) {
        
        let urlRequestFavoritos = "http://18.221.106.92/api/public/user/favorito"
        
        var userId = ""
        
        if let usId = UserDefaults.standard.object(forKey: "userId") as? String{
            userId = usId
        }
        
        let parameters: [String:Any] = [
            "user_id" : userId,
            "consulta" : 1
        ]
        
        print(userId)
        print(idOfertaSeleccionada)
        
        guard let url = URL(string: urlRequestFavoritos) else { return }
        
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let session  = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    print(json)
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    
                })
                
            }
        }.resume()
        
    }
    

}
