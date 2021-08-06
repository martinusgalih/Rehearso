//
//  NewCueCardController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 04/08/21.
//

import UIKit

class NewCueCardController: UIViewController {

    @IBOutlet weak var viewPresentationData: UIView!
    @IBOutlet weak var tfPresentationName: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var tfDateOfPresentation: UITextField!
    @IBOutlet weak var syncToCalender: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewPresentationData.dropShadow()
    }
    @IBAction func btnCreatePresentation(_ sender: Any) {
    }
}
