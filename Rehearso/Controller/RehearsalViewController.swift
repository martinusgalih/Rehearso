//
//  RehearsalViewController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 10/08/21.
//

import UIKit

class RehearsalViewController: UIViewController {

    @IBOutlet weak var rehearsalCollection: UICollectionView!
    
    var titleOfPage: [String] = ["Grab Attention","Reason To Listen","State Topic","Credibility Statement","Preview Statement"]
    
    var examples: [String] = ["Example 1","Example 2","Example 3","Example 4","Example 5"]
    
    var isiText: [String] = ["WKWKWKWKWKWKWKWKWKWKWKWK","HAHAAHAHAHAHAHAHHA","LALALLALALLAALLALAAL","PAPAPAPAPAPPAPA","WAWAWWAWAWAWAWAW"]
    
    @IBOutlet weak var myPage: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myPage.currentPage = 0
        myPage.numberOfPages = titleOfPage.count
        
        rehearsalCollection.delegate = self
        rehearsalCollection.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rehearsalCollection.reloadData()
    }
    
}

extension RehearsalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let x = scrollView.contentOffset.x
            let w = scrollView.bounds.size.width
            let currentPage = Int(ceil(x/w))
            self.myPage.currentPage = currentPage
        }
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleOfPage.count
        return examples.count
        return isiText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rehearsalCell", for: indexPath) as! rehearsalCollectionCell
        
        cell.judulRehearsal.text = titleOfPage[indexPath.row]
        cell.exampleRehearsal.text = examples[indexPath.row]
        cell.isiKontenRehearsal.text = isiText[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        myPage.currentPage = indexPath.row
    }
    
}

