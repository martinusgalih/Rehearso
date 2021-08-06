//
//  DataCell.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 04/08/21.
//

import UIKit

class DataCell: UITableViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var viewTglBln: UIView!
    @IBOutlet weak var bulanPresent: UILabel!
    @IBOutlet weak var tanggalPresent: UILabel!
    @IBOutlet weak var cueCardNama: UILabel!
    @IBOutlet weak var tanggalCueCard: UILabel!
    @IBOutlet weak var waktuCueCard: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewCell.backgroundColor = .white
        viewCell.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
