//
//  HighScoreItem.swift
//  Bullseye
//
//  Created by Andy Mina on 8/15/21.
//

import Foundation

class HighScoreItem: Equatable, Codable {
	var name: String = "";
	var score: Int = 0;
	
  // constructor
	init(name: String, score: Int) {
		self.name = name;
		self.score = score;
	}
  
  // equality
  static func == (lhs: HighScoreItem, rhs: HighScoreItem) -> Bool {
    return lhs.name == rhs.name && lhs.score == rhs.score;
  }
}
