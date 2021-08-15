//
//  EditHighScoreViewController.swift
//  Bullseye
//
//  Created by Andy Mina on 8/15/21.
//

import UIKit

protocol EditHighScoreViewControllerDelegate: class {
  func editHighScoreVCDidCancel(
    _ controller: EditHighScoreViewController
  );
  
  func editHighScoreVC(
    _ controller: EditHighScoreViewController,
    didFinishEditing item: HighScoreItem
  );
}

class EditHighScoreViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  weak var delegate: EditHighScoreViewControllerDelegate?;
  var highScoreItem: HighScoreItem!;
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textField.text = highScoreItem.name;
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    textField.becomeFirstResponder();
  }
  
  // MARK: Table View Delegate
  override func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath
  ) -> IndexPath? {
    return nil;
  }
  
  // MARK: Text Field Delegate
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    let oldText = textField.text!;
    let stringRange = Range(range, in: oldText)!;
    let newText = oldText.replacingCharacters(in: stringRange, with: string);
    
    doneBarButton.isEnabled = !newText.isEmpty;
    
    return true;
  }
  
  // MARK: IBActions
  @IBAction func cancel() {
    delegate?.editHighScoreVCDidCancel(self);
  }
  
  @IBAction func done() {
    // set the new name
    highScoreItem.name = textField.text!;
    delegate?.editHighScoreVC(self, didFinishEditing: highScoreItem);
  }
  
}
