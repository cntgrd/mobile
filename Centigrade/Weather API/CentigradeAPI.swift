//
//  CentigradeAPI.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-04-03.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import Foundation
import PromiseKit
import CentigradeData // Protobuf generated types

class CentigradeAPI {
	enum ErrorType: Error { case protobufDecodingFailed }
	
	typealias StationUUID = String
	
	static private let rootURL: URL? = URL(string: "https://dev.centigrade.me/api")
	
	static private func rawRecentMeasurements(forStation station: StationUUID)
	-> Promise<CentigradeData.Centigrade_StationRecentMeasurements>
	{
		return firstly {
			APITools.promiseEndpoint(withRootURL: rootURL, endpoint: "data")
		}.map { url in
			URLRequest(url: url)
		}.then { request in
			URLSession.shared.dataTask(.promise, with: request)
		}.map {
			let ResponseType = CentigradeData.Centigrade_StationRecentMeasurements.self
			guard let recentMeasurements = try? ResponseType.init(serializedData: $0.data)
			else {
				throw ErrorType.protobufDecodingFailed
			}
			return recentMeasurements
		}
	}
}
