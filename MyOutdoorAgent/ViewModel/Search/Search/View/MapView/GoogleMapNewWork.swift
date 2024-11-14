//  GoogleMapNewWork.swift
//  MyOutdoorAgent
//  Created by Mobile on 14/10/24.

import Foundation
import UIKit
import PKHUD
import GoogleMaps
import MapKit
import GoogleMapsUtils
struct HashableCoordinate: Hashable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    static func == (lhs: HashableCoordinate, rhs: HashableCoordinate) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension SearchView {
    
    func accessPintApiCall() {
        self.searchViewModelArr?.accessPointApi(self.view, completion: { [self] responseModel in
            print("responseModel",responseModel)
            acessPoint = responseModel
            
           // print("acessPointndshfjhsdgdsfgh/./.,./,./,/,./.",acessPoint)
              responseModel.features?.forEach({ feature in
                
                //  LocalStore.shared.coordinatePointArr.append(feature.geometry?.coordinates! ?? [])
                //  LocalStore.shared.isLicensedArr.append((feature.properties?.isLicensed)!)
                self.accessPointArr.append(feature.geometry?.coordinates! ?? [])
                self.accessPointGateTypeArr.append(feature.properties?.gateType ?? "")
                //  self.isLicensedArr.append((feature.properties?.isLicensed)!)
            })
        })
    }
    
    func showImageAtLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, gateType: String) {
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Create a marker
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Your Location"
        
        // Set custom image
        if gateType == "Access" {
            marker.icon = UIImage(named: "GreenCircle") // Use your image name here
        } else if gateType == "Other" {
            marker.icon = UIImage(named: "OrangeCircle") // Use your image name here
        }
        // Add marker to the map
        marker.map = mapView
        accessPointMarkers.append(marker)
    }
    
    func permitShapesApiCall() {
        self.searchViewModelArr?.permitShapesApi(self.view, completion: { [self] responseModel in
            print("responseModelpermitShapes",responseModel)
            permitShapesData = responseModel
            print("permitShapes",permitShapesData!)
        })
    }
     
    func nonMotorizedApiCall() {
        self.searchViewModelArr?.nonMotorizedApi(self.view, completion: { [self] responseModel in
            print("responseModel",responseModel)
            nonMotorizedArr = responseModel
        })
    }
    func drawPolygonss(_ completion: @escaping () -> ()) {
        // Remove old polygons and labels
        polygonsPermit.forEach { $0.map = nil }
        polygonsPermit.removeAll()
        labelMarkersPermit.forEach { $0.map = nil }
        labelMarkersPermit.removeAll()

        guard let polyArr = self.permitShapesData else {
            print("No permit shapes data available")
            completion()
            return
        }

        polyArr.features?.forEach { feature in
            let geometry = feature.geometry

            // Handle MultiPolygon
            if geometry?.type == "MultiPolygon" {
                if case .fourDimensional(let coordinates) = geometry?.coordinates {
                    for multiPolygon in coordinates {
                        // Each multiPolygon is a [[Double]] for the coordinates
                        for polygon in multiPolygon {
                            drawPolygon(from: polygon, title: feature.properties?.rluNo ?? "", isLicensed: feature.properties?.isLicensed == 1)
                        }
                    }
                }
            } else if geometry?.type == "Polygon" { // Handle single Polygon
                if case .twoDimensional(let coordinates) = geometry?.coordinates,
                   let firstCoordinates = coordinates.first {
                    drawPolygon(from: firstCoordinates, title: feature.properties?.rluNo ?? "", isLicensed: feature.properties?.isLicensed == 1)
                }
            }
        }
        // Update label visibility based on the current zoom level
        updateLabelVisibility(for: mapView.camera.zoom)
        completion()
    }

    // Function for drawing a polygon from nested coordinates
    private func drawPolygon(from coordinates: [[Double]], title: String, isLicensed: Bool) {
        let path = GMSMutablePath()
        var polygonPoints: [CLLocationCoordinate2D] = []
        var uniqueCoordinates = Set<HashableCoordinate>()

        for coordinate in coordinates {
            guard coordinate.count >= 2 else { continue }
            let point = CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])
            
            // Add only unique coordinates using HashableCoordinate
            if uniqueCoordinates.insert(HashableCoordinate(coordinate: point)).inserted {
                path.add(point)
                polygonPoints.append(point)
            }
        }

        // Ensure the polygon is closed properly
        if !polygonPoints.isEmpty {
            path.add(polygonPoints[0]) // Close the polygon
        }

        // Create and style the polygon
        let polygon = GMSPolyline(path: path)
        polygon.strokeColor = isLicensed ? .red : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)
        polygon.strokeWidth = 2
        polygon.title = title
        polygon.map = self.mapView
        polygonsPermit.append(polygon)

        // Calculate the centroid for label positioning
        let centroid = calculateCentroid(of: polygonPoints)

        // Create label marker
        let labelMarker = GMSMarker(position: centroid)
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
        label.sizeToFit()
        labelMarker.iconView = label
        labelMarker.map = self.mapView
        labelMarkersPermit.append(labelMarker)

        // Set label visibility based on zoom level
        label.isHidden = mapView.camera.zoom < 12
    }

    func setStateZoom(coordinates: [[[Double]]]) {
        HUD.show(.progress, onView: self.view)

        // Create a GMSCoordinateBounds object from the coordinates
        var bounds = GMSCoordinateBounds()

        // Iterate through the coordinates to include all points in the bounds
        for polygon in coordinates {
            for coordinate in polygon {
                // Ensure coordinate has at least two elements
                guard coordinate.count >= 2 else { continue }
                let lat = coordinate[1] // Latitude
                let lng = coordinate[0] // Longitude
                let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                bounds = bounds.includingCoordinate(location)
            }
        }

        // Animate the map to fit the bounds
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
        mapView.animate(with: update)

        // Hide the HUD after zooming
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
    
    func drawNonMotorizedPolygons(from model: NonMotorizedModel) {
        // Clear existing polygons
       // mapView.clear() // Clear all existing markers and polygons

        // Ensure the model has features
        guard let features = model.features else { return }

        for feature in features {
            // Ensure geometry has coordinates
            guard let coordinates = feature.geometry?.coordinates else { continue }

            for polygonCoordinates in coordinates {
                // Create a mutable path for the polygon
                let path = GMSMutablePath()

                // Iterate through the polygon coordinates
                for coordinateSet in polygonCoordinates {
                    for coordinate in coordinateSet {
                        // Ensure each coordinate has at least two elements
                        guard coordinate.count >= 2 else { continue }
                        let lng = coordinate[0] // Longitude
                        let lat = coordinate[1] // Latitude
                        path.add(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                    }
                }
                // Create a polygon
                let polygon = GMSPolygon(path: path)

                // Set the fill color based on zoom level
                if mapView.camera.zoom >= 10 {
                    polygon.fillColor = UIColor(red: 219/255, green: 221/255, blue: 168/255, alpha: 1.0) // Yellow with full opacity
                } else {
                    polygon.fillColor = UIColor(red: 219/255, green: 221/255, blue: 168/255, alpha: 0.0) // Fully transparent
                }
                polygon.strokeColor = .clear // Outline color
                polygon.strokeWidth = 0.0 // Outline width

                // Add the polygon to the map
                polygon.map = self.mapView
            }
        }
    }
}
