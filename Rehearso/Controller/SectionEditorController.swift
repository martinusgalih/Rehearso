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
    @IBOutlet weak var sectionTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var sectionData : [Section] = []
    var section: Section?
    var cueCard : [CueCard] = []
    var cueCardUpdate: CueCard?
    var titleVC: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTableView.delegate = self
        sectionTableView.dataSource = self
        titleLabel.text = titleVC
        guard let cueCard2 = cueCardUpdate else {
            print("error cueCard")
            return
        }
        print("Hasil Jumlah\(sectionData.count)")
        
        load()
        
        
        viewSectionData.dropShadow()
//        viewIntro.dropShadow()
//        viewBody.dropShadow()
//        viewConclusion.dropShadow()
    }
    
    private func load(){
        guard let cueCard = cueCardUpdate else {
            print("error load")
            return
        }
        
        sectionData = CoreDataHelper.shared.fetchSection(cueCard: cueCard)
        sectionTableView.reloadData()
    }
}

extension SectionEditorController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sectionData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "section") as! SectionTableViewCell
        let section = sectionData[indexPath.row]
        print("Hasil part\(section.part)")
        cell.sectionLabel.text = section.part
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "IsiViewController") as? IsiViewController {
            vc.section = self.sectionData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: false)
            print("udah")
        }
    }
}
