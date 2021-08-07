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
    var section : [Section] = []
    var sections: Section?
    var isiData : [Isi] = []
    var isiin: Isi?
    
    @IBOutlet weak var isiTableView: UITableView!
    @IBOutlet weak var cueCardName: UILabel!
    
    private var tableCellName : String = "IsiTableViewCell"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewCell()
        configureTableView()
        if let section = sections {
            cueCardName.text = section.part
            load()
        }
    }
    
    private func setTableViewCell(){
        let nib = UINib(nibName: tableCellName, bundle: nil)
        isiTableView.register(nib, forCellReuseIdentifier: tableCellName)
    }
    
    @IBAction func isiAddButton(_ sender: Any) {
        load()
        guard let section1 = sections else {
            print("error author")
            return
        }
        
        let isi = ""
        let strcounter = String(isiData.count + 1)
        let part = "Point \(strcounter)"
        
        CoreDataHelper.shared.setIsi(part: part, isi: isi, section: section1)
        
        print("Data::\(section.count)")
        load()
    }
    
    private func load(){
        guard let section1 = sections else {
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
        if let vc = storyboard?.instantiateViewController(identifier: "IsiKontenViewController") as? IsiKontenViewController {
            vc.sections = sections
            vc.isiin = isiData[indexPath.row]
           
            self.navigationController?.pushViewController(vc, animated: false)
            print("udah")
        }
    }
}
