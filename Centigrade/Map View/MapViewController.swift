//
//  MapViewController.swift
//  Centigrade
//
//  Created by Paul Herz on 2017-10-31.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
	
	lazy var conditionViewModels: [ViewModel] = {
		return [
			WeatherConditionViewModel(title: "Today", condition: .sunny),
			WeatherConditionViewModel(title: "Tomorrow", condition: .cloudy)
		]
	}()
	
	lazy var locationManager: CLLocationManager = CLLocationManager()
	
	lazy var weatherOverlay: MKTileOverlay = {
		// [CITE] http://mesonet.agron.iastate.edu/ogc/
		// who, apparently, process NWS NEXRAD radar data into images
		// (something NWS doesn't do)
		//
		// The URL below with the {z}/{x}/{y} template is what's called a
		// TMS - Tile Map Service. Google invented a way to represent slices
		// of the world map in (x,y,z), where `z` is zoom level (0...). Zoom
		// level 0 is the entire world, which only has one slice (x:0,y:0).
		// Zoom level 1 has four slices, (0,0)..(1,1), and so on.
		//
		// MKTileOverlay allows you to provide just the URL for a TMS like this
		// and it will dynamically load the visible tiles. The URL above describes
		// the list of all services or "products" in weather nerd.
		
		let service = "nexrad-n0q-900913" // NEXRAD Base Reflectivity current
		let template = "https://mesonet.agron.iastate.edu/cache/tile.py/1.0.0/\(service)/{z}/{x}/{y}.png"
		let overlay = MKTileOverlay(urlTemplate: template)
		overlay.canReplaceMapContent = false
		return overlay
	}()
	
	lazy var tileRenderer: MKTileOverlayRenderer = {
		// The MKTileOverlayRenderer is responsible for actually rendering
		// a tile overlay defined as an MKTileOverlay. The MKTileOverlay is
		// "added" to the map (see MKMapView.add(_:level:) in viewDidLoad)
		// and then the MKMapView calls mapView(_:rendererFor:) to get the
		// corresponding renderer.
		let tr = MKTileOverlayRenderer(tileOverlay: weatherOverlay)
		tr.alpha = 0.5
		return tr
	}()
	
	var mapView: MapView {
		return view as! MapView
	}
	
	override func loadView() {
		view = MapView(frame: UIScreen.main.bounds)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Here we actually tell the MKMapView to register the
		// MKTileOverlay, but the MKMapView will ask the delegate
		// which renderer is actually responsible for rendering
		// said overlay.
		mapView.map.delegate = self
		mapView.map.add(weatherOverlay, level: .aboveRoads)
		
		mapView.appSettingsButton.addTarget(self, action: #selector(didPressAppSettingsButton), for: .touchUpInside)
		
		mapView.cardScrollView.dataSource = self
		
		locationManager.requestWhenInUseAuthorization()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@objc func didPressAppSettingsButton() {
		navigationController?.pushViewController(AppSettingsViewController(), animated: true)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		updateViewConstraints()
	}
}

extension MapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		return tileRenderer
	}
}

extension MapViewController: CardScrollViewDataSource {
	
	func numberOfCards(in cardScrollView: CardScrollView) -> Int {
		return conditionViewModels.count
	}
	
	func contentView(in cardScrollView: CardScrollView, atIndex index: Int) -> UIView {
		let model = conditionViewModels[index]
		return model.makeView(from: nil)
	}
}




