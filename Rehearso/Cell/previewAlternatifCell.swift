//
//  previewAlternatifCell.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 10/08/21.
//

import UIKit

class previewAlternatifCell: UITableViewCell {

    @IBOutlet weak var judulPreviewCell: UILabel!
    @IBOutlet var kontenPreviewCell: UITextView!
    @IBOutlet var kontenPreviewText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
