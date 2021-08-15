//
//  PersistencyHelper.swift
//  Bullseye
//
//  Created by Andy Mina on 8/15/21.
//

import Foundation

class PersistencyHelper {
	static func dataFilePath() -> URL {
		// grab the path to this app's document directory
		// returns an array of size one
		let paths: [URL] = FileManager.default.urls(
			for: .documentDirectory,
			in: .userDomainMask
		);
		
		// add a new component to this path (documentDirectory)
		return paths[0].appendingPathComponent("HighScores.plist");
	}
	
	static func saveHighScores(_ items: [HighScoreItem]) {
		let encoder = PropertyListEncoder();
		
		do {
			let data = try encoder.encode(items);
			try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic);
		} catch {
			print("Error encoding item array: \(error.localizedDescription)");
		}
	}
	
	static func loadHighScores() -> [HighScoreItem] {
		var items = [HighScoreItem]();
		let path = dataFilePath();
		if let data = try? Data(contentsOf: path) {
			let decoder = PropertyListDecoder();
			
			do {
				items = try decoder.decode([HighScoreItem].self, from: data);
			} catch {
				print("Error decodng item array: \(error.localizedDescription)");
			}
		}
		
		return items;
	}
}
