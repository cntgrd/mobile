//
//  CentigradeAPI.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-04-03.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import Foundation
import RxSwift
import CentigradeData // Protobuf generated types
import SwiftProtobuf // needed to genericize the deserialization process

extension CentigradeAPI.ErrorType: LocalizedError {
	public var errorDescription: String? {
		var e = "[Centigrade.CentigradeAPI.ErrorType] "
		switch self {
		case .httpError(let code):
			e += "HTTP Error \(code) - \(HTTPURLResponse.localizedString(forStatusCode: code))"
		case .malformedURL:
			e += "Malformed URL"
		case .protobufDecodingFailed:
			e += "Protobuf decoding failed"
		case .nilDataInResponse:
			e += "Received `nil` data in response to request"
		}
		return e
	}
}

class CentigradeAPI {
	enum ErrorType: Error {
		case httpError(code: Int),
		malformedURL,
		protobufDecodingFailed,
		nilDataInResponse
	}
	
	typealias StationUUID = String
	
	static private let rootURL: URL? = URL(string: "https://dev.centigrade.me/api/")
	
	static private func decodeProtobuf<T: SwiftProtobuf.Message>(
		type: T.Type,
		atEndpoint endpoint: String
	) -> Single<T> {
		// we promise the protobuf object, deserialized
		return Single<T>.create { single in
			// try to append the endpoint to the base URL and see
			// if it forms a valid URL
			guard let url = APITools.endpoint(withRootURL: rootURL, endpoint: endpoint) else {
				single(.error(ErrorType.malformedURL))
				// no special cleanup necessary
				return Disposables.create()
			}
			
			// if we have a valid URL, build the request
			var req = URLRequest(url: url)
			
			// server needs to know we're ready for raw binary (serialized PB)
			req.setValue("application/octet-stream", forHTTPHeaderField: "Accept")
			
			let task = URLSession.shared.dataTask(with: req) { data, res, error in
				if let httpRes = res as? HTTPURLResponse {
					let code = httpRes.statusCode
					let errorCodes = 400..<600
					if errorCodes.contains(code) {
						single(.error(ErrorType.httpError(code: code)))
					}
				}
				guard let data = data else {
					single(.error(ErrorType.nilDataInResponse))
					return
				}
				do {
					single(.success(try T(serializedData: data)))
				} catch {
					single(.error(ErrorType.protobufDecodingFailed))
				}
			}
			task.resume()
			return Disposables.create { task.cancel() }
		}
	}
	
	static public func rawRecentMeasurements(forStation station: StationUUID)
	-> Single<CentigradeData.Centigrade_StationRecentMeasurements>
	{
		return decodeProtobuf(
			type: Centigrade_StationRecentMeasurements.self,
			atEndpoint: "data"
		)
	}
}
