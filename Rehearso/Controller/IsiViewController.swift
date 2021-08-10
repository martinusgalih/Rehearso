//
//  IsiViewController.swift
//  Rehearso
//
//  Created by Mohammad Sulthan on 07/08/21.
//

import UIKit

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
        
        setTableViewCell()
        configureTableView()
//        if let section = sections {
//            cueCardName.text = section.part
//            load()
//        }
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
        
//        CoreDataHelper.shared.setIsi(part: part, isi: isi, section: section1)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! IsiTableViewCell
        let isiList = isiData[indexPath.row]
        cell.judulPointLabel.text = isiList.part
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "IsiKontenController") as? IsiKontenController {
            vc.isiin = self.isiData[indexPath.row]
//            vc.isiin = isiin
            vc.sections = section
           
            self.navigationController?.pushViewController(vc, animated: false)
            print("Hasil\(vc.isiin)")
        }
    }
}
