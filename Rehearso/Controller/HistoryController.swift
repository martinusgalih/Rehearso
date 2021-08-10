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
    var rehearsal : [Rehearsal] = []
    let fileManager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
        if let cueCard = cueCardUpdate {
            // convert cueCard.date string to date object
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"

            let date = dateFormatter.date(from: cueCard.date!)

            labelTanggalCueCard.text = "\(date!)"
            labelNamaCueCard.text = cueCard.name
            waktuBuatCueCard.text = cueCard.date
        }

        configureTableView()
        viewEdit.dropShadow()
        viewHistory.dropShadow()
        viewPreview.dropShadow()
        viewRehearse.dropShadow()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.load()
    }

    private func load(){
        rehearsal = CoreDataHelper.shared.fetchRehearsal(cueCard: cueCardUpdate!)
        self.tableViewRehearsal.reloadData()
    }

    private func setTableViewCell() {
        let nib = UINib(nibName: "ReahearsalCell", bundle: nil)
        tableViewRehearsal.register(nib, forCellReuseIdentifier: "rehearsalCell")
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
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func getFileURL(audioName: String) -> URL {
        let path = getDocumentsDirectory().appendingPathComponent(audioName)
        return path as URL
    }
}

extension HistoryController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rehearsal.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rehearsalCell", for: indexPath) as! ReahearsalCell

        let rehearsal = rehearsal[indexPath.row]

        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        let datee = formatter.string(from: rehearsal.timestamp!)


        cell.labelRehearsalKe.text = rehearsal.name
        cell.tanggalRehearsal.text = "\(datee)"
        cell.waktuRehearsal.text = "Durasi: \(String(format: "%.2f", rehearsal.duration)) detik"

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
        let selectedRehearsal = rehearsal[indexPath.row]
        if let vc = storyboard?.instantiateViewController(identifier: "PlayRehearsalController") as? PlayRehearsalViewController {
            vc.rehearsal = selectedRehearsal
            vc.cueCard = cueCardUpdate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in

            let selectedRehearsal = self.rehearsal[indexPath.row]
            // Remove the menu option from the screen
            self.deleteRehearsal(rehearsal: selectedRehearsal)
            completionHandler(true)
        }

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        // Delete should not delete automatically
        swipeConfiguration.performsFirstActionWithFullSwipe = false

        return swipeConfiguration
    }

    func deleteRehearsal(rehearsal: Rehearsal) {
        let alert = UIAlertController(title: "Hapus rehearsal", message: "Yakin mau hapus rehearsal in?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: { _ in
//            CoreDataHelper.shared.deleteRehearsal(rehearsal: rehearsal)
            let audio = rehearsal.audioName

            // remove file
            do {
                print(type(of: self.getFileURL(audioName: audio!)))
                try self.fileManager.removeItem(at: self.getFileURL(audioName: audio!))
                self.load()
            } catch is NSError {
                print("error remove file")
            }
        }))

        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}
