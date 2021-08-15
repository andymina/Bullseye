//
//  ViewController.swift
//  Bullseye
//
//  Created by Andy Mina on 8/8/21.
//

import UIKit

class ViewController: UIViewController {
	var currentValue: Int = 0;
	var targetValue: Int = 0;
	var score: Int = 0;
	var round: Int = 0;
	
	@IBOutlet weak var slider: UISlider!;
	@IBOutlet weak var targetLabel: UILabel!;
	@IBOutlet weak var scoreLabel: UILabel!;
	@IBOutlet weak var roundLabel: UILabel!;
	
	override func viewDidLoad() {
		super.viewDidLoad();
		startNewGame();
		
		// set default slider img
		let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!;
		slider.setThumbImage(thumbImageNormal, for: .normal);
		// set highlighted slider img
		let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")!;
		slider.setThumbImage(thumbImageHighlighted, for: .highlighted);
		
		// set insets for positioning slider
		let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14);
		// set left side of slider
		let sliderLeftImg = UIImage(named: "SliderTrackLeft")!;
		let sliderLeftResizable = sliderLeftImg.resizableImage(withCapInsets: insets);
		// set right side of slider
		let sliderRightImg = UIImage(named: "SliderTrackRight")!;
		let sliderRightResizable = sliderRightImg.resizableImage(withCapInsets: insets);
		
		slider.setMinimumTrackImage(sliderLeftResizable, for: .normal);
		slider.setMaximumTrackImage(sliderRightResizable, for: .normal);
	}
	
	@IBAction func showAlert() {
		// calc points and update score
		let difference = abs(targetValue - currentValue);
		var points = 100 - difference;
		
		// create an alert
		let title: String;
		if difference == 0 {
			title = "Perfect!";
			points += 100;
		} else if difference < 5 {
			title = "Almost had it!";
			if difference == 1 {
				points += 50;
			}
		} else if difference < 10 {
			title = "Pretty good."
		} else {
			title = "Not even close...";
		}
		// update score
		score += points;
		let msg = "You scored \(points) points!";
		let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert);
		let action = UIAlertAction(title: "OK", style: .default, handler: { _ in self.startNewRound()});
		
		alert.addAction(action);
		present(alert, animated: true, completion: nil);
	}
	
	@IBAction func sliderMoved(_ slider: UISlider) {
		currentValue = lroundf(slider.value);
	}
	
	@IBAction func startNewGame() {
		addHighScore(score);
		score = 0;
		round = 0;
		startNewRound();
	}
	
	func startNewRound() {
		round += 1;
		
		targetValue = Int.random(in: 1...100);
		currentValue = 50;
		slider.value = Float(currentValue);
		
		updateLabels();
	}
	
	func addHighScore(_ score: Int) {
		// make sure score > 0
		guard score > 0 else {
			return;
		}
		
		// create a new high score item
		let highscore = HighScoreItem(name: "Unknown", score: score);
		var highScores = PersistencyHelper.loadHighScores();
		highScores.append(highscore);
		// define sorting func for this data type
		highScores.sort { $0.score > $1.score };
		PersistencyHelper.saveHighScores(highScores);
	}
	
	func updateLabels() {
		targetLabel.text = String(targetValue);
		scoreLabel.text = String(score);
		roundLabel.text = String(round);
	}
}

