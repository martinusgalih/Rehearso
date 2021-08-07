//
//  IsiKontenViewController.swift
//  Rehearso
//
//  Created by Mohammad Sulthan on 07/08/21.
//

import UIKit


// formerly known as Isi2ViewController
class IsiKontenViewController: UIViewController {
    
    var isiData : [Isi] = []
    var isiin: Isi?
    var section : [Section] = []
    var sections: Section?

    @IBOutlet weak var kontenText: UITextView!
    @IBOutlet weak var pointTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MASUK")
        if let isiin = isiin {
            pointTitleLabel.text = isiin.part
            kontenText.text = isiin.isi
            
            load()
        }
    }
    
    private func load(){
        guard let section1 = sections else {
            print("error load")
            return
        }
        
        isiData = CoreDataHelper.shared.fetchIsi(section: section1)
    }
}
