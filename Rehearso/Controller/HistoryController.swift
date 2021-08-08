//
//  HistoryController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 05/08/21.
//

import UIKit

class HistoryController: UIViewController {

    @IBOutlet weak var labelNamaCueCard: UILabel!
    @IBOutlet weak var labelTanggalCueCard: UILabel!
    @IBOutlet weak var waktuBuatCueCard: UILabel!
    @IBOutlet weak var viewHistory: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var viewRehearse: UIView!
    @IBOutlet weak var tableViewRehearsal: UITableView!
    var cueCard : [CueCard] = []
    var cueCardUpdate: CueCard?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let cueCard = cueCardUpdate {
            labelNamaCueCard.text = cueCard.name
            labelTanggalCueCard.text = cueCard.date
            waktuBuatCueCard.text = cueCard.date
//            load()
        }
        viewEdit.dropShadow()
        viewHistory.dropShadow()
        viewPreview.dropShadow()
        viewRehearse.dropShadow()

    }
//    private func load(){
//        cueCard = CoreDataHelper.shared.fetchCueCard()
//        self.tableViewRehearsal.reloadData()
//    }

    private func setTableViewCell() {
        let nib = UINib(nibName: "ReahearsalCell", bundle: nil)
        tableViewRehearsal.register(nib, forCellReuseIdentifier: "reahearsalCell")
    }

    func configureTableView() {
        tableViewRehearsal.delegate = self
        tableViewRehearsal.dataSource = self
    }
    
    @IBAction func startRehearseButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "StartRehearsalController") as? StartRehearsalViewController {
            vc.cueCard = cueCardUpdate
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true)
        }
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is StartRehearsalViewController {
//            let vc = segue.destination as? StartRehearsalViewController
//
//        }
//    }
}

extension HistoryController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDummyRecent.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reahearsalCell", for: indexPath) as! ReahearsalCell

        cell.labelRehearsalKe.text = "Rehearsal 1"
        cell.tanggalRehearsal.text = "21/02/21"
        cell.waktuRehearsal.text = "01:23:45"

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
        if let vc = storyboard?.instantiateViewController(identifier: "PlayRehearsalController") as? PlayRehearsalViewController {
            print(cueCard)
//            vc.cueCard = self.dataDummyRecent[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
