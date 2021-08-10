//
//  PreviewAlternatifViewController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 10/08/21.
//

import UIKit

class PreviewAlternatifViewController: UIViewController {

    @IBOutlet weak var previewAlternatif: UITableView!
    
    var titleOfPagePreview: [String] = ["Grab Attention","Reason To Listen","State Topic","Credibility Statement","Preview Statement"]
    
    var isiTextPreview: [String] = ["WKWKWKWKWKWKWKWKWKWKWKWK","HAHAAHAHAHAHAHAHHA","LALALLALALLAALLALAAL","PAPAPAPAPAPPAPA","WAWAWWAWAWAWAWAW"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        previewAlternatif.delegate = self
        previewAlternatif.dataSource = self
    }
}

extension PreviewAlternatifViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleOfPagePreview.count
        return isiTextPreview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewAlternatifCell", for: indexPath) as! previewAlternatifCell
        
        
        cell.judulPreviewCell.text = titleOfPagePreview[indexPath.row]
        cell.kontenPreviewCell.text = isiTextPreview[indexPath.row]
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 2, dy: 2)
        maskLayer.backgroundColor = UIColor.white.cgColor
        cell.layer.mask = maskLayer
    }
    
    
}
