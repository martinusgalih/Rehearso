//
//  IsiViewController.swift
//  Rehearso
//
//  Created by Mohammad Sulthan on 07/08/21.
//

import UIKit
import CoreData

class IsiViewController: UIViewController {
    
    var cueCard : [CueCard] = []
    var cueCardUpdate: CueCard?
    var sectionData : [Section] = []
    var section: Section?
    var isiData : [Isi] = []
    var isiin: Isi?
    
    var isiKonten : [IsiKonten] = []
    var isiinKonten: IsiKonten?
    
    @IBOutlet weak var isiTableView: UITableView!
    @IBOutlet weak var cueCardName: UILabel!
    
    private var tableCellName : String = "IsiTableViewCell"


    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        setTableViewCell()
        configureTableView()

    }
    
    private func setTableViewCell(){
        let nib = UINib(nibName: tableCellName, bundle: nil)
        isiTableView.register(nib, forCellReuseIdentifier: tableCellName)
    }
    
    @IBAction func isiAddButton(_ sender: Any) {
        load()
        guard let section1 = section else {
            print("error author")
            return
        }
        
        let isi = ""
        let strcounter = String(isiData.count + 1)
        let part = "Point \(strcounter)"
        CoreDataHelper.shared.setIsi(part: part, title: isi, content: isi, example: isi, section: section1)
        load()
        print("IsiKonten\(isiKonten.count)")
        
    }
    
    private func load(){
        guard let section1 = section else {
            print("error load")
            return
        }
        isiData = CoreDataHelper.shared.fetchIsi(section: section1)
        isiTableView.reloadData()
    }
}

extension IsiViewController : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView(){
        isiTableView.delegate = self
        isiTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isiData.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 2, dy: 4)
        maskLayer.backgroundColor = UIColor.white.cgColor
        cell.layer.mask = maskLayer
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! IsiTableViewCell
        let isiList = isiData[indexPath.row]
        cell.judulPointLabel.text = isiList.part
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isiTableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "IsiKontenController") as? IsiKontenController {
            vc.isiin = self.isiData[indexPath.row]
            vc.sections = section
            self.navigationController?.pushViewController(vc, animated: false)
            print("Hasil\(vc.isiin)")
        }
    }
}
