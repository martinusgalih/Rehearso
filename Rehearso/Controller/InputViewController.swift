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
        if let isiKonten = isiKonten {
            titleLabel.text = isiKonten.title
            inputText.text = isiKonten.content
            
           
            
        }

    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        isiKonten?.title = titleLabel.text
        isiKonten?.content = inputText.text
        CoreDataHelper.shared.save{
            print("Berhasil Save")
//            self.load()
            print("Berhasil")
//            let vc = self.storyboard?.instantiateViewController(identifier: "IsiKontenController") as? IsiKontenController
//            vc!.isiin = self.isiin
//            vc!.viewDidLoad()
            self.navigationController?.popViewController(animated: true)
    //        navigationController?.pushViewController(vc!, animated: false)
    //        dismiss(animated: false, completion: nil)
        }
        
            
    }
//    private func load(){
//        guard let isi = isiin else {
//            print("error load")
//            return
//        }
//        konten = CoreDataHelper.shared.fetchIsiKonten(isi: isi)
//        print("Print konten\(isiKonten?.content)")
//        print("Print konten\(konten[0].content)")
//    }

}
