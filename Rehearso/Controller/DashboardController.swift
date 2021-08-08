//
//  DashboardController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 04/08/21.
//

import UIKit

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
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
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
        dateFormatter.dateFormat = "LLLL"
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
        
        print(duration)
        let minutes = (duration % 3600) / 60
        let seconds = (duration % 3600) % 60
        
        
        // binding data to table
        cellRecents.cueCardNama.text = cueCard.name
        cellRecents.bulanPresent.text = monthPresentation
        cellRecents.tanggalPresent.text = dayPresentation
        cellRecents.tanggalCueCard.text = datePresentation
        cellRecents.waktuCueCard.text = ("Duration \(minutes):\(seconds)")
        
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
            self.navigationController?.pushViewController(vc, animated: false)
            print("udah")
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
