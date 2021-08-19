//
//  InputViewController.swift
//  Rehearso
//
//  Created by Martinus Galih Widananto on 09/08/21.
//

import UIKit
import CoreData

class InputViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var inputText: UITextView!
    var konten: [IsiKonten] = []
    var isiKonten: IsiKonten?
    var isiin: Isi?

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeybardWhenTappedAround()
        inputText.layer.cornerRadius = 10
        
        if let isiKonten = isiKonten {
            titleLabel.text = isiKonten.title
            inputText.text = isiKonten.content
        }
    }

    @IBAction func saveButton(_ sender: Any) {
        isiKonten?.title = titleLabel.text
        isiKonten?.content = inputText.text
        CoreDataHelper.shared.save{
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension UIViewController {
    func hideKeybardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension InputViewController {
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputText.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
