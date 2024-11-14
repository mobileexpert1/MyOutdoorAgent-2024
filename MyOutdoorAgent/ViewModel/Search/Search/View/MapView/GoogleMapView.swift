//  GoogleMapView.swift
//  MyOutdoorAgent
//  Created by CS on 26/12/22.

import UIKit
import PKHUD
import GoogleMaps
import MapKit
import GoogleMapsUtils

extension SearchView {
    
    // MARK: - Web Services
    func setMultipolygonApi(_ rluName: String) {
        // HUD.show(.progress, onView: self.view)

        self.searchViewModelArr?.multiPolygonApi(self.view, rluName: rluName, completion: { [self] responseModel in
            self.coordinateMultiplygonArr.removeAll()
            multtipolygons.forEach { $0.map = nil }
            multtipolygons.removeAll()
            
            // Safely unwrap the features
            guard let features = responseModel.features else {
                HUD.hide()
                return
            }

            var firstPolygonCoordinates: [[Double]]? // Store the first polygon coordinates
            
            // Iterate through all features
            for feature in features {
                guard let geometry = feature.geometry else {
                    continue
                }

                // Handle coordinates based on their type
                guard let coordinates = geometry.coordinates else {
                    continue
                }

                switch coordinates {
                case .twoDimensional(let coords):
                    for polygonCoords in coords {
                        createPolygon(from: polygonCoords, feature: feature)
                        if firstPolygonCoordinates == nil {
                            firstPolygonCoordinates = polygonCoords // Capture the first polygon coordinates
                        }
                    }
                case .fourDimensional(let coords):
                    for polygonCoords in coords {
                        for polygon in polygonCoords {
                            createPolygon(from: polygon, feature: feature)
                            if firstPolygonCoordinates == nil {
                                firstPolygonCoordinates = polygon // Capture the first polygon coordinates
                            }
                        }
                    }
                }
            }

            // Zoom into the first polygon if available
            if let firstCoords = firstPolygonCoordinates, !firstCoords.isEmpty {
                let firstCoordinate = firstCoords[0]
                let camera = GMSCameraPosition.camera(withLatitude: firstCoordinate[1], longitude: firstCoordinate[0], zoom: 14)
                self.mapView.camera = camera
            }

            self.mapView.animate(toZoom: 14)
            HUD.hide()
        })

        updateLabelVisibility(for: mapView.camera.zoom)
    }

    private func createPolygon(from coordinates: [[Double]], feature: MultipolygonFeature) {
        guard !coordinates.isEmpty else { return }
        
        let path = GMSMutablePath()
        
        for coordinateArray in coordinates {
            guard coordinateArray.count == 2 else { continue }

            // Extract longitude and latitude
            let longitude = coordinateArray[0]
            let latitude = coordinateArray[1]

            // Ensure they are of type CLLocationDegrees (Double)
            guard let long = CLLocationDegrees(exactly: longitude),
                  let lat = CLLocationDegrees(exactly: latitude) else { continue }

            // Create CLLocationCoordinate2D and add to path
            path.add(CLLocationCoordinate2D(latitude: lat, longitude: long))
        }

        // Create and configure the polygon
        let polygon = GMSPolygon(path: path)
        polygon.strokeColor = (feature.properties?.isLicensed == 1)
            ? UIColor(red: 0/255, green: 118/255, blue: 22/255, alpha: 1.0)
            : UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)
        polygon.fillColor = UIColor.clear
        polygon.strokeWidth = 2
        polygon.title = feature.properties?.rluNo ?? "Polygon"
        polygon.map = self.mapView
        multtipolygons.append(polygon)

