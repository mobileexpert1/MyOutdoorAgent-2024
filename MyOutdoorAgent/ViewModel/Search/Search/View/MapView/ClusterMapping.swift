//  ClusterMapping.swift
//  MyOutdoorAgent
//  Created by CS on 04/01/23.

import UIKit
import PKHUD
import GoogleMaps
import MapKit
import GoogleMapsUtils

extension SearchView {
    
    // MARK: - Clustering
    // Keep track of added markers
    func setClusterMap() {
        // Clear previous clusters and markers
        clusterArr.removeAll()
        clusterManager?.clearItems() // Ensure old items are cleared
        addedMarkersCount = 0 // Reset count

        print("isLicensedArr.count: \(isLicensedArr.count)")

        // Filter coordinates where isLicensedArr value is 0
        for i in 0..<self.isLicensedArr.count {
            if self.isLicensedArr[i] == 0 {
                // Assuming coordinatePointArr is of type [[Double]] or similar
                clusterArr.append(self.coordinatePointArr[i]) // Store coordinates corresponding to licensed items
            }
        }
        
        print("clusterArr.count: \(clusterArr.count)")

        // Create icon generator based on cluster count
        let clusterCount = NSNumber(value: clusterArr.count)
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [clusterCount], backgroundColors: [UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)

        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setMapDelegate(self)
        clusterManager.setDelegate(self, mapDelegate: self)

        // Generate and add cluster items based on filtered coordinates
        self.generateClusterItems(3) {
            HUD.hide()
            self.specificLabelMarker.map = nil

            // Log the total number of added markers
            print("Total markers added: \(self.addedMarkersCount)")

            // Perform clustering after adding items
            self.clusterManager.cluster()
        }

        self.mapDetailPopUpV.zoomLbl.text = "Zoom In"
        self.zoom = true
    }

    

    func generateClusterItems(_ zoom: Float, completion: @escaping () -> ()) {
        clusterManager.clearItems() // Clear previous items
        addedMarkersCount = 0 // Reset count
        
        for i in 0..<self.clusterArr.count { // Iterate over filtered coordinates
            let lat = self.clusterArr[i][1] // Access latitude
            let lng = self.clusterArr[i][0] // Access longitude
            
            if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
                print("Invalid lat long for index \(i): \(lat), \(lng)")
                continue
            }
            
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let marker = GMSMarker(position: position)
            
            marker.icon = #imageLiteral(resourceName: "green_marker") // Always green for licensed
            
            clusterManager.add(marker)
            addedMarkersCount += 1 // Increment the count for each added marker
        }
        
        if !self.clusterArr.isEmpty {
            if isFirstClusterGeneration {
                // Center the camera on the bounds of all markers for the first call
                var bounds = GMSCoordinateBounds()
                for coordinate in self.clusterArr {
                    let lat = coordinate[1]
                    let lng = coordinate[0]
                    bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                }
                let cameraUpdate = GMSCameraUpdate.fit(bounds)
                self.mapView.animate(with: cameraUpdate)
                isFirstClusterGeneration = false // Set to false after the first call
            } else {
                // Maintain the current camera position but update the zoom
                let currentCameraPosition = self.mapView.camera
                self.mapView.camera = GMSCameraPosition.camera(
                    withLatitude: currentCameraPosition.target.latitude,
                    longitude: currentCameraPosition.target.longitude,
                    zoom: zoom
                )
            }
        }
        completion()
    }

}

// MARK: - GMUMapViewDelegate and GMUClusterManagerDelegate
extension SearchView: GMUClusterManagerDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        print("zoom====>>>>>>", mapView.camera.zoom)
        if let _ = marker.userData as? GMUCluster {
            if mapView.camera.zoom >= 8.0 {
            } else {
                mapView.animate(toZoom: mapView.camera.zoom + 1)
            }
            NSLog("Did tap cluster")
            return true
        }
        if let label = marker.iconView as? UILabel {
            let text = label.text ?? "No text available"
            print("Marker icon text: \(text)")
            
            // Retrieve the stroke color of the polygon associated with this label
            if let strokeColor = polygonData[text] {
                // Determine the binary representation
                let colorValue: Int
                if strokeColor == .red {
                    colorValue = 1
                } else if strokeColor == UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1) { // Your specific green
                    colorValue = 0
                } else {
                    print("Unknown color")
                    colorValue = -1 // Use -1 for any unexpected color
                }
                
                print("Polygon stroke color binary value: \(colorValue)")
                isLicensed = colorValue
                // You can now use colorValue as needed
            } else {
                print("isLicensed Value :-- ",isLicensed)
                print("No polygon found for this label.")
            }

            productNo = text
        } else {
            print("Marker iconView is not a UILabel")
        }
        
