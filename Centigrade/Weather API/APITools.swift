//
//  APITools.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-04-03.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCoreLocation
import UIKit

class APITools {
	
	public static let manager = CLLocationManager()
	
	public static func locationSetup() {
		manager.requestWhenInUseAuthorization()
	}
	
	public static func location() -> Single<CLLocation> {
		return manager.rx.isEnabled.filter { $0 }.take(1).asSingle().flatMap { _ in
			return manager.rx.location.filter {
				$0 != nil
			}.map {
				return $0!
			}.take(1).asSingle()
		}
	}
	
	// wraps the optionally successful generation of an endpoint URL based on
	// the combination of a root URL and an extension into a Promise so it
	// can be chained with other networking promises.
	//
	// there is no value *per se* in doing this as a promise, as it is synchronous,
	// but since it is failable and can be chained with asynchronous stuff, it
	// makes sense.
	public static func endpoint(withRootURL rootURL: URL?, endpoint: String) -> URL? {
		guard let root = rootURL else {
			return nil
		}
		guard let endpointURL = URL(string: endpoint, relativeTo: root) else {
			return nil
		}
		return endpointURL
	}
	
	public static func urlEncode(coordinate c: CLLocationCoordinate2D) -> String {
		return "\(c.latitude),\(c.longitude)"
	}
	
	public static func promptUserForLocationSettings(_ viewController: UIViewController) {
		DispatchQueue.main.async {
			let alertController = UIAlertController(
				title: "Location Unavailable",
				message: "Please visit settings to reenable Location Services.",
				preferredStyle: .alert
			)
			
			let cancelAction = UIAlertAction(
				title: "Cancel",
				style: .cancel,
				handler: nil
			)
			let settingsAction = UIAlertAction(
				title: "Settings",
				style: .default
			) { action in
				UIApplication.shared.open(
					URL(string: UIApplicationOpenSettingsURLString)!,
					options: [:],
					completionHandler: nil
				)
			}
			alertController.addAction(cancelAction)
			alertController.addAction(settingsAction)
			viewController.present(alertController, animated: true, completion: nil)
		}
	}
}