        // Create label marker for the polygon (optional)
        let labelMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: coordinates[0][1], longitude: coordinates[0][0]))
        let label = UILabel()
        label.text = polygon.title
        label.textColor = .black
        label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
        label.sizeToFit()
        labelMarker.iconView = label
        labelMarker.map = self.mapView
        labelMarkers2.append(labelMarker)
    }



    func setMultipolygonApi2(_ rluName: String) {
        // HUD.show(.progress, onView: self.view)

        self.searchViewModelArr?.multiPolygonApi2(self.view, rluName: rluName, completion: { [self] responseModel in
            self.coordinateMultiplygonArr.removeAll()
            multtipolygons2.forEach { $0.map = nil }
            multtipolygons2.removeAll()
            // Safely unwrap the first feature
            guard let firstFeature = responseModel.features?.last,
                  let geometry = firstFeature.geometry else {
                HUD.hide()
                return
            }

            // Extract coordinates based on the type
            guard let coordinates = geometry.coordinates else {
                HUD.hide()
                return
            }

            var firstPolygonCoordinates: [[[Double]]]?

            switch coordinates {
            case .twoDimensional(let coords):
                firstPolygonCoordinates = coords
            case .fourDimensional(let coords):
                // Assuming you want the first polygon's coordinates from the first array of the four-dimensional structure
                firstPolygonCoordinates = coords.first
            }

            // Ensure we have valid coordinates
            guard let polygonCoordinates = firstPolygonCoordinates?.first else {
                HUD.hide()
                return
            }

            // Set camera to the first coordinate (assuming it has at least one coordinate)
            guard let initialCoordinate = polygonCoordinates.last, initialCoordinate.count == 2 else {
                HUD.hide()
                return
            }

            let camera = GMSCameraPosition.camera(withLatitude: initialCoordinate[1], longitude: initialCoordinate[0], zoom: 14)
            self.mapView.camera = camera

            // Create a path for the polygon
            let path = GMSMutablePath()

            // Iterate through the first polygon's coordinates
            for coordinate in polygonCoordinates {
                // Ensure each coordinate is an array of doubles with exactly two elements
                guard coordinate.count == 2 else { continue }

                let longitude = coordinate[0] // First element is longitude
                let latitude = coordinate[1]  // Second element is latitude

                path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }

            // Create a polygon after iterating through coordinates
            let polygon = GMSPolyline(path: path)

            // Set polygon color based on licensing status
            polygon.strokeColor = (firstFeature.properties?.isLicensed == 1)
                ? UIColor(red: 0/255, green: 118/255, blue: 22/255, alpha: 1.0)
                : UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)

            polygon.strokeWidth = 2
            polygon.title = rluName
            polygon.map = self.mapView
            multtipolygons2.append(polygon)
            // Create label marker for the polygon
            let labelMarker = GMSMarker(position: camera.target)
            let label = UILabel()
            label.text = polygon.title
            label.textColor = .black
            label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
            label.sizeToFit()
            labelMarker.iconView = label
            labelMarker.map = self.mapView
            labelMarkers2.append(labelMarker)

            self.mapView.animate(toZoom: 14)
            HUD.hide()

            // Assuming drawPolygons is still relevant
            // self.drawPolygons {
            //     self.mapView.animate(toZoom: 14)
            //     HUD.hide()
            // }

            // Additional delays to refresh UI (optional)
            // DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //     HUD.show(.progress, onView: self.view)
            // }
        })
        // updateLabelVisibility(for: mapView.camera.zoom)
    }



    
