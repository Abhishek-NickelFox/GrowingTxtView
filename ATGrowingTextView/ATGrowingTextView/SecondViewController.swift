//
//  SecondViewController.swift
//  ATGrowingTextView
//
//  Created by Abhishek on 22/07/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit

class NewCell: UITableViewCell {
	@IBOutlet weak var titleLabel: UILabel!
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

	@IBOutlet weak var tblView: UITableView!
	@IBOutlet weak var txtView: UITextView!
	@IBOutlet weak var txtHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomContraint: NSLayoutConstraint!
	
	var tableList: [String] = []
	var keyboardFrame: CGRect?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.txtView.delegate = self
		self.tblView.dataSource = self
		self.tblView.delegate = self
		tableList = ["12","13","14","12","13","14","12","13","14"]
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(keyBoardWillShow(notification:)),
		                                       name: NSNotification.Name.UIKeyboardWillShow,
		                                       object: nil)
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(keyBoardWillHide(notification:)),
		                                       name: NSNotification.Name.UIKeyboardWillHide,
		                                       object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	@IBAction func buttonAction(_ sender: Any) {
		if txtView.text.isEmpty { return }
		tableList.append(txtView.text)
		self.tblView.reloadData()
		txtView.text = ""
		self.textViewDidChange(self.txtView)
	}

}

extension SecondViewController {

	//========================================================================================================================================
	// TEXTVIEW DELEGATES
	//========================================================================================================================================
	
	func textViewDidChange(_ textView: UITextView) {
	
		var height:CGFloat = textView.contentSize.height
//		print("HEIGHT \(height)")
//		if height >= 117.0 {
//			txtHeightConstraint.constant = 117.0
//		} else if height >= 50.0 {
//			txtHeightConstraint.constant = height
//		} else {
//			txtHeightConstraint.constant = 50.0
//		}

		if height >= 117.0 {
			height = 117.0
		} else if height < 50.0 {
			height = 50.0
		}
		
		if height != txtHeightConstraint.constant { // AVOIDING MULTIPLE CALL
			txtHeightConstraint.constant = height
			self.view.layoutIfNeeded()
			self.moveTableView()
		}
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return true
	}
	
	//========================================================================================================================================
	
	func moveTableView() {
		let indexPath = IndexPath(row: tableList.count - 1, section: 0)
		self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
	}
	
	//========================================================================================================================================
	// TABLE VIEW DELEGATES
	//========================================================================================================================================
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 66.0
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell2") as! NewCell
		cell.titleLabel?.text = tableList[indexPath.row]
		return cell
	}
	
	func keyBoardWillShow(notification: Notification) {
		
		let userInfo = notification.userInfo!
		let keyValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
		keyboardFrame = keyValue.cgRectValue
		self.bottomContraint.constant = self.view.frame.size.height - (keyboardFrame?.origin.y)!
		UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
			self.view.layoutIfNeeded()
		}) { (flag) in
			self.moveTableView()
		}
	}
	
	func keyBoardWillHide(notification: Notification) {
		self.bottomContraint.constant = 0
		UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
			self.view.layoutIfNeeded()
		}) { (flag) in
			self.moveTableView()
		}
	}
}

/*

//		if (self.tblView.contentSize.height > self.tblView.frame.size.height) {
//			let offset = CGPoint(x: 0, y: self.tblView.contentSize.height - self.tblView.frame.size.height)
//			self.tblView.setContentOffset(offset, animated: true)
//		}


*/