//        print("coordinatePointArr.count",coordinatePointArr.count)
//        print("coordinatePointArr[i][1]",coordinatePointArr)
//        print("marker.position.longitude",marker.position.longitude)
//        print("marker.position.latitude",marker.position.latitude)
//    
        for i in 0..<coordinatePointArr.count where coordinatePointArr[i][0] == marker.position.longitude && coordinatePointArr[i][1] == marker.position.latitude {
            var tempArr = [Double]()
            tempArr.append(marker.position.longitude)
            tempArr.append(marker.position.latitude)
            
            if self.coordinatePointArr.contains(tempArr) {
                let index = self.coordinatePointArr.lastIndex(of: tempArr)
                productNo = (self.mapModel?.features?[index!].properties?.rluNo)!
                print("productNo:::",productNo)
                isLicensed = (self.mapModel?.features?[index!].properties?.isLicensed)!
                self.latitude = marker.position.latitude
                self.longitude = marker.position.longitude
            }
        }
        NSLog("Did tap marker")
        return false
    }
    
  //  var hasCalledGenerateClusterItems = false

    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        print("sdgfhdfdhfggfdj@@@@@####!!!!!")
        
        if mapView.camera.zoom >= 10 {
            drawPolygons { [self] in
                clusterManager.clearItems()
            }
            drawPolygonss { 
//                clusterManager.clearItems()
            }
            drawNonMotorizedPolygons(from: nonMotorizedArr!)
            for i in 0..<self.accessPointArr.count {
               
                showImageAtLocation(latitude: self.accessPointArr[i][1], longitude:  self.accessPointArr[i][0], gateType: accessPointGateTypeArr[i])
            }
            // Reset the flag when zoom level is 10 or greater
            hasCalledGenerateClusterItems = false
        } else {
            polygons.forEach { $0.map = nil }
            polygonsPermit.forEach{ $0.map = nil }
            multtipolygons.forEach{ $0.map = nil }
            multtipolygons2.forEach{ $0.map = nil }
        
            for marker in accessPointMarkers {
                           marker.map = nil
                       }
            drawNonMotorizedPolygons(from: nonMotorizedArr!)
            accessPointMarkers.removeAll()
          //  showImageAtLocation(latitude: self.accessPointArr[0][0], longitude:  self.accessPointArr[0][0], gateType: "")
            // Call generateClusterItems only if it hasn't been called yet
            if !hasCalledGenerateClusterItems {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    generateClusterItems(mapView.camera.zoom) { [self] in
                        //   After calling, set the flag to true
                        hasCalledGenerateClusterItems = true
                    }
                }
            }
        }
        updateLabelVisibility(for: mapView.camera.zoom)
    }
    
    func drawPolygons(_ completion: @escaping () -> ()) {
        // Remove the old polygons and labels
        polygons.forEach { $0.map = nil }
        polygons.removeAll()
        labelMarkers.forEach { $0.map = nil }
        labelMarkers.removeAll()

        guard let polyArr = self.polyArr else {
            completion()
            return
        }
        
        let visibleRegion = self.mapView.projection.visibleRegion()
        let visibleBounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)

        polyArr.features.forEach { feature in
            let coordinates = feature.geometry.type == "MultiPolygon"
                ? feature.geometry.coordinates.flatMap { $0[0] }
                : feature.geometry.coordinates[0]

            var polygonPoints: [CLLocationCoordinate2D] = []
            let path = GMSMutablePath()

            coordinates.forEach { internalCoordinate in
                do {
                    let encoded = try JSONEncoder().encode(internalCoordinate)
                    let decoded = try JSONDecoder().decode([Double].self, from: encoded)
                    let point = CLLocationCoordinate2D(latitude: decoded[1], longitude: decoded[0])
                    path.add(point)
                    polygonPoints.append(point)
                } catch {
                    print(error.localizedDescription)
                }
            }

            if polygonPoints.contains(where: { visibleBounds.contains($0) }) {
                let polygon = GMSPolyline(path: path)
                polygon.strokeColor = feature.properties.isLicensed == 1 ? .red : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)
                let strokeColor = feature.properties.isLicensed == 1 ? .red : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)
                polygon.strokeWidth = 2
                polygon.title = feature.properties.rluNo
                polygon.map = self.mapView
                polygons.append(polygon)
                polygonData[polygon.title ?? ""] = strokeColor
                // Calculate the centroid of the polygon
                let centroid = calculateCentroid(of: polygonPoints)

                // Create label marker at the centroid
                let labelMarker = GMSMarker(position: centroid)
                let label = UILabel()
                label.text = polygon.title
                label.textColor = .black
                label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
                label.sizeToFit()
                labelMarker.iconView = label
                labelMarker.map = self.mapView
                labelMarkers.append(labelMarker)
                
                // Set initial visibility based on current zoom
                label.isHidden = mapView.camera.zoom < 12
            }
        }

        updateLabelVisibility(for: mapView.camera.zoom)
        completion()
    }

    // Function to calculate the centroid of a set of coordinates
     func calculateCentroid(of points: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        var totalLatitude: Double = 0
        var totalLongitude: Double = 0

        for point in points {
            totalLatitude += point.latitude
            totalLongitude += point.longitude
        }

        let count = Double(points.count)
        return CLLocationCoordinate2D(latitude: totalLatitude / count, longitude: totalLongitude / count)
    }

    func updateLabelVisibility(for zoomLevel: Float) {
        guard zoomLevel != lastZoomLevel else { return }
        lastZoomLevel = zoomLevel
        
        let shouldShowLabels = zoomLevel >= 12
        let shouldShowLabels2 = zoomLevel >= 14
        labelMarkers2.forEach{ labelMaker in
            labelMaker.iconView?.isHidden = !shouldShowLabels2
        }
        labelMarkers.forEach { labelMarker in
            labelMarker.iconView?.isHidden = !shouldShowLabels
        }
        labelMarkersPermit.forEach { labelMarker in
            labelMarker.iconView?.isHidden = !shouldShowLabels
        }
    }

    // Update visibility on camera position change
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        updateLabelVisibility(for: position.zoom)
      }
    }
    
