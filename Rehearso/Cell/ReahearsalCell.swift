//
//  ReahearsalCell.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 05/08/21.
//

import UIKit

class ReahearsalCell: UITableViewCell {

    @IBOutlet weak var labelRehearsalKe: UILabel!
    @IBOutlet weak var tanggalRehearsal: UILabel!
    @IBOutlet weak var waktuRehearsal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
