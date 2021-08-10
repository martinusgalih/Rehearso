//
//  IsiKontenController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 09/08/21.
//

import UIKit
import CoreData
class IsiKontenController: UIViewController {

    @IBOutlet weak var judulKonten: UILabel!
    @IBOutlet weak var exampleKonten: UILabel!
    @IBOutlet weak var textInputKonten: UITextView!
    @IBOutlet weak var isiKontenCollectionView: UICollectionView!
    
    @IBOutlet var selfPageController: UIPageControl!
    
    var firstLoad = true
    
    var isiData : [Isi] = []
    var isiin: Isi?
    var konten: [IsiKonten] = []
    var isiKonten: IsiKonten?
    private var tableCellName : String = "EditCollectionViewCell"
    var section : [Section] = []
    var sections: Section?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        isiKontenCollectionView.backgroundColor = UIColor.clear
        
        
        guard let isi = isiin else {
            print("error load")
            return
        }
        print("Hasil\(isiData)")
        isiKontenCollectionView.delegate = self
        isiKontenCollectionView.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
        print("Will Appear")
    }
    private func setTableViewCell(){
        let nib = UINib(nibName: tableCellName, bundle: nil)
        isiKontenCollectionView.register(nib, forCellWithReuseIdentifier: tableCellName)
    }
    private func load(){
        guard let isi = isiin else {
            print("error load")
            return
        }
        konten = CoreDataHelper.shared.fetchIsiKonten(isi: isi) {
            self.isiKontenCollectionView.reloadData()
        }
        print("Coba \(konten[0].content)")
        
    }
    @IBAction func saveButton(_ sender: Any) {
        

    }
}

extension IsiKontenController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
  
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let itemWidth = collectionView.frame.size.width
////        let itemHeight = (collectionView.frame.size.height)
//        let itemWidth = 340
//        let itemHeight = 667
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return konten.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditDataCollectionViewCell", for: indexPath) as! EditDataCollectionViewCell
        let kontens = konten[indexPath.row]
        cell.kontenTitleLabel.text = kontens.title
        cell.exampleTextView.text = kontens.example
        cell.kontenTextView.text = kontens.content
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "InputViewController") as? InputViewController {
            vc.isiin = isiin
            vc.isiKonten = self.konten[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: false)
            print("udah")
        }
    }
}

