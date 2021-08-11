//
//  PreviewAlternatifViewController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 10/08/21.
//

import UIKit

class PreviewAlternatifViewController: UIViewController {
    var sections : [Section] = []
    var section: Section?
    var cueCards : [CueCard] = []
    var cueCard: CueCard?
    var isii : [Isi] = []
    var isi: Isi?
    var kontensA: [IsiKonten] = []
    var kontensB: [IsiKonten] = []
    var kontensC: [IsiKonten] = []
    var kontensD: [IsiKonten] = []
    var konten: IsiKonten?
    var gabungan: [IsiKonten]  = []
    
    @IBOutlet weak var previewAlternatif: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Tipe\(type(of: kontensA))")
        guard let cueCard = cueCard else {
            print("error load")
            return
        }
        sections = CoreDataHelper.shared.fetchSection(cueCard: cueCard)
        Intro()
        Body()
        Conclusion()
    
        
        gabungan = kontensA
        gabungan.insert(contentsOf: kontensD, at: gabungan.count)
        gabungan.insert(contentsOf: kontensB, at: gabungan.count)
        previewAlternatif.delegate = self
        previewAlternatif.dataSource = self
    }
    func Intro () {
        isii = CoreDataHelper.shared.fetchIsi(section: sections[0])
        isi = isii[0]
        kontensA = CoreDataHelper.shared.fetchIsiKonten(isi: isi ?? isii[0]) {}
    }
    func Body () {
        isii = CoreDataHelper.shared.fetchIsi(section: sections[1])
        for n in 0...isii.count - 1 {
            kontensC = CoreDataHelper.shared.fetchIsiKonten(isi: isii[n]) {}
            self.kontensD.insert(contentsOf: self.kontensC, at: kontensD.count)
        }
    }
    func Conclusion () {
        isii = CoreDataHelper.shared.fetchIsi(section: sections[2])
        isi = isii[0]
        kontensB = CoreDataHelper.shared.fetchIsiKonten(isi: isi ?? isii[0]) {}
    }
    private func load(){
        guard let isi = isi else {
            print("error load load")
            return
        }
        kontensA = CoreDataHelper.shared.fetchIsiKonten(isi: isi) {}
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension PreviewAlternatifViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gabungan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewAlternatifCell", for: indexPath) as! previewAlternatifCell
        let kontens = gabungan[indexPath.row]
        cell.judulPreviewCell?.text = kontens.title
        cell.kontenPreviewText.text = kontens.content
        print("Nih\(kontens.content)")
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let maskLayer = CALayer()
//        maskLayer.cornerRadius = 5
//        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 2, dy: 2)
//        maskLayer.backgroundColor = UIColor.white.cgColor
//        cell.layer.mask = maskLayer
    }
    
    
}
