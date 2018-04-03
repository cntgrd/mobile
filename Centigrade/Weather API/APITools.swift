//
//  APITools.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-04-03.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import PromiseKit
import CoreLocation

class APITools {
	enum ErrorType: Error {
		case nilRootURL, malformedURL
	}
	
	// wraps the optionally successful generation of an endpoint URL based on
	// the combination of a root URL and an extension into a Promise so it
	// can be chained with other networking promises.
	//
	// there is no value *per se* in doing this as a promise, as it is synchronous,
	// but since it is failable and can be chained with asynchronous stuff, it
	// makes sense.
	public static func promiseEndpoint(withRootURL rootURL: URL?, endpoint: String) -> Promise<URL> {
		return Promise<URL> { promise in
			guard let root = rootURL else {
				promise.reject(ErrorType.nilRootURL)
				return
			}
			guard let endpointURL = URL(string: endpoint, relativeTo: root) else {
				promise.reject(ErrorType.malformedURL)
				return
			}
			promise.fulfill(endpointURL)
		}
	}
	
	public static func urlEncode(coordinate c: CLLocationCoordinate2D) -> Guarantee<String> {
		return .value("\(c.latitude),\(c.longitude)")
	}
}
