//
//  IsiKontenViewController.swift
//  Rehearso
//
//  Created by Mohammad Sulthan on 07/08/21.
//

import UIKit


// formerly known as Isi2ViewController
class IsiKontenViewController: UIViewController {
    
    var isiData : [Isi] = []
    var isiin: Isi?
    var section : [Section] = []
    var sections: Section?

    @IBOutlet weak var kontenText: UITextView!
    @IBOutlet weak var pointTitleLabel: UILabel!
    @IBOutlet weak var kontenCollectionView: UICollectionView!
    private var tableCellName : String = "EditDataCollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        kontenCollectionView.delegate = self
        kontenCollectionView.dataSource = self
        load()
    }
    private func setTableViewCell(){
        let nib = UINib(nibName: tableCellName, bundle: nil)
        kontenCollectionView.register(nib, forCellWithReuseIdentifier: tableCellName)
    }
    private func load(){
        guard let section1 = sections else {
            print("error load")
            return
        }
        
        isiData = CoreDataHelper.shared.fetchIsi(section: section1)
    }
}

extension IsiKontenViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isiData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditDataCollectionViewCell", for: indexPath) as! EditDataCollectionViewCell
        let isiList = isiData[indexPath.row]
        cell.kontenTitleLabel.text = isiList.part
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditDataCollectionViewCell", for: indexPath) as! EditDataCollectionViewCell
        let isiList = isiData[indexPath.row]
        isiin?.part = cell.kontenTitleLabel.text
        isiin?.isi = cell.kontenTextView.text
        CoreDataHelper.shared.save{}
        load()
        collectionView.reloadData()
    }
    
}

extension IsiKontenViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    //size cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.size.width
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
}
