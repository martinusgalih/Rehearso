//
//  IsiKontenController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 09/08/21.
//

import UIKit
import CoreData
class IsiKontenViewController: UIViewController {

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
    var index = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        isiKontenCollectionView.backgroundColor = UIColor.clear
        if isiData.count == 0 && index == 0 {
            guard let section1 = sections else {
                print("error load section")
                return
            }

            setIsi(part: "1", title: "1", content: "1", example: "1", section: section1)
            isiData = CoreDataHelper.shared.fetchIsi(section: section1)

            isiin = isiData[0]
            CoreDataHelper.shared.setIsiKonten(title: "Grab Attention", content: "Do or say something shocking, intriguing, or dramatic to get attention of the audience from the very first minutes.", example: "Hello, everyone. Today is our wonderful day...", isi: isiData[0])
            CoreDataHelper.shared.setIsiKonten(title: "Reason To Listen", content: "Give the audience a reason why your presentation is relevant / worth listening to", example: "You need to know why today is wonderful day...", isi: isiData[0])
            CoreDataHelper.shared.setIsiKonten(title: "State Topic", content: "Announce what your speech is about, and your position.", example: "Bitcoin was not environtmentally friendly", isi: isiData[0])
            CoreDataHelper.shared.setIsiKonten(title: "Credibility Statement", content: "What have you done prior to the presentation that is relevant to the credibility of your presentation", example: "I was observe bitcoin the last 2 years", isi: isiData[0])
            CoreDataHelper.shared.setIsiKonten(title: "Preview Statement", content: "    Introduce main points of your speech.", example: "Our main topic is the impact of bitcoin on the environment", isi: isiData[0])
        } else if isiData.count == 0 && index == 1 {
            guard let section1 = sections else {
                print("error load section")
                return
            }

            setIsi(part: "1", title: "1", content: "1", example: "1", section: section1)
            isiData = CoreDataHelper.shared.fetchIsi(section: section1)
            isiin = isiData[0]
            CoreDataHelper.shared.setIsiKonten(title: "Summary", content: "Restate Thesis and main points", example: "So the bitcoin like 2 side of coin", isi: isiData[0])
            CoreDataHelper.shared.setIsiKonten(title: "Closure", content: "Give the audience statement to close your presentation", example: "Ok Thats all", isi: isiData[0])
        }
        
        print("Hasil\(isiData)")
        isiKontenCollectionView.delegate = self
        isiKontenCollectionView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
        print("Will Appear")
    }
    
    func setIsi(part: String, title: String, content: String, example: String, section: Section) {
        let isii = Isi(context: CoreDataHelper.shared.coreDataHelper.viewContext)
        isii.id = UUID()
        isii.title = title
        isii.content = content
        isii.example = example
        isii.part = part
        isii.section = section
        CoreDataHelper.shared.save{}
    }

    
    private func setTableViewCell(){
        let nib = UINib(nibName: tableCellName, bundle: nil)
        isiKontenCollectionView.register(nib, forCellWithReuseIdentifier: tableCellName)
    }
    private func load(){
        guard let isi = isiin else {
            print("error load load")
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

extension IsiKontenViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
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