//    func setSpecificPolygonApi(_ rluName: String) {
//        HUD.show(.progress, onView: self.view)
//        self.searchViewModelArr?.multiPolygonApi(self.view, rluName: rluName, completion: { [self] responseModel in
//            self.coordinateMultiplygonArr.removeAll()
//
//            // Safely unwrap the first feature and its coordinates
//            guard let firstFeature = responseModel.features?.first,
//                  let polygonCoordinates = firstFeature.geometry?.coordinates?.first else {
//                HUD.hide()
//                return
//            }
//
//            // Create bounds to fit the polygon
//            var bounds = GMSCoordinateBounds()
//
//            // Create the polygon path
//            let path = GMSMutablePath()
//            
//            for coordinate in polygonCoordinates {
//                // Ensure each coordinate is a valid array of doubles
//                guard let coordinateArray = coordinate as? [Double], coordinateArray.count == 2 else { continue }
//
//                let longitude = coordinateArray[0]
//                let latitude = coordinateArray[1]
//
//                let point = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                path.add(point)
//
//                // Update the bounds to include this point
//                bounds = bounds.includingCoordinate(point)
//            }
//
//            // Create and style the polygon
//            let polygon = GMSPolyline(path: path)
//            polygon.strokeColor = (firstFeature.properties?.isLicensed == 1)
//                ? UIColor(red: 0/255, green: 118/255, blue: 22/255, alpha: 1.0)
//                : UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)
//            polygon.strokeWidth = 2
//            polygon.title = rluName
//            polygon.map = self.mapView
//
//            // Set the camera to fit the bounds with a zoom level of 14
//            let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 20) // Optional padding
//            self.mapView.animate(with: cameraUpdate)
//
//            // Calculate the center of the polygon for the label marker
//            let centerLatitude = (bounds.northEast.latitude + bounds.southWest.latitude) / 2
//            let centerLongitude = (bounds.northEast.longitude + bounds.southWest.longitude) / 2
//            let centerCoordinate = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
//
//            // Create a label marker at the center of the polygon
//            let labelMarker = GMSMarker(position: centerCoordinate)
//            let label = UILabel()
//            label.text = polygon.title
//            label.textColor = .black
//            label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
//            label.sizeToFit()
//            labelMarker.iconView = label
//            labelMarker.map = self.mapView
//
//            // Initially set visibility based on current zoom
//            label.isHidden = mapView.camera.zoom < 12
//
//            // Clear any previous items in the cluster manager
//            self.clusterManager.clearItems()
//            HUD.hide()
//        })
//        
//        updateLabelVisibility(for: mapView.camera.zoom)
//    }
    
    // Point Layer Api
    func setPointLayer() {
        self.searchViewModelArr?.pointLayerApi(self.view, completion: { [self] responseModel in
            self.mapModel = responseModel
       //     print("MapModel",mapModel)
            self.coordinatePointArr.removeAll()
            self.isLicensedArr.removeAll()
            responseModel.features?.forEach({ feature in
               //     LocalStore.shared.coordinatePointArr.append(feature.geometry?.coordinates! ?? [])
              //  LocalStore.shared.isLicensedArr.append((feature.properties?.isLicensed)!)
                self.coordinatePointArr.append(feature.geometry?.coordinates! ?? [])
                self.isLicensedArr.append((feature.properties?.isLicensed)!)
            })
            print("isLicensedArr",isLicensedArr.count)
            DispatchQueue.main.async { [self] in
             
                self.setPolyLayer()
            }
        })
    }
    
    // Poly Layer Api
    func setPolyLayer() {
        self.searchViewModelArr?.polyLayerApi(self.view, completion: { responseModel in
            self.polyArr = responseModel
    
            self.coordinatePolyArr.removeAll()
        //    self.coordinateMultiPolyArr.removeAll()
            self.isLicensedPolyArr.removeAll()
            self.isLicensedMultiPolyArr.removeAll()
            DispatchQueue.main.async { [self] in
                self.polyArr?.features.forEach({ feature in
                    if feature.geometry.coordinates.count != 0 {
                        for _ in 0..<feature.geometry.coordinates.count {
                            
                            if feature.geometry.type == "MultiPolygon" {
                            
                            } else {
                              
                            }
                        }
                    }
                })
                print("isLicensedMultiPolyArr",isLicensedMultiPolyArr)
                print("isLicensedPolyArr",isLicensedPolyArr)
                setMapView()
              
            }
        })
    }
    
    
    // MARK: - MapView
    func setMapView() {
        HUD.show(.progress, onView: self.view)
        self.mapView.delegate = self
        self.mapView.settings.compassButton = true
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = true
        self.mapView.settings.rotateGestures = true
        self.mapView.settings.scrollGestures = true
        self.mapView.settings.zoomGestures = true
        self.mapView.setMinZoom(0, maxZoom: 16)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                  self.setClusterMap()
              }
 
    }
    
    // MARK: - Map Actions
    func setMapActions() {
        // Zoom In
        self.zoomInV.actionBlock {
            self.mapView.animate(toZoom: self.mapView.camera.zoom + 1)
            
//            if self.mapView.camera.zoom >= 8.0 {
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    print("=-=-=-=-=-=-=-=-=-==-=-=-=-=-=>>>>>>>>>>>========")
//                    HUD.show(.progress, onView: self.view)
//                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        self.drawPolygons {
//                            print("=-=-=-=-=-=-=-=-=-==-=-=-=-=-=>>>>>>>>>>>")
//                            
//                            DispatchQueue.main.async {
//                                print("=-=-=-=-=-=-=-=-=-==-=-=-=-=-=>>>>>>>>>>>!!!!!!!")
//                                HUD.hide()
//                                self.clusterManager.clearItems()
//                               
//                                self.mapView.animate(toZoom: self.mapView.camera.zoom + 1)
//                                print("=-=-=-=-=-=-=-=-=-==-=-=-=-=-=>>>>>>>>>>>!!!!!!!===========")
//                            }
//                        }
//                    }
//                }
//
//            }
        }
        
        // Zoom Out
        self.zoomOutV.actionBlock {
            self.mapView.animate(toZoom: self.mapView.camera.zoom - 1)
            print("self.mapView.camera.zoom",self.mapView.camera.zoom)
//            if self.mapView.camera.zoom <= 10 {
//                if self.isChanged == true {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        HUD.show(.progress, onView: self.view)
//                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                            self.generateClusterItems(self.mapView.camera.zoom) { [self] in
//                                polygon?.strokeColor = .clear
//                                polygon?.strokeWidth = 0
//                                polygon?.map = self.mapView
//                                DispatchQueue.main.async {
//                                    HUD.hide()
//                                }
//                            }
//                        }
//                        self.specificLabelMarker.map = nil
//                    }
//                }
//            }
        }
        
        // Map
        mapV.actionBlock {
            self.mapView.mapType = .normal
            self.mapLbl.textColor = .black
            self.hybridLbl.textColor = .darkGray
        }
        
        // Hybrid
        hybridV.actionBlock {
            self.mapView.mapType = .satellite
            self.mapLbl.textColor = .darkGray
            self.hybridLbl.textColor = .black
        }
    }
}

