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
    }
    
    @IBAction func previewButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PreviewAlternatifViewController") as? PreviewAlternatifViewController
        vc?.cueCard = cueCardUpdate
        self.navigationController?.pushViewController(vc!, animated: false)
        
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
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 2, dy: 4)
        maskLayer.backgroundColor = UIColor.white.cgColor
        cell.layer.mask = maskLayer
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(identifier: "IsiViewController") as? IsiViewController
            vc!.section = self.sectionData[indexPath.row]
            print("Index Nich\(self.sectionData[indexPath.row])")
            self.navigationController?.pushViewController(vc!, animated: false)
            print("udah")
        } else if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(identifier: "IsiKontenViewController") as? IsiKontenViewController
            vc?.index = 0
            vc!.sections = self.sectionData[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: false)
            print("udah")
        } else if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(identifier: "IsiKontenViewController") as? IsiKontenViewController
            vc?.index = 1
            vc!.sections = self.sectionData[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: false)
            print("udah")
        }
    }
}
