//
//  InputViewController.swift
//  Rehearso
//
//  Created by Martinus Galih Widananto on 09/08/21.
//

import UIKit

class InputViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var inputText: UITextView!
    var konten: [IsiKonten] = []
    var isiKonten: IsiKonten?
    var isiin: Isi?

    override func viewDidLoad() {
        super.viewDidLoad()
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
