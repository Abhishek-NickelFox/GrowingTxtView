//
//  ViewController.swift
//  ATGrowingTextView
//
//  Created by Abhishek on 28/04/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet weak var cellTitleLabel: UILabel!
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var textUIView: UIView!
    
    @IBOutlet weak var textUIViewHeightConstraint: NSLayoutConstraint!
    
    var heightConstant: CGFloat?
    var tableList: [String]?
    var baseText: String?
    
    var keyboardFrame: CGRect?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.txtView.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        
        tableList = ["12","13","14","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","13","13","13"]
        
        heightConstant = self.textUIViewHeightConstraint.constant
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //========================================================================================================================================
    // TEXT VIEW DELEGATE
    //========================================================================================================================================
    
    func getTextSize(text: String, maxWidth: CGFloat, fontName: String, fontSize: CGFloat) -> CGSize {
        
        let constraintSize = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        let attributes = [NSFontAttributeName : UIFont(name: fontName, size: fontSize)]
        let frame = (text as NSString).boundingRect(with: constraintSize,
                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                    attributes: attributes as Any as? [String : Any],
                                                    context: nil)
        return frame.size;
    }
    
    func textViewDidChange(_ textView: UITextView) {

        let txtSize = self.getTextSize(text: txtView.text,
                                       maxWidth: txtView.frame.size.width - 16,
                                       fontName: (txtView.font?.fontName)!,
                                       fontSize: (txtView.font?.pointSize)!)
        
        textUIViewHeightConstraint.constant = txtSize.height + 40
        
        if (textUIViewHeightConstraint.constant < heightConstant!) {
            textUIViewHeightConstraint.constant = heightConstant!
            textView.isScrollEnabled = false
        }
        else if (textUIViewHeightConstraint.constant > heightConstant! * 2.5) {
            textUIViewHeightConstraint.constant = heightConstant! * 2.5
            textView.isScrollEnabled = true
        }
    
        UIView.animate(withDuration: CATransaction.animationDuration()) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func moveTableView() {
        let indexPath = IndexPath(row: (tableList?.count)! - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func sendMethod() {
        tableList?.append(txtView.text)
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.moveTableView()
        }
    }
    
    @IBAction func sendAction(_ sender: Any) {
        sendMethod()
    }
    
    //========================================================================================================================================
    // TABLE VIEW DELEGATES
    //========================================================================================================================================
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
        tableCell.cellTitleLabel.text = tableList?[indexPath.row]
        return tableCell
    }
    
    func keyBoardWillShow(notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboardFrame = keyValue.cgRectValue
        
        self.bottomConstraint.constant = self.view.frame.size.height - (keyboardFrame?.origin.y)!
        
        CATransaction.animationDuration()
        
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            self.view.layoutIfNeeded()
        }) { (flag) in
           self.moveTableView()
        }
    }
    
    func keyBoardWillHide(notification: Notification) {
    
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