// MARK: - Directions
extension SearchView {
    func openGoogleDirectionMap( destinationLat: String,  destinationLng: String) {
        let LocationManager = CLLocationManager()
        if let myLat = LocationManager.location?.coordinate.latitude, let myLng = LocationManager.location?.coordinate.longitude {
            if let tempURL = URL(string: "comgooglemaps://?saddr=&daddr=\(destinationLat),\(destinationLng)&directionsmode=driving") {
                UIApplication.shared.open(tempURL, options: [:], completionHandler: { (isSuccess) in
                    if !isSuccess {
                        if UIApplication.shared.canOpenURL(URL(string: "https://www.google.co.th/maps/dir///")!) {
                            UIApplication.shared.open(URL(string: "https://www.google.co.th/maps/dir/\(myLat),\(myLng)/\(destinationLat),\(destinationLng)/")!, options: [:], completionHandler: nil)
                        } else {
                            print("Can't open URL.")
                        }
                    }
                })
            } else {
                print("Can't open GoogleMap Application.")
            }
        } else {
            print("Please allow permission.")
        }
    }
}

// MARK: - SearchViewModelDelegate
extension SearchView {
    func pointLayerSuccessCalled() {
        HUD.hide()
    }
    func pointLayerErrorCalled() {
        HUD.flash(.labeledError(title: "", subtitle: "error"), delay: 1.0)
    }
    func polyLayerSuccessCalled() {
         HUD.hide()
    }
    func polyLayerErrorCalled() {
        HUD.flash(.labeledError(title: "", subtitle: "error"), delay: 1.0)
    }
    func multiPolygonSuccessCalled() {
        // HUD.hide
    }
    func multiPolygonErrorCalled() {
        HUD.hide()
        let btn = [ButtonText.ok.text]
        UIAlertController.showAlert(AppAlerts.propertyNotListed.title, message: AppErrors.propertyNotListed.localizedDescription, buttons: btn) { alert, index in
            if index == 0 {
                self.searchTopView.toggleBtn.image = Images.map.name
                self.setListViewInMainV()
                self.searchTopViewInScrollV.toggleBtn.image = Images.map.name
                self.setListViewInScrollV()
            }
        }
    }
    func rluDetailSuccessCalled() {
        HUD.hide()
    }
    func rluDetailErrorCalled() {
        HUD.hide()
        let btn = [ButtonText.ok.text]
        UIAlertController.showAlert("", message: "\(self.productNo) is currently not available", buttons: btn) { alert, index in
            if index == 0 {
            }
        }
    }
}
