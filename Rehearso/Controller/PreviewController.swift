//
//  PreviewController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 09/08/21.
//

import UIKit

class PreviewController: UIViewController {

    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var previewTableView: UITableView!
    @IBOutlet weak var viewForTableView: UIView!
    
    var cueCard: CueCard?
    var sectionCue: [Section] = []
    var isiCue: [Isi] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewTableView.delegate = self
        previewTableView.dataSource = self
        
        self.load()
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func load() {
        sectionCue = CoreDataHelper.shared.fetchSection(cueCard: cueCard!)
        previewTableView.reloadData()
    }
    
//    func loadIsi() {
//        isiCue = CoreDataHelper.shared.fetchIsi(section: sectionCue)
//    }
}

extension PreviewController: UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate{
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sectionsPreview[section].expanded = !sectionsPreview[section].expanded
        
        previewTableView.reloadRows(at: [IndexPath(row: 1, section: section)], with: .automatic)
        previewTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sec = self.sectionCue[section]
        return sec.part
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewCell") as! PreviewCell
        
        let section = sectionCue[indexPath.section]
//        cell.subTitleCell.text = section.isi
        
        cell.layer.borderColor = UIColor.white.cgColor
//        cell.layer.borderWidth = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sectionsPreview[section].title, section: section, delegate: self)
        header.backgroundView = .none
        header.backgroundColor = .red
        
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 2, dy: 2)
        maskLayer.backgroundColor = UIColor.white.cgColor
        cell.layer.mask = maskLayer
    }
    
    
}

