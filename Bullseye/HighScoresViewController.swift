//
//  HighScoresViewController.swift
//  Bullseye
//
//  Created by Andy Mina on 8/15/21.
//

import UIKit

class HighScoresViewController: UITableViewController, EditHighScoreViewControllerDelegate {
	
	var items: [HighScoreItem] = [HighScoreItem]();

	override func viewDidLoad() {
		super.viewDidLoad();
		// init items with saved data
		items = PersistencyHelper.loadHighScores();
		if items.count == 0 {
			resetHighScores();
		}
	}
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // grab the VC we want
    let controller = segue.destination as! EditHighScoreViewController;
    // set this class as the delegate for the target VC
    controller.delegate = self;
    
    // grab the indexPath if it exists and pass it to child
    if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
      controller.highScoreItem = items[indexPath.row];
    }
  }

	// MARK: Table View Data Source
	/**
		@desc: There is one section in the table.
	*/
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1;
	}
	
	/**
		@desc: The table should display 5 rows in one section.
	*/
	override func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return items.count;
	}
	
	/**
		@desc: renders an actual cell in the table
	*/
	override func	tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		// grab the cell to be reused
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "HighScoreItem",
			for: indexPath
		);
		
		// grab the data
		let item = items[indexPath.row];
		
		// grab the labels by their tags
		let nameLabel = cell.viewWithTag(1000) as! UILabel;
		let scoreLabel = cell.viewWithTag(2000) as! UILabel;
		
		// update the labels
		nameLabel.text = item.name;
		scoreLabel.text = String(item.score);
		
		return cell;
	}
	
	// MARK: Table View Delegate
	/**
		@desc: handles the onclick logic of a row
	*/
	override func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		tableView.deselectRow(at: indexPath, animated: true);
	}
	
	/**
		@desc: swipe to delete
	*/
	override func tableView(
		_ tableView: UITableView,
		commit edtingStyle: UITableViewCell.EditingStyle,
		forRowAt indexPath: IndexPath
	) {
		// remove the data
		items.remove(at: indexPath.row);
		
		// remove the row
		let indexPaths = [indexPath];
		tableView.deleteRows(at: indexPaths, with: .automatic)
		
		// update the db
		PersistencyHelper.saveHighScores(items);
	}
  
  // MARK: EditHighScoreVC Delegate
  func editHighScoreVCDidCancel(_ controller: EditHighScoreViewController) {
    navigationController?.popViewController(animated: true);
  }
  
  func editHighScoreVC(
    _ controller: EditHighScoreViewController,
    didFinishEditing item: HighScoreItem
  ) {
    // grab the index of the item in HighScores[]
    if let index = items.firstIndex(of: item) {
      // update the indexPaths
      let indexPaths = [IndexPath(row: index, section: 0)];
      // reload the targeted rows
      tableView.reloadRows(at: indexPaths, with: .automatic);
    }
    PersistencyHelper.saveHighScores(items);
    navigationController?.popViewController(animated: true);
  }
	
	// MARK: IBActions
	@IBAction func resetHighScores() {
		// reset the array
		items = [HighScoreItem]();
		
		// add data
		items.append(HighScoreItem(name: "Andy", score: 500));
		items.append(HighScoreItem(name: "Sabina", score: 250));
		items.append(HighScoreItem(name: "Sydney", score: 125));
		items.append(HighScoreItem(name: "Lina", score: 75));
		items.append(HighScoreItem(name: "Rasul", score: 50));
		
		// update the db
		PersistencyHelper.saveHighScores(items);
		
		// reload
		tableView.reloadData();
	}
}
