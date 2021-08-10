//
//  IsiTableViewCell.swift
//  Rehearso
//
//  Created by Mohammad Sulthan on 07/08/21.
//

import UIKit

class IsiTableViewCell: UITableViewCell {
    @IBOutlet weak var judulPointLabel: UILabel!
    @IBOutlet var viewButton: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewButton.layer.masksToBounds = false
        viewButton.layer.shadowColor = UIColor.black.cgColor
        viewButton.layer.shadowOpacity = 0.5
        viewButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewButton.layer.shadowRadius = 1

        viewButton.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        viewButton.layer.shouldRasterize = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
