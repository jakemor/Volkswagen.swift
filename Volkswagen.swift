//
//  Volkswagen.swift
//  Fitness AI
//
//  Created by Jake on 4/30/19.
//  Copyright © 2019 Jake Mor. All rights reserved.
//

import Foundation

public class Volkswagen {
	
	public static let shared = Volkswagen()
	
	// taken from the app store, only digits
	var appId: String? {
		didSet {
			getLiveAppStoreVersion()
		}
	}
	
	// if set, isAppUnderReview will always pass this value to the completion function
	var forcedValue: Bool?
	
	private var apiURL: URL? {
		get {
			
			if let appId = appId {
				return URL(string: "https://itunes.apple.com/lookup?id=\(appId)")
			}
			
			return nil
			
		}
	}
	
	private var liveVersion: String?
	
	// taken dfrom info.plist
	private var currentVersion: String {
		get {
			return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
		}
	}
	
	init() {
		
		
	}
	
	private func getLiveAppStoreVersion(completion: (() -> ())? = nil) {
		if let url = apiURL {
			let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
				
				if let data = data {
					do {
						// Convert the data to JSON
						let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
						
						// Get Live App Store Version
						if let json = jsonSerialized, let results = json["results"] as? [[String: Any]] {
							
							if results.count != 1 {
								fatalError("Invalid appId: \(self.appId!)")
							}
							
							if let version = results[0]["version"] as? String {
								self.liveVersion = version
							}
							
							completion?()
						} else {
							fatalError("Invalid appId: \(self.appId!)")
						}
					}  catch let error as NSError {
						fatalError(error.localizedDescription)
					}
				} else if let error = error {
					fatalError(error.localizedDescription)
				}
			}
			
			task.resume()

		} else {
			fatalError("Volkswagen.shared.appId is not defined.")
		}
		
	}
	
	func isAppUnderReview(completion: @escaping (Bool) -> ()) {
		
		if let forcedValue = forcedValue {
			completion(forcedValue)
		}
		
		if let liveVersion = liveVersion {
			
			let order = currentVersion.compare(liveVersion, options: .numeric)
			
			if order == .orderedDescending {
				completion(true)
			} else {
				completion(false)
			}
			
		} else {
			getLiveAppStoreVersion {
				self.isAppUnderReview(completion: completion)
			}
		}
		
	}
	
}


