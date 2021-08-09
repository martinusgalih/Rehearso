//
//  IsiKontenController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 09/08/21.
//

import UIKit

class IsiKontenController: UIViewController {

    @IBOutlet weak var judulKonten: UILabel!
    @IBOutlet weak var exampleKonten: UILabel!
    @IBOutlet weak var textInputKonten: UITextView!
    @IBOutlet weak var isiKontenCollectionView: UICollectionView!

    var titleOfPage: [String] = ["Grab Attention","Reason To Listen","State Topic","Credibility Statement","Preview Statement"]

    var examples: [String] = ["Morgan robertson once wrote a book called The Wreck Of Titan.","Morgan robertson once wrote a book called The Wreck Of Titan.","Morgan robertson once wrote a book called The Wreck Of Titan.","Morgan robertson once wrote a book called The Wreck Of Titan.","Morgan robertson once wrote a book called The Wreck Of Titan."]

    var isiText: [String] = ["Do or say something shocking, intriguing, or dramatic to get attention of the audience from the very first minutes.","Give the audience a reason why your presentation is relevant / worth listening to","Announce what your speech is about, and your position.","What have you done prior to the presentation that is relevant to the credibility of your presentation","Introduce main points of your speech."]

    override func viewDidLoad() {
        super.viewDidLoad()

        isiKontenCollectionView.delegate = self
        isiKontenCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isiKontenCollectionView.reloadData()
    }
}

extension IsiKontenController: UICollectionViewDelegate, UICollectionViewDataSource{

    //size cell
    func collectionView(_ collectionView: UICollectionView, layout cogllectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.size.width)
        let itemHeight = (collectionView.frame.size.height)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    // spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleOfPage.count
        return examples.count
        return isiText.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "isiKontenCell", for: indexPath) as! EditDataCollectionViewCell

        cell.kontenTitleLabel.text = titleOfPage[indexPath.row]
        cell.exampleKonten.text = examples[indexPath.row]
        cell.kontenTextView.text = isiText[indexPath.row]

        return cell
    }
}
