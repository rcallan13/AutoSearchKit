//
//  GeofencedPoint.swift
//  See Me Soon
//
//  Created by Ron Allan on 2019-02-09.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//
// Modified from https://www.raywenderlich.com/136165/core-location-geofencing-tutorial
import UIKit
import MapKit
import CoreLocation

struct GeoKey {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let radius = "radius"
    static let identifier = "identifier"
    static let note = "note"
    static let eventType = "eventTYpe"
}

enum EventType: String {
    case onEntry = "On Entry"
    case onExit = "On Exit"
}

public class GeofencedPoint: NSObject, NSCoding, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D
    public var radius: CLLocationDistance
    var identifier: String
    var note: String
    var eventType: EventType
    
    var pointTitle: String? {
        if note.isEmpty {
            return "No Note"
        }
        return note
    }
    
    var pointSubtitle: String? {
        let eventTypeString = eventType.rawValue
        return "Radius: \(radius)m - \(eventTypeString)"
    }
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String, eventType: EventType) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.note = note
        self.eventType = eventType
    }
    
    // MARK: NSCoding
    required public init?(coder decoder: NSCoder) {
        let latitude = decoder.decodeDouble(forKey: GeoKey.latitude)
        let longitude = decoder.decodeDouble(forKey: GeoKey.longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = decoder.decodeDouble(forKey: GeoKey.radius)
        identifier = decoder.decodeObject(forKey: GeoKey.identifier) as! String
        note = decoder.decodeObject(forKey: GeoKey.note) as! String
        eventType = EventType(rawValue: decoder.decodeObject(forKey: GeoKey.eventType) as! String)!
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(coordinate.latitude, forKey: GeoKey.latitude)
        coder.encode(coordinate.longitude, forKey: GeoKey.longitude)
        coder.encode(radius, forKey: GeoKey.radius)
        coder.encode(identifier, forKey: GeoKey.identifier)
        coder.encode(note, forKey: GeoKey.note)
        coder.encode(eventType.rawValue, forKey: GeoKey.eventType)
    }
}