// MARK: - GMSMapViewDelegate
extension SearchView: GMSMapViewDelegate {
    
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
        let marker = GMSMarker(position: centerMapCoordinate)
        marker.map = self.mapView
    }
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        self.searchViewModelArr?.rluDetailApi(self.view, productNo: productNo, completion: { [self] responseModel in
            print("isLicensed",isLicensed)
            if self.isLicensed == 1 {
                let btn = [ButtonText.ok.text]
                UIAlertController.showAlert("", message: "\(self.productNo) is currently not available", buttons: btn) { alert, index in
                    if index == 0 {
                    }
                }
            } else {
                self.viewTransition(self.mapDetailPopUpV)     // Map Detail Pop Up View
                
                self.mapDetailPopUpV.displayNameLbl.text = responseModel.productNo
                self.mapDetailPopUpV.countyLbl.text = responseModel.countyName! + " County, " + responseModel.stateName!
                self.mapDetailPopUpV.acresLbl.text = responseModel.acres?.description
                self.mapDetailPopUpV.priceLbl.text = "$" + "" + responseModel.licenseFee!.description
                
                // -- Set Image
            //    print("responseModel.imageFilename",responseModel.imageFilename)
                if responseModel.imageFilename == nil {
                    self.mapDetailPopUpV.rluImageV.image = Images.logoImg.name
                } else {
                    var str = (Apis.rluImageUrl) + responseModel.imageFilename!
                    print("Apis.rluImageUrl",Apis.rluImageUrl + (responseModel.imageFilename ?? ""))
                    if let dotRange = str.range(of: "?") {
                        str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                        str.contains(" ")
                        ? self.mapDetailPopUpV.rluImageV.setNetworkImage(self.mapDetailPopUpV.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
                        : self.mapDetailPopUpV.rluImageV.setNetworkImage(self.mapDetailPopUpV.rluImageV, str)
                    } else {
                        str.contains(" ")
                        ? self.mapDetailPopUpV.rluImageV.setNetworkImage(self.mapDetailPopUpV.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
                        : self.mapDetailPopUpV.rluImageV.setNetworkImage(self.mapDetailPopUpV.rluImageV, str)
                    }
                }
                if self.mapDetailPopUpV.rluImageV.image == UIImage(named: "") {
                    self.mapDetailPopUpV.rluImageV.image = Images.logoImg.name
                }
                self.mapDetailPopUpV.rluImageV.actionBlock {
                    var data = [String: Any]()
                    data["publicKey"] = responseModel.publicKey
                    data["id"] = responseModel.productID
                    isComingFrom = "map"
                    LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
                    UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
                }
                
                // Cross Button
                self.mapDetailPopUpV.crossBtn.actionBlock {
                    self.removeView(self.mapDetailPopUpV)
                }
                
                // View Details
                self.mapDetailPopUpV.viewDetailsBtn.actionBlock {
                    var data = [String: Any]()
                    data["publicKey"] = responseModel.publicKey
                    data["id"] = responseModel.productID
                    isComingFrom = "map"
                    LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
                    UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
                }
                // Zoom In
                self.mapDetailPopUpV.zoomInBtn.actionBlock {
                    if self.zoom == true {
                        self.mapView.animate(toZoom: self.mapView.camera.zoom + 2)
                        self.zoom = false
                        self.mapDetailPopUpV.zoomLbl.text = "Zoom Out"
                        self.removeView(self.mapDetailPopUpV)
                        // self.setSpecificPolygonApi(responseModel.productNo!)
                    } else {
                        self.mapView.animate(toZoom: self.mapView.camera.zoom - 2)
                        self.zoom = true
                        self.mapDetailPopUpV.zoomLbl.text = "Zoom In"
                        self.removeView(self.mapDetailPopUpV)
                    }
                }
                
                // Directions
                self.mapDetailPopUpV.directionsBtn.actionBlock {
                    //if checkLocationPermissions() {
                    //        print(locationDict.value(forKey: "Location")!)
                    //       print(index)
                    
                    //       let locationCoordinates = (locationDict.value(forKey: "Location")! as AnyObject).components(separatedBy: ",")
                    
                    // Create An UIAlertController with Action Sheet
                    let optionMenuController = UIAlertController(title: nil, message: "Choose Option for maps", preferredStyle: .actionSheet)
                    
                    // Create UIAlertAction for UIAlertController
                    let googleMaps = UIAlertAction(title: "Google Maps", style: .default, handler: {
                        (alert: UIAlertAction!) -> Void in
                        self.openGoogleDirectionMap(destinationLat: String(self.latitude), destinationLng: String(self.longitude))
                    })
                    
                    let appleMaps = UIAlertAction(title: "Apple Maps", style: .default, handler: {
                        (alert: UIAlertAction!) -> Void in
                        
                        
                        
                        //                        let directionsURL = "http://maps.apple.com/maps?saddr=&daddr=\(self.latitude)\(self.longitude)"
                        let directionsURL = "https://maps.apple.com/?daddr=\(self.latitude),\(self.longitude)"
                        guard let url = URL(string: directionsURL) else {
                            return
                        }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                        
                        // Pass the coordinate that you want here
                        //                        let coordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude)
                        //                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
                        //                        mapItem.name = "Destination"
                        //                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                        
                        /*
                         
                         let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)))
                         source.name = self.productNo
                         
                         //let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(([longitudeString] as NSString).doubleValue), longitude: Double(([LatitudeString] as NSString).doubleValue))
                         
                         let locc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)
                         
                         let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locc.latitude, longitude: locc.longitude)))
                         
                         destination.name = responseModel.countyName! + " County, " + responseModel.stateName!
                         
                         MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                         
                         */
                    })
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                        (alert: UIAlertAction!) -> Void in
                        print("Cancel")
                    })
                    
                    // Add UIAlertAction in UIAlertController
                    optionMenuController.addAction(googleMaps)
                    optionMenuController.addAction(appleMaps)
                    optionMenuController.addAction(cancelAction)
                    
                    // Present UIAlertController with Action Sheet
                    self.present(optionMenuController, animated: true, completion: nil)
                    //   }
                    
                    //}
                }
            }
        })
        return UIView()
    }
    
    // MARK: - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    
    // MARK: - GMSMarker position
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
    }
}
