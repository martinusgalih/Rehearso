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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewDashboard.dropShadow()
        
        let nib = UINib(nibName: "DataCell", bundle: nil)
        tableViewRecents.register(nib, forCellReuseIdentifier: "dataCell")
        
        tableViewRecents.delegate = self
        tableViewRecents.dataSource = self
    }
}

extension DashboardController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDummyRecent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRecents = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataCell
        
        let dataDummyX = dataDummyRecent[indexPath.row]
        cellRecents.cueCardNama.text = dataDummyX.judul
        cellRecents.bulanPresent.text = dataDummyX.blnPresentasi
        cellRecents.tanggalPresent.text = dataDummyX.tglPresentasi
        cellRecents.tanggalCueCard.text = dataDummyX.tglBuatCueCard
        cellRecents.waktuCueCard.text = dataDummyX.wktBuatCueCard
        
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
    
}

extension UIView{
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
