//  See Me Soon
//
//  Created by Ron Allan on 2019-02-09.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import UIKit
import MapKit

protocol AddGeotificationsViewControllerDelegate {
    func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
                                        radius: Double, identifier: String, note: String, eventType: EventType)
}

class AddGeotificationViewController: UITableViewController {
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var zoomButton: UIBarButtonItem!
    @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var loginSwitch: UISwitch!
    @IBOutlet weak var tradesSwitch: UISwitch!
    @IBOutlet weak var zonesSwitch: UISwitch!
    
    var delegate: AddGeotificationsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [addButton, zoomButton]
        addButton.isEnabled = false
        
        let defaults = UserDefaults.standard
        var isOn = defaults.bool(forKey: "isLoginOn")
        loginSwitch.isOn = isOn
        isOn = defaults.bool(forKey: "isTradesOn")
        tradesSwitch.isOn = isOn
        isOn = defaults.bool(forKey: "isZonesOn")
        zonesSwitch.isOn = isOn
    }
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        addButton.isEnabled = !radiusTextField.text!.isEmpty && !noteTextField.text!.isEmpty
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAdd(_ sender: UIBarButtonItem) {
        let coordinate = mapView.centerCoordinate
        let radius = Double(radiusTextField.text!) ?? 0
        let identifier = NSUUID().uuidString
        let note = noteTextField.text
        let eventType: EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
        delegate?.addGeotificationViewController(controller: self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: eventType)
    }
    
    
    @IBAction func onZoomToCurrentLocation(_ sender: UIBarButtonItem) {
        mapView.zoomToUserLocation()
    }
    
    @IBAction func onLoginValueChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        let isOn = defaults.bool(forKey: "isLoginOn")
        defaults.set(!isOn, forKey: "isLoginOn")
    }
    
    @IBAction func onTradesValueChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        let isOn = defaults.bool(forKey: "isTradesOn")
        defaults.set(!isOn, forKey: "isTradesOn")
    }
    
    @IBAction func onZonesValueChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        let isOn = defaults.bool(forKey: "isZonesOn")
        defaults.set(!isOn, forKey: "isZonesOn")
    }
    
}

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        setRegion(region, animated: true)
    }
}
