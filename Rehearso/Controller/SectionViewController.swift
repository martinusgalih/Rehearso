//
//  SectionViewController.swift
//  Rehearso
//
//  Created by Mohammad Sulthan on 07/08/21.
//

import UIKit

class SectionViewController: UIViewController {

    var sectionData : [Section] = []
    var section: Section?
    var cueCard : [CueCard] = []
    var cueCardUpdate: CueCard?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let cueCard = cueCardUpdate {
            titleLabel.text = cueCard.name
            
            load()
            
        }
        guard let cueCard2 = cueCardUpdate else {
                        print("error cueCard")
                        return
        }
        CoreDataHelper.shared.setSection(part: "Introduction", cueCard: cueCard2)
        CoreDataHelper.shared.setSection(part: "Body", cueCard: cueCard2)
        CoreDataHelper.shared.setSection(part: "Conclusion", cueCard: cueCard2)
        print("Hasil\(cueCard.count)")
        load()
    }
    private func load(){
        guard let cueCard = cueCardUpdate else {
            print("error load")
            return
        }
        
        sectionData = CoreDataHelper.shared.fetchSection(cueCard: cueCard)
        tableView.reloadData()
    }


}

extension SectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "section") as! SectionTableViewCell
        let section = sectionData[indexPath.row]
        cell.sectionLabel.text = section.part
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(identifier: "IsiViewController") as? IsiViewController {
//            vc.sections = self.sectionData[indexPath.row]
//            self.navigationController?.pushViewController(vc, animated: false)
//            print("udah")
//        }
//    }
    
    
}

