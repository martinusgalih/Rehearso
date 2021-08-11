//
//  EditDataCollectionViewCell.swift
//  Rehearso
//
//  Created by Martinus Galih Widananto on 08/08/21.
//

import UIKit

class EditDataCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var kontenTitleLabel: UILabel!
    @IBOutlet weak var exampleTextView: UITextView!
    @IBOutlet weak var kontenTextView: UITextView!
    

    override func awakeFromNib() {
        kontenTextView.layer.cornerRadius = 10
    }
    
    func setDataIntoCell(data: Isi){
        print("set data : \(data)")
        kontenTitleLabel.text = data.part
        kontenTextView.text = data.content
        exampleTextView.text = data.example
    }
}
