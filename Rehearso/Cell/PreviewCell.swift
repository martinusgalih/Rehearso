//
//  PreviewCell.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 09/08/21.
//

import UIKit

class PreviewCell: UITableViewCell {

    @IBOutlet weak var hasilPreview: UIView!
    @IBOutlet weak var isiLabel: UILabel!
    @IBOutlet var judulLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
