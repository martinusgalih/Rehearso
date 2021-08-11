//
//  DashboardController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 04/08/21.
//

import UIKit
import CoreData

class DashboardController: UIViewController {

    @IBOutlet weak var tableViewRecents: UITableView!
    @IBOutlet weak var viewStartScripting: UIView!
    @IBOutlet weak var viewDashboard: UIView!
    
    var sectionData : [Section] = []
    var section: Section?
    var cueCard : [CueCard] = []
    var cueCardUpdate: CueCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        viewDashboard.dropShadow()
        setTableViewCell()
        configureTableView()
        
        navigationItem.hidesBackButton = true
    }
    
    private func load(){
        cueCard = CoreDataHelper.shared.fetchCueCard()
        self.tableViewRecents.reloadData()
    }
    
    private func setTableViewCell(){
        let nib = UINib(nibName: "DataCell", bundle: nil)
        tableViewRecents.register(nib, forCellReuseIdentifier: "dataCell")
    }
    
    func configureTableView(){
        tableViewRecents.delegate = self
        tableViewRecents.dataSource = self
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

extension DashboardController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cueCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellRecents = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataCell
        
        let cueCard = cueCard[indexPath.row]
        
        // convert cueCard.date string to date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+07:00")
        guard let date = dateFormatter.date(from: cueCard.date!) else {
            fatalError()
        }
        
        // month formatter
        dateFormatter.dateFormat = "LLL"
        let monthPresentation = dateFormatter.string(from: date)
        
        // date formatter
        dateFormatter.dateFormat = "dd"
        let dayPresentation = dateFormatter.string(from: date)
        
        // date
        dateFormatter.dateFormat = "d MMMM yyyy"
        let datePresentation = dateFormatter.string(from: date)
        

        // convert duration second to hour, minute, second
        let preVal = (cueCard.length! as NSString).doubleValue
        let duration = Int(preVal)
        
        let minutes = (duration % 3600) / 60
        let seconds = (duration % 3600) % 60
        
        // binding data to table
        cellRecents.cueCardNama.text = cueCard.name
        cellRecents.bulanPresent.text = monthPresentation
        cellRecents.tanggalPresent.text = dayPresentation
        cellRecents.tanggalCueCard.text = datePresentation
        cellRecents.waktuCueCard.text = ("Duration \(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
        
        cellRecents.layer.borderColor = UIColor.white.cgColor
        cellRecents.layer.borderWidth = 1
        cellRecents.layer.cornerRadius = 12
        cellRecents.clipsToBounds = true
        return cellRecents
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 2, dy: 4)
        maskLayer.backgroundColor = UIColor.white.cgColor
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewRecents.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "HistoryController") as? HistoryController {
            vc.cueCardUpdate = self.cueCard[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in

            let selectedCueCard = self.cueCard[indexPath.row]
            // Remove the menu option from the screen
            self.deleteCueCard(cue: selectedCueCard)
            completionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        // Delete should not delete automatically
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
    
    func deleteCueCard(cue: CueCard) {
        let alert = UIAlertController(title: "Hapus cue card", message: "Yakin mau hapus data cue card in?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: { _ in
            CoreDataHelper.shared.deleteCueCard(cueCard: cue)
            self.notifyUser(title: "Cue card deleted", message: "Your cue card successfully deleted")
            self.load()
        }))
        
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func notifyUser(title: String, message: String) -> Void {
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
      present(alert, animated: true, completion: nil)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
       self.dismiss(animated: true)
      }
    }
}

extension UIView {
    func dropShadow(scale: Bool = true){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 5
        
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
