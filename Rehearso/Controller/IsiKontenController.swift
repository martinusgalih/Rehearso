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
        print("Coba ini \(isiin)")
        if(firstLoad)
        {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "IsiKonten")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! IsiKonten
                    konten.append(note)
                    isiKontenCollectionView.reloadData()
                    print("Berhasil Reload Harusnya")
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
        
        
        guard let isi = isiin else {
            print("error load")
            return
        }
        print("Hasil\(isiData)")
        isiKontenCollectionView.delegate = self
        isiKontenCollectionView.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        guard let isi = isiin else {
//            print("error load")
//            return
//        }
//        load()
//        isiKontenCollectionView.reloadData()
//        konten = CoreDataHelper.shared.fetchIsiKonten(isi: isi)
//        isiKontenCollectionView.reloadData()
        
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
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditDataCollectionViewCell", for: indexPath) as! EditDataCollectionViewCell
//        let isiList = isiData[indexPath.row]
//        isiin?.part = cell.titleLabel.text
//        isiin?.isi = cell.text.text
//        CoreDataHelper.shared.save{}
//        load()
//        collectionView.reloadData()
    }
}

extension IsiKontenController: UICollectionViewDelegate, UICollectionViewDataSource{
    //pagecontrol
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.x
//        let w = scrollView.bounds.size.width
//        let currentPage = Int(ceil(x/w))
//        self.selfPageController.currentPage = currentPage
//
//    }
    //size cell
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//   let itemWidth = collectionView.frame.size.width
//        let itemHeight = (collectionView.frame.size.height)
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
    // spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return konten.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditDataCollectionViewCell", for: indexPath) as! EditDataCollectionViewCell
        let kontens = konten[indexPath.row]
        cell.kontenTitleLabel.text = kontens.title
        cell.exampleKonten.text = kontens.example
        cell.kontenTextView.text = kontens.content
        cell.backgroundColor = UIColor.init(red: CGFloat.random(in: 0.5...1), green: CGFloat.random(in: 0.5...1), blue: CGFloat.random(in: 0.5...1), alpha: 1)
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

//extension IsiKontenViewController: ViewControllerProtocol{
//    func reloadData() {
//        listDataText  = fetchDataText()
//        tableViewDataText.reloadData()
//        if !listDataText.isEmpty{
//            tableViewDataText.isHidden = false
//            labelEmpty.isHidden = true
//        }
//        else{
//            tableViewDataText.isHidden = true
//            labelEmpty.isHidden = false
//            labelEmpty.text = "There are no document yet.  How about making your own document?"
//        }
