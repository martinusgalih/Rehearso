//
//  SectionEditorController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 05/08/21.
//

import UIKit

class SectionEditorController: UIViewController {

    @IBOutlet weak var viewSectionData: UIView!
    @IBOutlet weak var viewIntro: UIView!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewConclusion: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewSectionData.dropShadow()
        viewIntro.dropShadow()
        viewBody.dropShadow()
        viewConclusion.dropShadow()
    }
}
